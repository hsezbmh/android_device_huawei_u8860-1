# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from u8860 device
$(call inherit-product, device/huawei/u8860/device.mk)

# Include all languages
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# This is where we'd set a backup provider if we had one
#$(call inherit-product, device/sample/products/backup_overlay.mk)

# U8800 uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# USB mass storage
ADDITIONAL_DEFAULT_PROPERTIES += \
    persist.sys.usb.config=mass_storage,adb

# ADB access
ADDITIONAL_DEFAULT_PROPERTIES += \
    persist.service.adb.enable=1

# Sensors (Prebuilt)

# Live Wallpapers
PRODUCT_PACKAGES += \
   	LiveWallpapers \
    	LiveWallpapersPicker \
    	VisualizationWallpapers \
    	librs_jni

# Filesystem management tools
PRODUCT_PACKAGES += \
   	make_ext4fs \
    	setup_fs

# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := full_u8860
PRODUCT_DEVICE := u8860
PRODUCT_BRAND := Android
PRODUCT_MODEL := Full Android on u8860
