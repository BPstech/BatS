@echo off
title Ultimate Downloads Sorter

:: =========================================
:: CREATE FOLDERS
:: =========================================

mkdir Images 2>nul
mkdir Videos 2>nul
mkdir Audio 2>nul
mkdir Documents 2>nul
mkdir Archives 2>nul
mkdir Installers 2>nul
mkdir Code 2>nul
mkdir Fonts 2>nul
mkdir Torrents 2>nul
mkdir Shortcuts 2>nul
mkdir Others 2>nul

:: =========================================
:: IMAGES
:: =========================================

move *.jpg Images 2>nul
move *.jpeg Images 2>nul
move *.png Images 2>nul
move *.gif Images 2>nul
move *.bmp Images 2>nul
move *.webp Images 2>nul
move *.svg Images 2>nul
move *.ico Images 2>nul
move *.heic Images 2>nul
move *.tiff Images 2>nul
move *.avif Images 2>nul
move *.raw Images 2>nul

:: =========================================
:: VIDEOS
:: =========================================

move *.mp4 Videos 2>nul
move *.mkv Videos 2>nul
move *.avi Videos 2>nul
move *.mov Videos 2>nul
move *.wmv Videos 2>nul
move *.flv Videos 2>nul
move *.webm Videos 2>nul
move *.mpeg Videos 2>nul
move *.3gp Videos 2>nul

:: =========================================
:: AUDIO
:: =========================================

move *.mp3 Audio 2>nul
move *.wav Audio 2>nul
move *.flac Audio 2>nul
move *.aac Audio 2>nul
move *.ogg Audio 2>nul
move *.m4a Audio 2>nul
move *.wma Audio 2>nul

:: =========================================
:: DOCUMENTS
:: =========================================

move *.pdf Documents 2>nul
move *.doc Documents 2>nul
move *.docx Documents 2>nul
move *.ppt Documents 2>nul
move *.pptx Documents 2>nul
move *.xls Documents 2>nul
move *.xlsx Documents 2>nul
move *.txt Documents 2>nul
move *.rtf Documents 2>nul
move *.csv Documents 2>nul
move *.odt Documents 2>nul
move *.ods Documents 2>nul
move *.epub Documents 2>nul

:: =========================================
:: ARCHIVES
:: =========================================

move *.zip Archives 2>nul
move *.rar Archives 2>nul
move *.7z Archives 2>nul
move *.tar Archives 2>nul
move *.gz Archives 2>nul
move *.iso Archives 2>nul

:: =========================================
:: INSTALLERS
:: =========================================

move *.exe Installers 2>nul
move *.msi Installers 2>nul
move *.apk Installers 2>nul

:: =========================================
:: CODE FILES
:: =========================================

move *.py Code 2>nul
move *.java Code 2>nul
move *.cpp Code 2>nul
move *.c Code 2>nul
move *.html Code 2>nul
move *.css Code 2>nul
move *.js Code 2>nul
move *.json Code 2>nul
move *.xml Code 2>nul
move *.sql Code 2>nul

:: =========================================
:: FONTS
:: =========================================

move *.ttf Fonts 2>nul
move *.otf Fonts 2>nul

:: =========================================
:: TORRENTS
:: =========================================

move *.torrent Torrents 2>nul

:: =========================================
:: SHORTCUTS
:: =========================================

move *.lnk Shortcuts 2>nul

:: =========================================
:: MOVE REMAINING FILES ONLY
:: SKIPS FOLDERS + SKIPS .BAT FILES
:: =========================================

for %%F in (*) do (
    if not "%%~xF"==".bat" (
        if not exist "%%F\" (
            move "%%F" Others 2>nul
        )
    )
)

:: =========================================
:: DELETE EMPTY FOLDERS
:: =========================================

for /f "delims=" %%D in ('dir /ad /b') do (
    rd "%%D" 2>nul
)

:: =========================================
:: DONE
:: =========================================

echo.
echo =====================================
echo     FILES SORTED SUCCESSFULLY
echo =====================================
echo.

pause