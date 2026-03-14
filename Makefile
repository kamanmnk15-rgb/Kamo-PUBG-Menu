export codesign = 0
export ldid = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CODM_KAMO

# لێرە تەنها ناوی ئەو فایلانە بنووسە کە هەتە
CODM_KAMO_FILES = ESP.mm
CODM_KAMO_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
