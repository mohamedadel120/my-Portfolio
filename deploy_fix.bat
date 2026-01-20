@echo off
echo Deploying to GitHub Pages...
echo.

REM 1. Ensure we are in the project root
cd /d "%~dp0"

REM 2. Run the build script
echo Building the project...
call build_github_pages.bat

REM 3. Commit source changes to main
echo Committing source changes...
git add .
git commit -m "chore: implement CV download and contact form features"
git push origin main

REM 4. Deploy build/web to gh-pages branch
echo Deploying build/web to gh-pages...
git add -f build/web
git commit -m "chore: deploy latest build to gh-pages"
git subtree push --prefix build/web origin gh-pages

echo.
echo Deployment complete! Please wait a minute for GitHub Pages to update.
echo Check: https://mohamedadel120.github.io/my-Portfolio/
pause
