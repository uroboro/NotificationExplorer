include ./theos/makefiles/common.mk

TWEAK_NAME = NotificationExplorer
uroboro_SOURCES = sources
uroboro_FILES += $(wildcard $(uroboro_SOURCES)/*.c)
uroboro_FILES += $(wildcard $(uroboro_SOURCES)/*.cpp)
uroboro_FILES += $(wildcard $(uroboro_SOURCES)/*.m)
uroboro_FILES += $(wildcard $(uroboro_SOURCES)/*.mm)
uroboro_FILES += $(wildcard $(uroboro_SOURCES)/*.x)
uroboro_FILES += $(wildcard $(uroboro_SOURCES)/*.xm)
NotificationExplorer_FILES = $(uroboro_FILES)

include $(THEOS)/makefiles/tweak.mk

a:
	

an:
	

and:
	

_install:
	@sudo make internal-install

#now do 'make a clean package and _install'

remove:
	@apt-get remove $(THEOS_PACKAGE_NAME)

after-install::
	install.exec "killall -9 SpringBoard backboardd"
