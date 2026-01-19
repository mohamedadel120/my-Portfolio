# Image Loading Fix for GitHub Pages

## Problem
Images were not loading in production on GitHub Pages (`https://mohamedadel120.github.io/my-Portfolio/`)

## Root Cause
1. **Missing images in build**: Project images (gomla, stock, paletta, adruse, albatal) were not being included in the build output
2. **Path mismatch**: AssetManifest.json uses `assets/images/` prefix, but code was using `images/` prefix

## Solution Applied

### 1. Updated `pubspec.yaml`
Added explicit asset directories to ensure all images are included:
```yaml
assets:
  - assets/images/
  - assets/images/gomla/
  - assets/images/stock/
  - assets/images/paletta/
  - assets/images/adruse/
  - assets/images/albatal/
```

### 2. Updated Image Paths in `app_data.dart`
Changed all image paths from:
- `images/gomla/logo.webp` ❌
- To: `assets/images/gomla/logo.webp` ✅

This matches what's in the `AssetManifest.json` file.

### 3. Build Command
Use this command to build for GitHub Pages:
```bash
flutter build web --release --base-href="/my-Portfolio/" --no-tree-shake-icons
```

## Verification

After building, verify:
1. ✅ All images are in `build/web/assets/assets/images/`
2. ✅ `AssetManifest.json` includes all project images
3. ✅ `.nojekyll` file exists in `build/web/`
4. ✅ `index.html` has correct base-href: `<base href="/my-Portfolio/">`

## Deployment Steps

1. **Build the app:**
   ```bash
   flutter build web --release --base-href="/my-Portfolio/" --no-tree-shake-icons
   ```

2. **Verify build output:**
   - Check `build/web/assets/assets/images/` contains all project folders
   - Verify `.nojekyll` file exists in `build/web/`

3. **Upload to GitHub:**
   - Upload ALL files from `build/web` to your GitHub repository
   - Make sure `.nojekyll` is included (it's a hidden file)
   - Ensure `assets/` folder is uploaded completely

4. **Test:**
   - Visit `https://mohamedadel120.github.io/my-Portfolio/`
   - Open browser console (F12) to check for any errors
   - Verify images load correctly

## Important Notes

- **Base href must match**: `/my-Portfolio/` (with trailing slash)
- **`.nojekyll` is critical**: Prevents GitHub Pages from processing files with Jekyll
- **Case sensitivity**: GitHub Pages is case-sensitive, ensure file names match exactly
- **Asset paths**: Must use `assets/images/` prefix to match AssetManifest.json

## Troubleshooting

If images still don't load:

1. **Check browser console (F12)**:
   - Look for 404 errors on image files
   - Check the exact path being requested

2. **Verify file structure on GitHub**:
   - Images should be at: `assets/assets/images/gomla/logo.webp`
   - This is correct! Flutter web creates `assets/assets/` structure

3. **Clear browser cache**:
   - Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
   - Clear service workers

4. **Check AssetManifest.json**:
   - Should contain entries like: `"assets/images/gomla/logo.webp"`
   - Verify paths match what's in your code
