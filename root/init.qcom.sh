#!/system/bin/sh

echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 368640 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 80 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold

#
# start ril-daemon only for targets on which radio is present
#
baseband=`getprop ro.baseband`
netmgr=`getprop ro.use_data_netmgrd`

case "$baseband" in
    "msm" | "csfb" | "svlte2a" | "unknown")
    start ril-daemon
    start qmuxd
    case "$netmgr" in
        "true" | "True" | "TRUE")
        start netmgrd
    esac
esac

#
# Allow unique persistent serial numbers for devices connected via usb
# User needs to set unique usb serial number to persist.usb.serialno
#
serialno=`getprop persist.usb.serialno`
case "$serialno" in
    "") ;; #Do nothing here
    * )
    mount -t debugfs none /sys/kernel/debug
    echo "$serialno" > /sys/kernel/debug/android/serial_number
esac

#
# Allow persistent usb charging disabling
# User needs to set usb charging disabled in persist.usb.chgdisabled
#
target=`getprop ro.product.device`
usbchgdisabled=`getprop persist.usb.chgdisabled`
case "$usbchgdisabled" in
    "") ;; #Do nothing here
    * )
    case $target in
        "msm8660_surf" | "msm8660_csfb")
        echo "$usbchgdisabled" > /sys/module/pmic8058_charger/parameters/disabled
    esac
esac

# enable hwvefs daemon process.
/system/bin/hwvefs /data/hwvefs -o allow_other &
/system/bin/write_NV_114

case "$target" in
    "u8860" | "c8860e" | "u8800pro" | "hwu8800Pro" | "hwu8680" | "hwu8730" | "hwm886" | "hwu8860" | "hwc8860" | "msm7630_surf" | "msm7x30" | "msm7630_1x" | "msm7630_fusion")
        insmod /system/lib/modules/ss_mfcinit.ko
        insmod /system/lib/modules/ss_vencoder.ko
        insmod /system/lib/modules/ss_vdecoder.ko
        chmod 0666 /dev/ss_mfc_reg
        chmod 0666 /dev/ss_vdec
        chmod 0666 /dev/ss_venc

        case "$target" in
        "msm7630_fusion")
        start gpsone_daemon
        esac

        value=`cat /sys/devices/system/soc/soc0/hw_platform`

        case "$value" in
            "FFA" | "SVLTE_FFA")
             # linking to surf_keypad_qwerty.kcm.bin instead of surf_keypad_numeric.kcm.bin so that
             # the UI keyboard works fine.
             ln -s  /system/usr/keychars/surf_keypad_qwerty.kcm.bin /system/usr/keychars/surf_keypad.kcm.bin;;
            "Fluid")
             setprop ro.sf.lcd_density 240
             setprop qcom.bt.dev_power_class 2
             /system/bin/profiler_daemon&;;
            *)
             setprop ro.sf.lcd_density 240
             ln -s  /system/usr/keychars/surf_keypad_qwerty.kcm.bin /system/usr/keychars/surf_keypad.kcm.bin;;

        esac

# Dynamic Memory Managment (DMM) provides a sys file system to the userspace
# that can be used to plug in/out memory that has been configured as unstable.
# This unstable memory can be in Active or In-Active State.
# Each of which the userspace can request by writing to a sys file.

# ro.dev.dmm = 1; Indicates that DMM is enabled in the Android User Space. This
# property is set in the Android system properties file.

# ro.dev.dmm.dpd.start_address is set when the target has a 2x256Mb memory
# configuration. This is also used to indicate that the target is capable of
# setting EBI-1 to Deep Power Down or Self Refresh.

        mem="/sys/devices/system/memory"
        op=`cat $mem/movable_start_bytes`
        case "$op" in
           "0" )
                log -p i -t DMM DMM Disabled. movable_start_bytes not set: $op
            ;;

            "$mem/movable_start_bytes: No such file or directory " )
                log -p i -t DMM DMM Disabled. movable_start_bytes does not exist: $op
            ;;

            * )
                log -p i -t DMM DMM available. movable_start_bytes at $op
                movable_start_bytes=0x`cat $mem/movable_start_bytes`
                block_size_bytes=0x`cat $mem/block_size_bytes`
                block=$(($movable_start_bytes/$block_size_bytes))

                echo $movable_start_bytes > $mem/probe
                case "$?" in
                    "0" )
                        log -p i -t DMM $movable_start_bytes to physical hotplug succeeded.
                    ;;
                    * )
                        log -p e -t DMM $movable_start_bytes to physical hotplug failed.
                        return 1
                    ;;
                esac

               chown system system $mem/memory$block/state

                echo online > $mem/memory$block/state
                case "$?" in
                    "0" )
                        log -p i -t DMM \'echo online\' to logical hotplug succeeded.
                    ;;
                    * )
                        log -p e -t DMM \'echo online\' to logical hotplug failed.
                        return 1
                    ;;
                esac

                setprop ro.dev.dmm.dpd.start_address $movable_start_bytes
                setprop ro.dev.dmm.dpd.block $block
            ;;
        esac

        op=`cat $mem/low_power_memory_start_bytes`
        case "$op" in
            "0" )
                log -p i -t DMM Self-Refresh-Only Disabled. low_power_memory_start_bytes not set:$op
            ;;

            "$mem/low_power_memory_start_bytes No such file or directory " )
                log -p i -t DMM Self-Refresh-Only Disabled. low_power_memory_start_bytes does not exist:$op
            ;;

            * )
                log -p i -t DMM Self-Refresh-Only available. low_power_memory_start_bytes at $op
            ;;
        esac
        ;;
    "msm8660_surf")
        platformvalue=`cat /sys/devices/system/soc/soc0/hw_platform`
        case "$platformvalue" in
         "Fluid")
         setprop ro.sf.lcd_density 240;;
         esac

esac
