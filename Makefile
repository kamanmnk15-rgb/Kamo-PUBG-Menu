export codesign = 0
export ldid = 0

# دیاری کردنی ئەوەی کە تەنها بۆ مۆبایلی نوێ دروستی بکات
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CODM_KAMO

# زیادکردنی فەریمۆرکەکان بۆ ئەوەی UIView بناسێتەوە
CODM_KAMO_FRAMEWORKS = UIKit CoreGraphics ImageIO QuartzCore

CODM_KAMO_FILES = ESP.mm
CODM_KAMO_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
