@echo off
cls
setlocal EnableDelayedExpansion


SET A=%1
CALL :FUNC
ECHO %A%


GOTO EOF

:FUNC
::SETLOCAL
ECHO %A%
SET A=test

:EOF

