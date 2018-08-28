#!/bin/env bash

set -- $(nvidia-settings \
    -q '[fan:0]/GPUCurrentFanSpeed' \
    -q '[fan:0]/GPUCurrentFanSpeedRPM' \
    -q '[gpu:0]/gpucoretemp' \
    -q '[gpu:0]/GPUCurrentClockFreqs' -t; \
cat /sys/class/hwmon/hwmon0/temp*_input \
    /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq \
    /sys/class/hwmon/hwmon1/temp1_input \
    /sys/class/hwmon/hwmon1/temp2_input \
    /sys/class/hwmon/hwmon1/temp3_input \
    /sys/class/hwmon/hwmon1/pwm2 \
    /sys/class/hwmon/hwmon1/pwm3 \
    /sys/class/hwmon/hwmon1/fan4_input \
    /sys/class/hwmon/hwmon1/fan5_input 2>/dev/null \
    | sed 's/\(.\+\)\(...\)$/\1.\2/')

# 1: GPUFan%
# 2: GPUFanRPM
# 3: GPUTemp
# 4: GPUFreqs
# 5-9: CPUCoreTemps (5=Overall)
# 10-13:CPUFreqs
# 14:SystemTemp
# 15:CPUTemp
# 16:AuxTemp
# 17:CPUFanPWM
# 18:CaseFan5PWM
# 19:Top140RPM
# 20:CaseFan5RPM

# Nice output here using positional parameters
