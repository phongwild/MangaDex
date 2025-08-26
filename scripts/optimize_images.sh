#!/bin/bash

# Script to optimize images for Flutter app
# Requires: imagemagick (install with: sudo apt-get install imagemagick)

echo "🎨 Starting image optimization..."

# Create optimized directory if it doesn't exist
mkdir -p assets/images/optimized

# Function to optimize PNG files
optimize_png() {
    local input=$1
    local output=$2
    
    # Compress PNG with pngquant (lossy) or optipng (lossless)
    if command -v pngquant &> /dev/null; then
        pngquant --quality=65-80 --strip --output "$output" "$input" 2>/dev/null || cp "$input" "$output"
    else
        convert "$input" -strip -quality 85 "$output"
    fi
}

# Function to optimize JPEG files
optimize_jpeg() {
    local input=$1
    local output=$2
    
    # Compress JPEG
    convert "$input" -strip -interlace Plane -gaussian-blur 0.05 -quality 85 "$output"
}

# Function to create multiple densities
create_densities() {
    local input=$1
    local basename=$(basename "$input")
    local name="${basename%.*}"
    local ext="${basename##*.}"
    
    # Create 1.5x, 2x, 3x, 4x versions
    convert "$input" -resize 75% "assets/images/optimized/1.5x/$name@1.5x.$ext"
    cp "$input" "assets/images/optimized/2.0x/$name@2x.$ext"
    convert "$input" -resize 150% "assets/images/optimized/3.0x/$name@3x.$ext"
    convert "$input" -resize 200% "assets/images/optimized/4.0x/$name@4x.$ext"
}

# Create density directories
mkdir -p assets/images/optimized/{1.5x,2.0x,3.0x,4.0x}

# Process all images
for img in assets/images/*.{png,jpg,jpeg}; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        echo "Processing: $filename"
        
        # Optimize based on file type
        if [[ $img == *.png ]]; then
            optimize_png "$img" "assets/images/optimized/$filename"
        else
            optimize_jpeg "$img" "assets/images/optimized/$filename"
        fi
        
        # Create multiple densities
        create_densities "assets/images/optimized/$filename"
    fi
done

# Calculate size reduction
original_size=$(du -sh assets/images | cut -f1)
optimized_size=$(du -sh assets/images/optimized | cut -f1)

echo "✅ Image optimization complete!"
echo "Original size: $original_size"
echo "Optimized size: $optimized_size"
echo ""
echo "📱 Generated densities: 1.5x, 2x, 3x, 4x"
echo "💡 Remember to update your pubspec.yaml to use optimized images"