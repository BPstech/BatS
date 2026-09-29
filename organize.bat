@echo off
setlocal enabledelayedexpansion

:: Get current directory
set "CURRENT_DIR=%~dp0"
cd /d "%CURRENT_DIR%"

:: Category extensions
set "Images=jpg jpeg png gif bmp webp"
set "Videos=mp4 mkv avi mov wmv"
set "Music=mp3 wav flac m4a"
set "Documents=pdf doc docx txt ppt pptx xls xlsx csv"
set "Executables=exe msi bat sh"
set "Archives=zip rar 7z tar gz iso"

:: Loop through files
for %%F in (*.*) do (
    if /I not "%%~nxF"=="%~nx0" (
        set "ext=%%~xF"
        set "ext=!ext:~1!"
        set "file=%%F"
        set "moved=0"

        :: Check and move to each category
        for %%I in (%Images%) do if /I "!ext!"=="%%I" (
            if not exist Images mkdir Images
            move "%%F" Images >nul
            set "moved=1"
        )

        if "!moved!"=="0" (
            for %%V in (%Videos%) do if /I "!ext!"=="%%V" (
                if not exist Videos mkdir Videos
                move "%%F" Videos >nul
                set "moved=1"
            )
        )

        if "!moved!"=="0" (
            for %%M in (%Music%) do if /I "!ext!"=="%%M" (
                if not exist Music mkdir Music
                move "%%F" Music >nul
                set "moved=1"
            )
        )

        if "!moved!"=="0" (
            for %%D in (%Documents%) do if /I "!ext!"=="%%D" (
                if not exist Documents mkdir Documents
                move "%%F" Documents >nul
                set "moved=1"
            )
        )

        if "!moved!"=="0" (
            for %%E in (%Executables%) do if /I "!ext!"=="%%E" (
                if not exist Executables mkdir Executables
                move "%%F" Executables >nul
                set "moved=1"
            )
        )

        if "!moved!"=="0" (
            for %%Z in (%Archives%) do if /I "!ext!"=="%%Z" (
                if not exist Archives mkdir Archives
                move "%%F" Archives >nul
                set "moved=1"
            )
        )

        if "!moved!"=="0" (
            if not exist Others mkdir Others
            move "%%F" Others >nul
        )
    )
)

echo Files sorted successfully.
pause
