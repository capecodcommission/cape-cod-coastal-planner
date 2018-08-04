IF "%RELEASE_ROOT_DIR%" == "" GOTO NOPATH
:YESPATH
@ECHO The RELEASE_ROOT_DIR environment variable was detected.
%RELEASE_ROOT_DIR%\bin\chip_api.bat eval "ChipApi.ReleaseTasks.seed()"
GOTO END
:NOPATH
@ECHO The RELEASE_ROOT_DIR environment variable must be set to execute this command.
GOTO END
:END