
APP_TASK_HANDLER = $$ROOT_PWD/test/config/task-handler.pro
!build_pass: !exists($$APP_TASK_HANDLER) {
    error("Failed to find file: $$APP_TASK_HANDLER")
}

# taskRun(name, arguments)
#
# Executes task-handler with given arguments.
defineTest(taskRun) {
    win32: nil = nul
    else: nil = /dev/null
    qmakeRun($$APP_TASK_HANDLER, \"CONFIG+=force_only_debug\" TASK=\"$$1\" ARG1=\"$$2\" ARG2=\"$$3\" ARG3=\"$$4\" ARG4=\"$$5\" ARG5=\"$$6\" -o - > $$nil )
}

# refreshChangeDate(filePath)
#
# Ensures given file gets re-parsed on next build as well.
defineTest(refreshChangeDate) {
    taskRun("touch", $$1)
}
