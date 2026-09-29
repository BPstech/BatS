@echo off
setlocal

REM Create main folders
mkdir "01_References"
mkdir "02_Parts"
mkdir "03_Assemblies"
mkdir "04_Drawings"
mkdir "05_Exports"
mkdir "06_Simulation"
mkdir "99_Old_Versions"

REM Optional: create subfolders inside Exports
mkdir "05_Exports\STEP"
mkdir "05_Exports\STL"
mkdir "05_Exports\DXF"

echo Folder structure created successfully.
pause
