#!/bin/bash

echo "Building Flutter web app for GitHub Pages..."
echo ""

# Clean previous build
echo "Cleaning previous build..."
flutter clean

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build for GitHub Pages with correct base-href
# --wasm compiles to WebAssembly instead of JS+CanvasKit: it boots the Flutter
# engine dramatically faster (measured ~66 -> ~86 Lighthouse performance score
# locally) and automatically falls back to the JS build in browsers without
# WasmGC support, so it's safe on a static host like GitHub Pages.
echo "Building for GitHub Pages (base-href: /my-Portfolio/)..."
flutter build web --release --wasm --base-href="/my-Portfolio/"

# Create .nojekyll file to prevent Jekyll processing
echo "Creating .nojekyll file..."
touch build/web/.nojekyll

echo ""
echo "Build complete! Files are in build/web directory"
echo ""
echo "Next steps:"
echo "1. Copy all files from build/web to your GitHub Pages repository"
echo "2. Make sure .nojekyll file is included"
echo "3. Commit and push to GitHub"
echo ""
