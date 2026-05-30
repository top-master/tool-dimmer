
# First, ensures search-pattern result contains newly added source-files
# (because else IDE may not re-run qmake-script).
refreshChangeDate($$PWD/test.pro)

# Ensures right name is used
# (because some QMake parsers exit once name is found).
include($$PWD/config/test-mode.pri)

# Then import testee (which is only possible because,
# we exclude reapet sensitive scripts from what needs to be tested).
VPATH *= $$clean_path($$PWD/../)
include($$PWD/../app/app.pro)
SOURCES -= $$clean_path($$PWD/../app/src/main-app.cpp)

# Restores to test-mode (because maybe was overridden above).
include($$PWD/config/test-mode.pri)

#CONFIG += console

# Absolute-path for later copy calls
DESTDIR = ../dimmer bin
DESTDIR = $$clean_path( $$shadowed( $$DESTDIR ) )


# Redist.
#
isXD {
    copyModuleList("$$DESTDIR/")
    #copySqlDriver(sqlite, $$DESTDIR/sqldrivers/)
    copyPlatformDriver(windows, $$DESTDIR/platforms/)
}

SOURCES += \
    main-tests.cpp \
    $$files($$PWD/src/*.cpp, true)
