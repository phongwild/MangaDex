#!/bin/bash

echo "🚀 Building optimized Flutter app..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code if needed
echo "🔧 Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

# Optimize images first
echo "🎨 Optimizing images..."
if [ -f "scripts/optimize_images.sh" ]; then
    bash scripts/optimize_images.sh
fi

# Build for Android
echo "🤖 Building optimized Android APK..."
flutter build apk --release \
    --obfuscate \
    --split-debug-info=build/debug_info \
    --dart-define=FLUTTER_APP_FLAVOR=production \
    --tree-shake-icons \
    --split-per-abi

# Build for Android App Bundle
echo "📦 Building Android App Bundle..."
flutter build appbundle --release \
    --obfuscate \
    --split-debug-info=build/debug_info \
    --dart-define=FLUTTER_APP_FLAVOR=production \
    --tree-shake-icons

# Build for iOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building optimized iOS app..."
    flutter build ios --release \
        --obfuscate \
        --split-debug-info=build/debug_info \
        --dart-define=FLUTTER_APP_FLAVOR=production \
        --tree-shake-icons
fi

# Display build results
echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📊 Build outputs:"
echo "  - Android APK: build/app/outputs/flutter-apk/"
echo "  - Android Bundle: build/app/outputs/bundle/release/"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  - iOS: build/ios/iphoneos/"
fi
echo "  - Debug symbols: build/debug_info/"
echo ""
echo "💡 Tips for deployment:"
echo "  - Upload the .aab file to Google Play Store"
echo "  - Use split APKs for direct distribution"
echo "  - Keep debug symbols for crash reporting"