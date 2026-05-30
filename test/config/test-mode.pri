TEMPLATE = app
TARGET = app-test-runner
QT *= testlib
CONFIG *= testcase
lessThan(QT_MAJOR_VERSION, 5) {
    CONFIG *= qtestlib
}
mac:CONFIG -= app_bundle

DEFINES *= IS_TEST_RUN
