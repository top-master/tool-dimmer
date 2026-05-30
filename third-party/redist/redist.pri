
!isEmpty(is_app_redist_pri_included): return()
is_app_redist_pri_included = true

unset(REDIST_ARCH)
is64bit: REDIST_ARCH = x64
else: REDIST_ARCH = x86

unset(REDIST_SUFFIX)
CONFIG(debug, debug|release) {
    REDIST_SUFFIX = d
}

# XD and newer Qt versions define QMAKE_MSC_VER.
isEmpty(QMAKE_MSC_VER) {
    QMAKE_MSC_VER = 1600
}

unset(REDIST_FOLDERS)
win32 {
    REDIST_FOLDERS = $$PWD/win/$$REDIST_ARCH/$$QMAKE_MSC_VER$$REDIST_SUFFIX

    greaterThan(QMAKE_MSC_VER, 1899) {
        REDIST_FOLDERS += $$PWD/win/universal
    }
}

!build_pass {
    for(folder, REDIST_FOLDERS) {
        !exists("$$folder"): warning("Redists don't exist at $$folder")
    }
}

defineTest(copyRedist) {
    unset(path)
    DESTDIR = $$shadowed("$$DESTDIR")

    # Ensures "copy_file(...)" does not fail
    # (with "Cannot create %1 for output" error).
    mkpath($$DESTDIR)

    for(folder, REDIST_FOLDERS){
        mkpath("$$folder")

        files = $$files("$$folder/*.dll")
        for(path, files) {
            copy_file("$$path", "$$DESTDIR/")
        }
    }
}

!static : !build_pass {
    copyRedist()
}
