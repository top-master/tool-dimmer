
# Ability to share same settings
# (with both frontend and background-service, if any).

win32 {
    LIBS *= -lComctl32 -ldxva2
}

INCLUDEPATH *= \
    $$PWD \
    $$PWD/app/src \
    $$PWD/app/assets \
    $$PWD/third-party
