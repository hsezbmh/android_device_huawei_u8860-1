# Correct bootanimation size for the screen
TARGET_BOOTANIMATION_NAME := vertical-480x854

# Inherit device configuration
$(call inherit-product, device/huawei/u8860/u8860.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_mini_phone.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/gsm.mk)

# Setup device configuration
PRODUCT_NAME := shendu_u8860
PRODUCT_DEVICE := u8860
PRODUCT_BRAND := Huawei
PRODUCT_MODEL := U8860
PRODUCT_MANUFACTURER := Huawei
PRODUCT_RELEASE_NAME := U8860

#Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += \
	PRODUCT_NAME=u8860 \
	BUILD_FINGERPRINT=huawei/u8860:4.2.1/IMM76L/223155:userdebug/test-keys \
	PRIVATE_BUILD_DESC="huawei-user 4.2.1 IMM76L 223155 test-keys" \
	BUILD_NUMBER=223155
