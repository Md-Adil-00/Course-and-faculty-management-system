package com.college.model;

public class SystemConfig {

    private int periodCount;
    private String lunchStart;
    private String lunchEnd;
    private boolean shortBreakEnabled;
    private String shortBreakStart;
    private String shortBreakEnd;

    public int getPeriodCount() { return periodCount; }
    public void setPeriodCount(int periodCount) { this.periodCount = periodCount; }

    public String getLunchStart() { return lunchStart; }
    public void setLunchStart(String lunchStart) { this.lunchStart = lunchStart; }

    public String getLunchEnd() { return lunchEnd; }
    public void setLunchEnd(String lunchEnd) { this.lunchEnd = lunchEnd; }

    public boolean isShortBreakEnabled() { return shortBreakEnabled; }
    public void setShortBreakEnabled(boolean shortBreakEnabled) { this.shortBreakEnabled = shortBreakEnabled; }

    public String getShortBreakStart() { return shortBreakStart; }
    public void setShortBreakStart(String shortBreakStart) { this.shortBreakStart = shortBreakStart; }

    public String getShortBreakEnd() { return shortBreakEnd; }
    public void setShortBreakEnd(String shortBreakEnd) { this.shortBreakEnd = shortBreakEnd; }
}