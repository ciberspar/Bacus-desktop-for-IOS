
THEOS_PACKAGE_SCHEME ?=

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
    ARCHS = arm64
    TARGET = iphone:clang:latest:15.0
else
    ARCHS = arm64
    TARGET = iphone:clang:latest:10.0
endif

DEBUG = 1
FINALPACKAGE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BacusDesktop

BacusDesktop_FILES = \
    Tweak.xm \
    Core/BDWindowManager.m \
    Interface/BDDesktopView.m

BacusDesktop_FRAMEWORKS = UIKit

BacusDesktop_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
