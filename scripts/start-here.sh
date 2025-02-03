#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the script directory (resolves absolute path)
SCRIPT_DIR=$(dirname "$(realpath "$0")")
BASE_DIR=$(realpath "$SCRIPT_DIR/..")

# Function to print colored output
print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if a project name was provided
if [ $# -eq 0 ]; then
    print_error "Please provide a project name!"
    echo "Usage: ./start-here.sh your_project_name"
    exit 1
fi

NEW_PROJECT_NAME=$1
OLD_PROJECT_NAME="flutter_base_template"
NEW_PACKAGE_NAME=$(echo $NEW_PROJECT_NAME | sed 's/_//')

print_status "Starting project generation for: $NEW_PROJECT_NAME"

# Validate project name (should be lowercase with underscores)
if [[ ! $NEW_PROJECT_NAME =~ ^[a-z][a-z0-9_]*$ ]]; then
    print_error "Project name should be lowercase and can only contain letters, numbers, and underscores"
    print_error "It must start with a letter"
    exit 1
fi

# Function to replace text in files while preserving file permissions
replace_in_file() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/$1/$2/g" "$3"
    else
        # Linux and others
        sed -i "s/$1/$2/g" "$3"
    fi
}

# Replace project name in key files
print_status "Updating project files..."

replace_in_file $OLD_PROJECT_NAME $NEW_PROJECT_NAME "$BASE_DIR/pubspec.yaml"
print_success "Updated pubspec.yaml"

# Update .iml file if it exists
if [ -f "$BASE_DIR/$OLD_PROJECT_NAME.iml" ]; then
    mv "$BASE_DIR/$OLD_PROJECT_NAME.iml" "$BASE_DIR/$NEW_PROJECT_NAME.iml"
    replace_in_file $OLD_PROJECT_NAME $NEW_PROJECT_NAME "$BASE_DIR/$NEW_PROJECT_NAME.iml"
    print_success "Updated .iml file"
fi

# Update Dart imports
print_status "Updating Dart imports..."
find "$BASE_DIR/lib" "$BASE_DIR/test" -type f -name "*.dart" -exec sed -i "s/package:$OLD_PROJECT_NAME/package:$NEW_PROJECT_NAME/g" {} +
print_success "Updated Dart imports"

# Update Android files
print_status "Updating Android configuration..."
replace_in_file "namespace = \"$OLD_PACKAGE_NAME.$OLD_PROJECT_NAME\"" "namespace = \"$NEW_PACKAGE_NAME.$NEW_PROJECT_NAME\"" "$BASE_DIR/android/app/build.gradle"
replace_in_file "applicationId = \"$OLD_PACKAGE_NAME.$OLD_PROJECT_NAME\"" "applicationId = \"$NEW_PACKAGE_NAME.$NEW_PROJECT_NAME\"" "$BASE_DIR/android/app/build.gradle"
print_success "Updated Android configuration"

# Update macOS files
print_status "Updating macOS configuration..."
rm -rf "$BASE_DIR/macos"
flutter create "$BASE_DIR" --platforms=macos
print_success "Updated macOS configuration"

# Update iOS files
print_status "Updating iOS configuration..."
rm -rf "$BASE_DIR/ios"
flutter create "$BASE_DIR" --platforms=ios
print_success "Updated iOS configuration"

# Update other platforms (Linux, Windows, Web)
for platform in linux windows web; do
    print_status "Updating $platform configuration..."
    rm -rf "$BASE_DIR/$platform"
    flutter create "$BASE_DIR" --platforms=$platform
    print_success "Updated $platform configuration"
done

# Function to generate app icons
generate_app_icons() {
    print_status "Generating app icons for all environments"
    
    # Check if ImageMagick is installed
    if ! command -v magick &> /dev/null; then
        print_error "ImageMagick is not installed. Please install it first."
        return 1
    fi
    
    # Ensure generate_icons.sh exists
    if [ -f "$SCRIPT_DIR/generate_icons.sh" ]; then
        chmod +x "$SCRIPT_DIR/generate_icons.sh"
        "$SCRIPT_DIR/generate_icons.sh"
        if [ $? -eq 0 ]; then
            print_success "App icons generated successfully"
        else
            print_error "Failed to generate app icons"
        fi
    else
        print_error "generate_icons.sh not found in $SCRIPT_DIR"
    fi
}

# Clean up
print_status "Cleaning up project..."
rm -rf "$BASE_DIR/build/"
rm -rf "$BASE_DIR/.dart_tool/"
rm -rf "$BASE_DIR/.idea/"
rm -f "$BASE_DIR/.flutter-plugins"
rm -f "$BASE_DIR/.flutter-plugins-dependencies"
rm -f "$BASE_DIR/README.md"
print_success "Removed unnecessary files"

# Initialize fresh git repository
print_status "Initializing fresh git repository..."
rm -rf "$BASE_DIR/.git"
git -C "$BASE_DIR" init
print_success "Initialized new git repository"

# Run flutter clean and pub get
print_status "Running flutter clean..."
flutter clean

print_status "Getting dependencies..."
flutter pub get

# Ensure run.sh is executable
if [ -f "$SCRIPT_DIR/run.sh" ]; then
    chmod +x "$SCRIPT_DIR/run.sh"
else
    print_error "run.sh not found in $SCRIPT_DIR"
fi

# Run icon generation
generate_app_icons

print_success "Project generation complete!"
echo ""
echo "Next steps:"
echo "1. cd into your project directory"
echo "2. Review the README.md file for setup instructions"
echo "3. Run the app with different flavors using:"
echo "   ./run.sh development    # For development build"
echo "   ./run.sh staging       # For staging build"
echo "   ./run.sh production    # For production build"
