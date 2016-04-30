export TARGET = iphone:clang:latest:6.1
export ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotificationExplorer
NotificationExplorer_FILES = $(call findfiles,sources)

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard backboardd"
