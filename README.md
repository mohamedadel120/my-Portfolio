# Mohamed Adel - Flutter Developer Portfolio

A modern, animated portfolio website showcasing mobile app development expertise, projects, and experience.

## Getting Started

### Development

Run the app in debug mode:
```bash
flutter run -d chrome
```

Run the app in release mode:
```bash
flutter run -d chrome --release
```

### Building for Web Deployment

**For root domain deployment (e.g., https://yourdomain.com):**
```bash
flutter build web --release
```

**For subdirectory deployment (e.g., https://yourdomain.com/portfolio/):**
```bash
flutter build web --release --base-href="/portfolio/"
```

### Deployment Steps

1. **Build the web app:**
   ```bash
   flutter build web --release
   ```

2. **Upload all files** from the `build/web` directory to your web server:
   - All files and folders including:
     - `index.html`
     - `main.dart.js`
     - `assets/` folder (contains all images)
     - `canvaskit/` folder
     - `icons/` folder
     - `manifest.json`
     - `flutter.js`
     - `flutter_service_worker.js`
     - All other files

3. **Server Configuration:**
   - Ensure your server serves `index.html` for all routes (SPA routing)
   - For Apache, add `.htaccess`:
     ```apache
     RewriteEngine On
     RewriteBase /
     RewriteRule ^index\.html$ - [L]
     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d
     RewriteRule . /index.html [L]
     ```
   - For Nginx, configure:
     ```nginx
     location / {
       try_files $uri $uri/ /index.html;
     }
     ```

4. **Troubleshooting White Screen:**
   - Check browser console (F12) for errors
   - Ensure all files are uploaded correctly
   - Clear browser cache and service workers
   - Verify `base href` matches your deployment path
   - Check that assets are accessible (try accessing `yourdomain.com/assets/` directly)
   - Ensure server supports CORS if loading from different domain

### Common Issues

**White Screen on Deployment:**
- Check browser console for JavaScript errors
- Verify all files are uploaded (especially `main.dart.js` and assets)
- Ensure server configuration allows SPA routing
- Clear browser cache and service workers
- Check that base href matches your deployment path

**Assets Not Loading:**
- Verify `assets/` folder is uploaded correctly
- Check file paths don't have spaces or special characters
- Ensure server MIME types are configured correctly
