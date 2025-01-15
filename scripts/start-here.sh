#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
OLD_PROJECT_NAME="klackr_mobile"
NEW_PACKAGE_NAME=$(echo $NEW_PROJECT_NAME | sed 's/_//')
CURRENT_DIR=$(pwd)

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

# Update pubspec.yaml
replace_in_file $OLD_PROJECT_NAME $NEW_PROJECT_NAME "pubspec.yaml"
print_success "Updated pubspec.yaml"

# Update .iml file if it exists
if [ -f "$OLD_PROJECT_NAME.iml" ]; then
    mv "$OLD_PROJECT_NAME.iml" "$NEW_PROJECT_NAME.iml"
    replace_in_file $OLD_PROJECT_NAME $NEW_PROJECT_NAME "$NEW_PROJECT_NAME.iml"
    print_success "Updated .iml file"
fi

# Update package imports in Dart files
print_status "Updating Dart imports..."
find lib test -type f -name "*.dart" -exec sed -i "s/package:$OLD_PROJECT_NAME/package:$NEW_PROJECT_NAME/g" {} +
print_success "Updated Dart imports"

# Update Android files
print_status "Updating Android configuration..."
# Update namespace and applicationId
replace_in_file "namespace = \"$OLD_PACKAGE_NAME.$OLD_PROJECT_NAME\"" "namespace = \"$NEW_PACKAGE_NAME.$NEW_PROJECT_NAME\"" "android/app/build.gradle"
replace_in_file "applicationId = \"$OLD_PACKAGE_NAME.$OLD_PROJECT_NAME\"" "applicationId = \"$NEW_PACKAGE_NAME.$NEW_PROJECT_NAME\"" "android/app/build.gradle"

# Update Kotlin package name
if [ -d "android/app/src/main/kotlin" ]; then
    OLD_KOTLIN_PATH="android/app/src/main/kotlin/$OLD_PACKAGE_NAME/$OLD_PROJECT_NAME"
    NEW_KOTLIN_PATH="android/app/src/main/kotlin/$NEW_PACKAGE_NAME/$NEW_PROJECT_NAME"
    mkdir -p "$(dirname $NEW_KOTLIN_PATH)"
    if [ -d "$OLD_KOTLIN_PATH" ]; then
        mv "$OLD_KOTLIN_PATH"/* "$(dirname $NEW_KOTLIN_PATH)/"
        rm -rf "android/app/src/main/kotlin/$OLD_PACKAGE_NAME"
    fi
    # Update package name in Kotlin files
    find "android/app/src/main/kotlin" -name "*.kt" -exec sed -i "s/package $OLD_PACKAGE_NAME.$OLD_PROJECT_NAME/package $NEW_PACKAGE_NAME.$NEW_PROJECT_NAME/g" {} +
fi
print_success "Updated Android files"

# Update iOS files
print_status "Updating iOS configuration..."
# Update bundle identifier
find ios -type f -name "project.pbxproj" -exec sed -i "s/$OLD_PACKAGE_NAME\.$OLD_PROJECT_NAME/$NEW_PACKAGE_NAME.$NEW_PROJECT_NAME/g" {} +
# Update display name
find ios -type f -name "Info.plist" -exec sed -i "s/Klackr Mobile/$NEW_PROJECT_NAME/g" {} +
print_success "Updated iOS configuration"

# Update Linux files
print_status "Updating Linux configuration..."
replace_in_file "set(BINARY_NAME \"$OLD_PROJECT_NAME\")" "set(BINARY_NAME \"$NEW_PROJECT_NAME\")" "linux/CMakeLists.txt"
replace_in_file "set(APPLICATION_ID \"$OLD_PACKAGE_NAME.$OLD_PROJECT_NAME\")" "set(APPLICATION_ID \"$NEW_PACKAGE_NAME.$NEW_PROJECT_NAME\")" "linux/CMakeLists.txt"
replace_in_file "\"$OLD_PROJECT_NAME\"" "\"$NEW_PROJECT_NAME\"" "linux/my_application.cc"
print_success "Updated Linux configuration"

# Update Windows files
print_status "Updating Windows configuration..."
replace_in_file "project($OLD_PROJECT_NAME" "project($NEW_PROJECT_NAME" "windows/CMakeLists.txt"
replace_in_file "set(BINARY_NAME \"$OLD_PROJECT_NAME\")" "set(BINARY_NAME \"$NEW_PROJECT_NAME\")" "windows/CMakeLists.txt"
# Update Runner.rc
sed -i "s/\"$OLD_PACKAGE_NAME\"/\"$NEW_PACKAGE_NAME\"/g" "windows/runner/Runner.rc"
sed -i "s/\"$OLD_PROJECT_NAME\"/\"$NEW_PROJECT_NAME\"/g" "windows/runner/Runner.rc"
# Update main.cpp
replace_in_file "L\"$OLD_PROJECT_NAME\"" "L\"$NEW_PROJECT_NAME\"" "windows/runner/main.cpp"
print_success "Updated Windows configuration"

# Update web files
print_status "Updating web configuration..."
find web -type f -name "*.html" -exec sed -i "s/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME/g" {} +
find web -type f -name "manifest.json" -exec sed -i "s/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME/g" {} +
print_success "Updated web configuration"

# Function to generate app icons
generate_app_icons() {
    print_status "Generating app icons for all environments"
    
    # Check if ImageMagick is installed
    if ! command -v magick &> /dev/null; then
        print_error "ImageMagick is not installed. Please install it first."
        print_error "On Ubuntu/Debian: sudo apt-get install imagemagick"
        print_error "On macOS: brew install imagemagick"
        return 1
    fi
    
    # Make the generate_icons.sh script executable
    chmod +x generate_icons.sh
    
    # Run the icon generation script
    ./generate_icons.sh
    
    if [ $? -eq 0 ]; then
        print_success "App icons generated successfully for all environments"
    else
        print_error "Failed to generate app icons"
        return 1
    fi
}

# Clean up
print_status "Cleaning up project..."

# Remove build directories and generated files
rm -rf build/
rm -rf .dart_tool/
rm -rf .idea/
rm -f .flutter-plugins
rm -f .flutter-plugins-dependencies
print_success "Removed generated directories and files"

# Initialize fresh git repository
print_status "Initializing fresh git repository..."
# rm -rf .git
# git init
print_success "Initialized new git repository"

# Run flutter clean and pub get
print_status "Running flutter clean..."
flutter clean

print_status "Getting dependencies..."
flutter pub get

# Make run script executable
chmod +x run.sh

# Add icon generation to the main workflow
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
