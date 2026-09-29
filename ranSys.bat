@echo off
:loop
start msinfo32
start calc
start mspaint
start explorer
timeout /t 5 >nul
goto loop
