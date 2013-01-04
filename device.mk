$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_as_supl.mk)
$(call inherit-product-if-exists, vendor/huawei/u8860/u8860-vendor.mk)
# Inherit from the common msm7x30 definitions
$(call inherit-product, device/huawei/msm7x30-common/common.mk)

DEVICE_PACKAGE_OVERLAYS += device/huawei/u8860/overlay

# Extra
#PRODUCT_PACKAGES += \
#    DisplayFix

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml

# init
PRODUCT_COPY_FILES += \
    device/huawei/u8860/root/init.qcom.sh:root/init.qcom.sh \
    device/huawei/u8860/root/init.qcom.usb.sh:root/init.qcom.usb.sh

