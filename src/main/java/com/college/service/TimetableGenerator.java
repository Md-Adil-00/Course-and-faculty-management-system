package com.college.service;

import com.college.dao.FacultySubjectDAO;
import com.college.dao.SubjectDAO;
import com.college.dao.SystemConfigDAO;
import com.college.dao.TimetableDAO;
import com.college.model.Batch;
import com.college.model.PeriodTiming;
import com.college.model.Subject;
import com.college.model.SystemConfig;

import java.util.*;

public class TimetableGenerator {

    private final SubjectDAO      subjectDAO = new SubjectDAO();
    private final FacultySubjectDAO  fsDAO   = new FacultySubjectDAO();
    private final TimetableDAO   timetableDAO= new TimetableDAO();
    private final SystemConfigDAO configDAO  = new SystemConfigDAO();
    private final Random random              = new Random();

    // =========================================================
    // PUBLIC ENTRY — generate ALL batches with shared faculty grid
    // =========================================================
    public String generateAll(List<Batch> batches) {

        SystemConfig config = configDAO.getSystemConfig();
        if (config == null) return "ERROR: No system configuration saved.";

        List<String> workingDays = configDAO.getWorkingDayNames();
        if (workingDays.isEmpty()) return "ERROR: No working days configured.";

        List<PeriodTiming> timings = configDAO.getAllPeriods();
        if (timings.isEmpty() || config.getPeriodCount() == 0)
            return "ERROR: Period timings not configured.";

        // Mark which period numbers are breaks (lunch / short break)
        Set<Integer> breakPeriods = new HashSet<>();
        for (PeriodTiming pt : timings) {
            String s = pt.getStartTime(), e = pt.getEndTime();
            if (s == null) continue;
            if (s.equals(config.getLunchStart()) && e.equals(config.getLunchEnd()))
                breakPeriods.add(pt.getPeriodNumber());
            if (config.isShortBreakEnabled()
                    && s.equals(config.getShortBreakStart())
                    && e.equals(config.getShortBreakEnd()))
                breakPeriods.add(pt.getPeriodNumber());
        }

        // Detect periods that have a REAL TIME GAP after them (lunch/break between periods)
        // Labs cannot span across these boundaries
        Set<Integer> gapAfterPeriod = new HashSet<>();
        List<PeriodTiming> sorted = new ArrayList<>(timings);
        sorted.sort(Comparator.comparingInt(p -> toMinutes(p.getStartTime())));
        for (int i = 0; i < sorted.size() - 1; i++) {
            int endCur    = toMinutes(sorted.get(i).getEndTime());
            int startNext = toMinutes(sorted.get(i + 1).getStartTime());
            if (startNext > endCur) {
                gapAfterPeriod.add(sorted.get(i).getPeriodNumber());
                System.out.println("Gap detected after Period " + sorted.get(i).getPeriodNumber()
                        + " (ends " + sorted.get(i).getEndTime()
                        + ", next starts " + sorted.get(i + 1).getStartTime() + ")");
            }
        }

        // Teaching slots in order
        List<Integer> teachingSlots = new ArrayList<>();
        for (int p = 1; p <= config.getPeriodCount(); p++) {
            if (!breakPeriods.contains(p)) teachingSlots.add(p);
        }

        if (teachingSlots.isEmpty()) return "ERROR: No teaching slots after removing breaks.";

        // Shared faculty grid — ONE map for ALL batches
        Map<Integer, Map<String, Set<Integer>>> facultyGrid = new HashMap<>();

        StringBuilder warnings = new StringBuilder();
        for (Batch batch : batches) {
            String w = generateBatch(batch, workingDays, teachingSlots, breakPeriods, gapAfterPeriod, facultyGrid);
            if (!w.isEmpty())
                warnings.append(batch.getBranch().toUpperCase())
                        .append(" Sem").append(batch.getSemester())
                        .append(" Div").append(batch.getDivision())
                        .append(": ").append(w).append("\n");
        }

        return "SUCCESS" + (warnings.length() > 0 ? "\nWarnings:\n" + warnings : "");
    }

    // =========================================================
    // GENERATE ONE BATCH — deterministic, no infinite loops
    // =========================================================
    private String generateBatch(Batch batch,
                                 List<String> workingDays,
                                 List<Integer> teachingSlots,
                                 Set<Integer> breakPeriods,
                                 Set<Integer> gapAfterPeriod,
                                 Map<Integer, Map<String, Set<Integer>>> facultyGrid) {

        int    batchId  = batch.getId();
        String branch   = batch.getBranch();
        int    semester = batch.getSemester();

        timetableDAO.deleteByBatch(batchId);

        List<Subject> subjects = subjectDAO.getSubjectsByBranchAndSemester(branch, semester);
        if (subjects.isEmpty())
            return "No subjects for branch=" + branch + " sem=" + semester + ". ";

        // batchGrid[day][period] = subjectId placed there (-1 = empty)
        Map<String, Map<Integer, Integer>> batchGrid = new HashMap<>();
        for (String d : workingDays) batchGrid.put(d, new HashMap<>());

        // Build all possible (day, period) slots in shuffled order
        List<String[]> allSlots = new ArrayList<>();
        for (String d : workingDays)
            for (int p : teachingSlots)
                allSlots.add(new String[]{d, String.valueOf(p)});

        // Build a pool of subject slots to place:
        // e.g. Maths 6 hours/week = 6 entries of Maths in the pool
        List<Subject> labSubjects     = new ArrayList<>();
        List<Subject> regularSubjects = new ArrayList<>();
        for (Subject s : subjects) {
            if (s.isLab()) labSubjects.add(s);
            else           regularSubjects.add(s);
        }

        // Slots to insert into DB at the end
        List<String>  insertDays     = new ArrayList<>();
        List<int[]>   insertSlots    = new ArrayList<>();

        StringBuilder warnings = new StringBuilder();

        // ── 1. Place LABS first (need 2 consecutive slots) ─────
        for (Subject lab : labSubjects) {
            List<Integer> facultyIds = fsDAO.getFacultyBySubject(lab.getId());
            if (facultyIds.isEmpty()) {
                warnings.append("No faculty for lab: ").append(lab.getSubjectName()).append(". ");
                continue;
            }

            int toPlace = lab.getHoursPerWeek();
            // Build list of consecutive slot pairs, shuffled
            List<int[]> pairs = findConsecutivePairs(teachingSlots, breakPeriods, gapAfterPeriod);
            Collections.shuffle(pairs, random);
            List<String> shuffledDays = new ArrayList<>(workingDays);

            int placed = 0;
            outer:
            for (String day : shuffledDays) {
                if (placed >= toPlace) break;
                Map<Integer, Integer> dg = batchGrid.get(day);

                // Only 1 lab session per day TOTAL (any lab subject)
                if (hasAnyLabToday(dg, labSubjects)) continue;

                Collections.shuffle(pairs, random);
                for (int[] pair : pairs) {
                    if (placed >= toPlace) break outer;
                    int p1 = pair[0], p2 = pair[1];
                    if (dg.containsKey(p1) || dg.containsKey(p2)) continue;

                    int fid = pickFaculty(facultyIds, day, p1, p2, facultyGrid);
                    if (fid == -1) continue;

                    dg.put(p1, lab.getId());
                    dg.put(p2, lab.getId());
                    markFaculty(facultyGrid, fid, day, p1);
                    markFaculty(facultyGrid, fid, day, p2);

                    insertDays.add(day); insertSlots.add(new int[]{batchId, p1, lab.getId(), fid});
                    insertDays.add(day); insertSlots.add(new int[]{batchId, p2, lab.getId(), fid});
                    placed += 2;
                    break; // one lab session per day
                }
            }

            if (placed < toPlace)
                warnings.append("Placed ").append(placed).append("/")
                        .append(toPlace).append(" for lab ").append(lab.getSubjectName()).append(". ");
        }

        // ── 2. Place REGULAR subjects ───────────────────────────
        // Build a flat list of (subject, periodsNeeded) shuffled
        Collections.shuffle(regularSubjects, random);

        for (Subject subject : regularSubjects) {
            List<Integer> facultyIds = fsDAO.getFacultyBySubject(subject.getId());
            if (facultyIds.isEmpty()) {
                warnings.append("No faculty for: ").append(subject.getSubjectName()).append(". ");
                continue;
            }

            int toPlace = subject.getHoursPerWeek();
            int placed  = 0;

            // Shuffle all slots and iterate — deterministic, no retry loop
            Collections.shuffle(allSlots, random);

            for (String[] slot : allSlots) {
                if (placed >= toPlace) break;

                String day    = slot[0];
                int    period = Integer.parseInt(slot[1]);
                Map<Integer, Integer> dg = batchGrid.get(day);

                if (dg.containsKey(period)) continue;
                if (countSubject(dg, subject.getId()) >= 2) continue;
                if (wouldBeThreeConsecutive(batchGrid, day, period, subject.getId())) continue;

                int fid = pickFaculty(facultyIds, day, period, -1, facultyGrid);
                if (fid == -1) continue;

                dg.put(period, subject.getId());
                markFaculty(facultyGrid, fid, day, period);

                insertDays.add(day);
                insertSlots.add(new int[]{batchId, period, subject.getId(), fid});
                placed++;
            }

            if (placed < toPlace)
                warnings.append("Placed ").append(placed).append("/")
                        .append(toPlace).append(" for ").append(subject.getSubjectName()).append(". ");
        }

        // ── Bulk insert all slots ───────────────────────────────
        for (int i = 0; i < insertSlots.size(); i++) {
            int[] s = insertSlots.get(i);
            timetableDAO.insertSlot(s[0], insertDays.get(i), s[1], s[2], s[3]);
        }

        System.out.println("Generated: " + branch + " Sem" + semester
                + " Div" + batch.getDivision() + " -> " + insertSlots.size() + " slots");

        return warnings.toString();
    }

    // ── Convert HH:mm or HH:mm:ss to minutes since midnight ─────
    private int toMinutes(String time) {
        if (time == null || time.isEmpty()) return 0;
        try {
            String[] p = time.split(":");
            return Integer.parseInt(p[0]) * 60 + Integer.parseInt(p[1]);
        } catch (Exception e) { return 0; }
    }

    // ── Build list of all consecutive period pairs ───────────────
    private List<int[]> findConsecutivePairs(List<Integer> slots,
                                             Set<Integer> breakPeriods,
                                             Set<Integer> gapAfterPeriod) {
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < slots.size() - 1; i++) {
            int p1 = slots.get(i);
            int p2 = slots.get(i + 1);

            // Block if there's a lunch/break gap after p1
            if (gapAfterPeriod.contains(p1)) continue;

            // Block if any break period sits between p1 and p2
            boolean clear = true;
            for (int mid = p1 + 1; mid < p2; mid++) {
                if (breakPeriods.contains(mid)) { clear = false; break; }
            }
            if (clear) pairs.add(new int[]{p1, p2});
        }
        return pairs;
    }

    // ── Check if any lab subject is already placed today ─────────
    private boolean hasAnyLabToday(Map<Integer, Integer> dayGrid, List<Subject> labs) {
        for (Subject lab : labs)
            if (countSubject(dayGrid, lab.getId()) > 0) return true;
        return false;
    }

    // ── Count occurrences of subjectId in a day's grid ───────────
    private int countSubject(Map<Integer, Integer> dayGrid, int subjectId) {
        int count = 0;
        for (int sid : dayGrid.values()) if (sid == subjectId) count++;
        return count;
    }

    // ── Check if placing subjectId at period would make 3 in a row ─
    private boolean wouldBeThreeConsecutive(Map<String, Map<Integer, Integer>> batchGrid,
                                            String day, int period, int subjectId) {
        Map<Integer, Integer> dg = batchGrid.get(day);
        int b1 = dg.getOrDefault(period - 1, -1);
        int b2 = dg.getOrDefault(period - 2, -1);
        int a1 = dg.getOrDefault(period + 1, -1);
        int a2 = dg.getOrDefault(period + 2, -1);

        if (b1 == subjectId && b2 == subjectId) return true;
        if (a1 == subjectId && a2 == subjectId) return true;
        if (b1 == subjectId && a1 == subjectId) return true;
        return false;
    }

    // ── Pick faculty free at p1 (and p2 if != -1) ────────────────
    private int pickFaculty(List<Integer> ids, String day, int p1, int p2,
                            Map<Integer, Map<String, Set<Integer>>> grid) {
        List<Integer> shuffled = new ArrayList<>(ids);
        Collections.shuffle(shuffled, random);
        for (int fid : shuffled) {
            Set<Integer> busy = grid
                    .computeIfAbsent(fid, k -> new HashMap<>())
                    .computeIfAbsent(day, k -> new HashSet<>());
            if (!busy.contains(p1) && (p2 == -1 || !busy.contains(p2)))
                return fid;
        }
        return -1;
    }

    // ── Mark faculty busy ─────────────────────────────────────────
    private void markFaculty(Map<Integer, Map<String, Set<Integer>>> grid,
                             int fid, String day, int period) {
        grid.computeIfAbsent(fid, k -> new HashMap<>())
                .computeIfAbsent(day, k -> new HashSet<>())
                .add(period);
    }
}