#include "src/test-helpers.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Note: Enable below once needed for debugging failed tests.

#if 0
    QtPrivate::debugDeleteEvents = true;
#endif

    return QTestRunner::run(argc, argv);
}
