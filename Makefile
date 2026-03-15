DEBUG = 0
FINALPACKAGE = 1

TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KamoPUBG

KamoPUBG_FILES = ESP.mm
KamoPUBG_CFLAGS = -fobjc-arc
KamoPUBG_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
