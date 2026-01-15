@echo off
echo Fixing Deplyment...
echo.

REM 1. Ensure we are in the project root
cd /d "%~dp0"

REM 2. Run the build script to get fresh assets
call build_github_pages.bat

REM 3. Sync build/web contents to build/ (the git root for deployment)
echo Syncing build/web to build...
xcopy /E /H /Y build\web\* build\

REM 4. Move to the deployment directory
cd build

REM 5. Stage, commit and push
echo Staging changes for deployment...
git add .
git commit -m "chore: deploy latest enhancements to GitHub Pages"
git push origin main

echo.
echo Deployment fix complete! Please wait a minute for GitHub Pages to update.
echo Check: https://mohamedadel120.github.io/my-Portfolio/
pause
