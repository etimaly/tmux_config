#!/bin/bash
# Reads total and available memory from /proc/meminfo, calculates used, and prints MB and percentage.

# Get Total Memory (in KB)
MEM_TOTAL_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)

# Get Available Memory (in KB)
MEM_AVAIL_KB=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)

# Calculate Used and Total in MB
USED_KB=$(( MEM_TOTAL_KB - MEM_AVAIL_KB ))
USED_MB=$(( USED_KB / 1024 ))
TOTAL_MB=$(( MEM_TOTAL_KB / 1024 ))

# Calculate Percentage (using bc for floating-point math)
# If bc is not available, an integer calculation can be used:
# PERCENT=$(( (USED_KB * 100) / MEM_TOTAL_KB ))

# Check if 'bc' is available for precise calculation
if command -v bc >/dev/null 2>&1; then
    # Calculate percentage with one decimal place
    PERCENT=$(echo "scale=1; ($USED_KB * 100) / $MEM_TOTAL_KB" | bc -l)
else
    # Fallback to integer percentage if bc is not installed
    PERCENT=$(( (USED_KB * 100) / MEM_TOTAL_KB ))
fi

# Print the final formatted output: Usage/Total MB (Percentage%)
printf "RAM: %d/%dMB (%.0f%%)" $USED_MB $TOTAL_MB $PERCENT
