DEBUG = 0
FINALPACKAGE = 1

TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CODM_KAMO_Tweak

CODM_KAMO_Tweak_FILES = ESP.mm
CODM_KAMO_Tweak_CFLAGS = -fobjc-arc
CODM_KAMO_Tweak_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
