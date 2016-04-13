export TARGET = iphone:clang:latest:6.1
export ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

SOURCE_DIR = sources

TWEAK_NAME = NotificationExplorer
NotificationExplorer_FILES = $(foreach ext, c cpp m mm x xm xi xmi, $(wildcard $(SOURCE_DIR)/*.$(ext)))

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard backboardd"
