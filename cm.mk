## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/cdma.mk)

# Release name
PRODUCT_RELEASE_NAME := u8860

# Boot animation
TARGET_BOOTANIMATION_NAME := vertical-480x854

# Inherit device configuration
$(call inherit-product, device/huawei/u8860/u8860.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := u8860
PRODUCT_NAME := cm_u8860
PRODUCT_BRAND := Huawei
PRODUCT_MODEL := u8860
PRODUCT_MANUFACTURER := Huawei

#Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += \
	PRODUCT_NAME=u8860 \
	BUILD_DISPLAY_ID="IMM76I" \
	BUILD_FINGERPRINT=huawei/u8860:4.0.4/IMM76I/223133:userdebug/test-keys \
	PRIVATE_BUILD_DESC="huawei-user 4.0.4 IMM76I 223133 test-keys" \
	BUILD_NUMBER=223133
