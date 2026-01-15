# GitHub Pages Deployment Guide

## Why the "Failed to load application" Error?

When deploying a Flutter web app to GitHub Pages in a subdirectory (like `/my-Portfolio/`), you need to:

1. **Build with the correct base-href** - This tells Flutter where your app is hosted
2. **Include a `.nojekyll` file** - This prevents GitHub Pages from processing your files with Jekyll
3. **Upload all files correctly** - All files from `build/web` must be in the repository root or the correct branch

## Quick Fix Steps

### Option 1: Use the Build Script (Recommended)

**For Windows:**
```bash
build_github_pages.bat
```

**For Mac/Linux:**
```bash
chmod +x build_github_pages.sh
./build_github_pages.sh
```

This script will:
- Clean previous builds
- Get dependencies
- Build with correct base-href (`/my-Portfolio/`)
- Create `.nojekyll` file

### Option 2: Manual Build

1. **Clean and build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release --base-href="/my-Portfolio/"
   ```

2. **Create `.nojekyll` file:**
   - Create an empty file named `.nojekyll` in the `build/web` directory
   - This prevents GitHub Pages from using Jekyll (which can break Flutter apps)

3. **Copy files to GitHub:**
   - Copy ALL files from `build/web` to your GitHub repository
   - Make sure `.nojekyll` is included
   - Commit and push

## GitHub Pages Setup

### Method 1: GitHub Actions (Automatic - Recommended)

1. The `.github/workflows/deploy.yml` file is already created
2. Go to your GitHub repository → Settings → Pages
3. Under "Source", select "GitHub Actions"
4. Push your code to the `main` branch
5. GitHub Actions will automatically build and deploy

### Method 2: Manual Deployment

1. Build using the script or manual commands above
2. Go to your GitHub repository → Settings → Pages
3. Under "Source", select the branch where you'll upload files (usually `gh-pages` or `main`)
4. Upload all files from `build/web` to the selected branch
5. Make sure `.nojekyll` is in the root

## Important Files Checklist

After building, make sure these files are in your GitHub Pages repository:

- ✅ `index.html`
- ✅ `main.dart.js`
- ✅ `flutter.js`
- ✅ `flutter_service_worker.js`
- ✅ `flutter_bootstrap.js`
- ✅ `manifest.json`
- ✅ `assets/` folder (with all images)
- ✅ `canvaskit/` folder
- ✅ `icons/` folder
- ✅ `.nojekyll` file (IMPORTANT!)

## Troubleshooting

### Still seeing "Failed to load application"?

1. **Check browser console (F12)** - Look for specific error messages
2. **Verify base-href** - Open `index.html` and check that `<base href="/my-Portfolio/">` is correct
3. **Clear browser cache** - Hard refresh (Ctrl+Shift+R or Cmd+Shift+R)
4. **Check file paths** - Make sure all assets are accessible
5. **Verify `.nojekyll` exists** - This is critical for GitHub Pages

### Common Errors:

**"404 Not Found" for assets:**
- Base href is incorrect
- Files not uploaded correctly
- Missing `.nojekyll` file

**"CORS error":**
- Usually not an issue with GitHub Pages
- Check browser console for specific errors

**"White screen":**
- Check browser console for JavaScript errors
- Verify `main.dart.js` is loading
- Check that GSAP libraries are loading (if using animations)

## Verification

After deployment, check:

1. ✅ Site loads at `https://mohamedadel120.github.io/my-Portfolio/`
2. ✅ No console errors (F12 → Console)
3. ✅ Images load correctly
4. ✅ Animations work
5. ✅ All sections are visible

## Need Help?

If issues persist:
1. Check browser console for specific errors
2. Verify all files are uploaded (especially `main.dart.js`)
3. Ensure `.nojekyll` file exists
4. Try clearing browser cache and service workers
