TEMPLATE = subdirs

CONFIG += ordered

# WARNING; order matters below (if not always).
SUBDIRS += \
    $$PWD/third-party \
    $$PWD/app \
    $$PWD/test

OTHER_FILES += \
    $$PWD/README.md \
    $$PWD/.qmake.conf \
    $$PWD/test/config/functions.pri \
    $$PWD/test/config/task-handler.pro \
    # List termination comment.
