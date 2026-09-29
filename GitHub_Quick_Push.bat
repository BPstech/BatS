@echo off
setlocal EnableExtensions EnableDelayedExpansion
title GitHub Quick Push

echo.
echo ==========================================
echo       GitHub Quick Push Utility
echo ==========================================
echo.

REM =========================================================
REM 1. Check required software
REM =========================================================

where git >nul 2>&1
if errorlevel 1 (
    echo [SETUP] Git is not installed.
    echo.
    where winget >nul 2>&1
    if errorlevel 1 (
        echo ERROR: winget is not available.
        echo Install Git from https://git-scm.com/download/win
        echo Then run this BAT file again.
        echo.
        pause
        exit /b 1
    )
    echo Installing Git using winget...
    winget install --id Git.Git -e --source winget
    if errorlevel 1 (
        echo.
        echo Git installation failed.
        pause
        exit /b 1
    )
    echo.
    echo Git was installed. Please CLOSE this window and run this BAT file again.
    echo This first run only performs the software setup.
    pause
    exit /b 0
)

where gh >nul 2>&1
if errorlevel 1 (
    echo [SETUP] GitHub CLI is not installed.
    echo.
    where winget >nul 2>&1
    if errorlevel 1 (
        echo ERROR: winget is not available.
        echo Install GitHub CLI from https://cli.github.com/
        echo Then run this BAT file again.
        echo.
        pause
        exit /b 1
    )
    echo Installing GitHub CLI using winget...
    winget install --id GitHub.cli -e --source winget
    if errorlevel 1 (
        echo.
        echo GitHub CLI installation failed.
        pause
        exit /b 1
    )
    echo.
    echo GitHub CLI was installed. Please CLOSE this window and run this BAT file again.
    echo This first run only performs the software setup.
    pause
    exit /b 0
)

REM =========================================================
REM 2. Check Git identity
REM =========================================================

git config --global user.name >nul 2>&1
if errorlevel 1 goto SETUP_IDENTITY

git config --global user.email >nul 2>&1
if errorlevel 1 goto SETUP_IDENTITY

goto CHECK_AUTH

:SETUP_IDENTITY
echo.
echo [SETUP] Git identity is not configured.
echo.

set /p "GIT_NAME=Enter your GitHub/Git name: "
if "!GIT_NAME!"=="" (
    echo Name cannot be empty.
    pause
    exit /b 1
)

set /p "GIT_EMAIL=Enter your GitHub email (or GitHub noreply email): "
if "!GIT_EMAIL!"=="" (
    echo Email cannot be empty.
    pause
    exit /b 1
)

git config --global user.name "!GIT_NAME!"
git config --global user.email "!GIT_EMAIL!"

echo.
echo Git identity configured.
echo.

:CHECK_AUTH
REM =========================================================
REM 3. Check GitHub authentication
REM =========================================================

gh auth status >nul 2>&1
if errorlevel 1 (
    echo [SETUP] GitHub CLI is not authenticated.
    echo.
    echo A GitHub login window/process will start now.
    echo Follow the GitHub authentication instructions.
    echo.
    gh auth login -p https -w

    if errorlevel 1 (
        echo.
        echo GitHub authentication failed or was cancelled.
        pause
        exit /b 1
    )

    echo.
    echo GitHub authentication completed.
    echo.
    echo SETUP IS COMPLETE.
    echo Close this window and run this BAT file again.
    echo The next run will perform the GitHub operation.
    pause
    exit /b 0
)

REM =========================================================
REM 4. Menu
REM =========================================================

echo Current directory:
echo %CD%
echo.
echo Choose an option:
echo.
echo   [1] Push this directory to an EXISTING GitHub repository
echo   [2] Create a NEW GitHub repository and push this directory
echo   [3] Exit
echo.

set /p "CHOICE=Enter 1, 2 or 3: "

if "%CHOICE%"=="1" goto EXISTING_REPO
if "%CHOICE%"=="2" goto NEW_REPO
if "%CHOICE%"=="3" exit /b 0

echo Invalid choice.
pause
exit /b 1

REM =========================================================
REM 5. Existing repository
REM =========================================================

:EXISTING_REPO
echo.
echo ==========================================
echo       EXISTING GITHUB REPOSITORY
echo ==========================================
echo.
set /p "REPO_URL=Paste the GitHub repository URL: "

if "!REPO_URL!"=="" (
    echo Repository URL cannot be empty.
    pause
    exit /b 1
)

REM Remove trailing slash if present
if "!REPO_URL:~-1!"=="/" set "REPO_URL=!REPO_URL:~0,-1!"

REM Initialize repository if necessary
if not exist ".git" (
    echo.
    echo Initializing Git repository...
    git init
    if errorlevel 1 goto FAILED
)

REM Make sure origin points to requested repository
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "!REPO_URL!"
) else (
    git remote set-url origin "!REPO_URL!"
)

echo.
echo Fetching existing repository information...
git fetch origin

if errorlevel 1 (
    echo.
    echo Could not fetch the repository.
    echo Check the URL and your GitHub access.
    goto FAILED
)

REM Determine remote default branch
set "REMOTE_BRANCH="
for /f "delims=" %%B in ('git symbolic-ref --short refs/remotes/origin/HEAD 2^>nul') do set "REMOTE_BRANCH=%%B"

if defined REMOTE_BRANCH (
    set "REMOTE_BRANCH=!REMOTE_BRANCH:origin/=!"
) else (
    set "REMOTE_BRANCH=main"
)

echo Remote branch: !REMOTE_BRANCH!

git branch -M !REMOTE_BRANCH!

echo.
echo WARNING:
echo This operation will make the GitHub repository match the
echo files in THIS directory. Existing GitHub history/files may
echo be overwritten by the force push.
echo.
set /p "CONFIRM=Type PUSH to continue: "

if /I not "!CONFIRM!"=="PUSH" (
    echo Cancelled.
    exit /b 0
)

goto COMMIT_AND_PUSH

REM =========================================================
REM 6. New repository
REM =========================================================

:NEW_REPO
echo.
echo ==========================================
echo          NEW GITHUB REPOSITORY
echo ==========================================
echo.

set /p "NEW_NAME=Enter the new repository name: "
if "!NEW_NAME!"=="" (
    echo Repository name cannot be empty.
    pause
    exit /b 1
)

echo.
echo Choose visibility:
echo   [1] Public
echo   [2] Private
echo.
set /p "VIS=Enter 1 or 2: "

if "%VIS%"=="1" (
    set "VISIBILITY=--public"
) else if "%VIS%"=="2" (
    set "VISIBILITY=--private"
) else (
    echo Invalid choice.
    pause
    exit /b 1
)

REM Initialize local Git repository if needed
if not exist ".git" (
    echo.
    echo Initializing Git repository...
    git init
    if errorlevel 1 goto FAILED
)

REM Create GitHub repository and configure origin
echo.
echo Creating GitHub repository "!NEW_NAME!"...
gh repo create "!NEW_NAME!" !VISIBILITY! --source=. --remote=origin --push

if errorlevel 1 (
    echo.
    echo Repository creation or initial push failed.
    goto FAILED
)

echo.
echo ==========================================
echo SUCCESS
echo ==========================================
echo.
echo GitHub repository created and pushed:
gh repo view --web
echo.
echo Vercel can be connected to this repository if needed.
pause
exit /b 0

REM =========================================================
REM 7. Commit and force push existing repo
REM =========================================================

:COMMIT_AND_PUSH
echo.
echo Configuring this utility to stay out of the repository...

REM Keep this BAT file out of Git even when the BAT itself is
REM located inside the project directory.
set "BAT_NAME=%~nx0"
findstr /x /c:"%BAT_NAME%" ".git\info\exclude" >nul 2>&1
if errorlevel 1 echo %BAT_NAME%>>".git\info\exclude"

REM If this BAT was already tracked by an earlier version,
REM remove it from Git's index but keep the physical file.
git rm --cached -- "%BAT_NAME%" >nul 2>&1

echo.
echo Staging files...
git add .

if errorlevel 1 goto FAILED

echo.
echo Creating commit...
git commit -m "Update website"

if errorlevel 1 (
    echo.
    echo Commit failed.
    echo If Git says "nothing to commit", the repository may
    echo already contain the same files.
    goto FAILED
)

echo.
echo Pushing to GitHub...
git push -u origin !REMOTE_BRANCH! --force

if errorlevel 1 goto FAILED

echo.
echo ==========================================
echo SUCCESS
echo ==========================================
echo.
echo Your local directory has been pushed to GitHub.
echo If this repository is connected to Vercel,
echo Vercel should automatically start a deployment.
echo.
echo Repository:
echo !REPO_URL!
echo.
pause
exit /b 0

REM =========================================================
REM Error handler
REM =========================================================

:FAILED
echo.
echo ==========================================
echo OPERATION FAILED
echo ==========================================
echo.
echo Read the error above before trying again.
echo.
pause
exit /b 1
