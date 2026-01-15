@echo off
echo Building Flutter web app for GitHub Pages...
echo.

REM Clean previous build
echo Cleaning previous build...
flutter clean

REM Get dependencies
echo Getting dependencies...
flutter pub get

REM Build for GitHub Pages with correct base-href
echo Building for GitHub Pages (base-href: /my-Portfolio/)...
flutter build web --release --base-href="/my-Portfolio/"

REM Create .nojekyll file to prevent Jekyll processing
echo Creating .nojekyll file...
echo. > build\web\.nojekyll

echo.
echo Build complete! Files are in build\web directory
echo.
echo Next steps:
echo 1. Copy all files from build\web to your GitHub Pages repository
echo 2. Make sure .nojekyll file is included
echo 3. Commit and push to GitHub
echo.
pause
