#!/system/bin/sh

chown root.system /sys/devices/platform/msm_hsusb/gadget/wakeup
chmod 220 /sys/devices/platform/msm_hsusb/gadget/wakeup

#
# Allow persistent usb charging disabling
# User needs to set usb charging disabled in persist.usb.chgdisabled
#

#
# Allow USB enumeration with default PID/VID
#
baseband=`getprop ro.baseband`
echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
usb_config=`getprop persist.sys.usb.config`
case "$usb_config" in
    "" | "adb") #USB persist config not set, select default configuration
        case $target in
            "msm8960")
                socid=`cat /sys/devices/system/soc/soc0/id`
                case "$socid" in
                    "109")
                         setprop persist.sys.usb.config diag,adb
                    ;;
                    *)
                        case "$baseband" in
                            "mdm")
                                 setprop persist.sys.usb.config diag,diag_mdm,serial_hsic,serial_tty,rmnet_hsic,mass_storage,adb
                            ;;
                            *)
                                 setprop persist.sys.usb.config diag,serial_smd,serial_tty,rmnet_bam,mass_storage,adb
                            ;;
                        esac
                    ;;
                esac
            ;;
            "msm7627a")
                setprop persist.sys.usb.config diag,serial_smd,serial_tty,rmnet_smd,mass_storage,adb
            ;;
            * )
                case "$baseband" in
                    "svlte2a")
                         setprop persist.sys.usb.config diag,diag_mdm,serial_sdio,serial_smd,rmnet_smd_sdio,mass_storage,adb
                    ;;
                    "csfb")
                         setprop persist.sys.usb.config diag,diag_mdm,serial_sdio,serial_tty,rmnet_sdio,mass_storage,adb
                    ;;
                    *)
                         setprop persist.sys.usb.config diag,serial_tty,serial_tty,rmnet_smd,mass_storage,adb
                    ;;
                esac
            ;;
        esac
    ;;
    * ) ;; #USB persist config exists, do nothing
esac

