export codesign = 0
export ldid = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CODM_KAMO

CODM_KAMO_FILES = Tweak.x ESP.mm
CODM_KAMO_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
