TEMPLATE = app

TARGET = dimmer
CONFIG -= qt
CONFIG += windows c++14
CONFIG += force_debug_info
CONFIG -= debug_and_release

DESTDIR = ../dimmer bin
DESTDIR = $$shadowed( $$DESTDIR ) #make absolute for later copy calls

# First, ensures search-pattern result contains newly added source-files
# (because else IDE may not re-run qmake-script).
refreshChangeDate($$PWD/app.pro)

include($$PWD/../shared-settings.pri)

win32 {
    DEFINES += WIN32_LEAN_AND_MEAN NOMINMAX _CRT_SECURE_NO_WARNINGS UNICODE _UNICODE
    LIBS += -lComctl32 -ldxva2
}

RC_FILE = $$PWD/assets/main.rc

HEADERS *= \
    $$files($$PWD/src/*.h, true) \
    # List termination comment.

SOURCES *= \
    $$files($$PWD/src/*.cpp, true) \
    # List termination comment.

# Excludes unrequired sources.
!win32: SOURCES ~= s|.*_win\\.cpp$||g
!linux: SOURCES ~= s|.*_linux\\.cpp$||g
