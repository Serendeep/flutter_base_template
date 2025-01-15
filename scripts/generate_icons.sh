#!/bin/bash

# Function to generate icons for a specific flavor
generate_icons_for_flavor() {
    local flavor=$1
    local color=$2
    
    # Create temporary icon with flavor-specific color
    convert -size 1024x1024 xc:$color \
        -gravity center \
        -pointsize 100 \
        -fill white \
        -annotate 0 "${flavor^}" \
        "assets/icons/$flavor/icon.png"
    
    # Generate Android icons
    for size in 48 72 96 144 192; do
        convert "assets/icons/$flavor/icon.png" \
            -resize ${size}x${size} \
            "android/app/src/$flavor/res/mipmap-xxhdpi/ic_launcher.png"
    done
    
    # Generate iOS icons
    for size in 20 29 40 60 76 83.5; do
        convert "assets/icons/$flavor/icon.png" \
            -resize ${size}x${size} \
            "ios/Runner/Assets.xcassets/AppIcon-$flavor.appiconset/Icon-${size}.png"
    done
}

# Generate icons for each flavor
generate_icons_for_flavor "development" "#4CAF50"  # Green
generate_icons_for_flavor "staging" "#FF9800"      # Orange
generate_icons_for_flavor "production" "#2196F3"   # Blue

echo "Icons generated successfully!"
