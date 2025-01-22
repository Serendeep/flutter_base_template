#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to set up git hooks symlinks
setup_git_hooks_symlinks() {
    local project_root="$1"
    local hooks_dir="$project_root/.git/hooks"
    local scripts_dir="$project_root/scripts"

    # Check if .git directory exists
    if [ ! -d "$project_root/.git" ]; then
        echo -e "${RED}Error: Not a git repository. Please initialize git first.${NC}"
        return 1
    fi

    # Ensure hook scripts are executable
    chmod +x "$scripts_dir/pre-commit" "$scripts_dir/commit-msg"

    # Create symlinks in .git/hooks
    ln -sf "$scripts_dir/pre-commit" "$hooks_dir/pre-commit"
    ln -sf "$scripts_dir/commit-msg" "$hooks_dir/commit-msg"

    echo -e "${GREEN}Git hooks symlinks have been created successfully!${NC}"
}

# Function to test git hooks
test_git_hooks() {
    local project_root="$1"
    local temp_dir=$(mktemp -d)

    # Add safe directory to handle ownership issues
    git config --global --add safe.directory "$project_root"

    # Copy the entire project to the temporary directory
    cp -r "$project_root" "$temp_dir/project"
    cd "$temp_dir/project"

    # Initialize git repository if not already initialized
    if [ ! -d ".git" ]; then
        git init
        git add .
        git config user.email "test@example.com"
        git config user.name "Test User"
        git commit -m "Initial commit"
    fi

    # Test pre-commit hook
    echo -e "${YELLOW}Testing pre-commit hook...${NC}"
    # Simulate a commit that should pass pre-commit checks
    touch test_file.txt
    git add test_file.txt
    
    # Attempt to commit (this should pass)
    git commit -m "test: add test file for pre-commit hook"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Pre-commit hook test failed!${NC}"
        cd "$project_root"
        rm -rf "$temp_dir"
        return 1
    fi

    # Test commit-msg hook
    echo -e "${YELLOW}Testing commit-msg hook...${NC}"
    # Test valid commit message
    git commit --allow-empty -m "feat: test commit message validation"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Commit message hook test failed for valid message!${NC}"
        cd "$project_root"
        rm -rf "$temp_dir"
        return 1
    fi

    # Test invalid commit message (should fail)
    echo -e "${YELLOW}Testing invalid commit message (should fail)...${NC}"
    ! git commit --allow-empty -m "invalid commit message"
    if [ $? -eq 0 ]; then
        echo -e "${RED}Commit message hook did not catch invalid message!${NC}"
        cd "$project_root"
        rm -rf "$temp_dir"
        return 1
    fi

    # Clean up
    cd "$project_root"
    rm -rf "$temp_dir"

    echo -e "${GREEN}Git hooks test completed successfully!${NC}"
}

# Determine which action to run
case "$1" in
    "setup-symlinks")
        setup_git_hooks_symlinks "$2"
        ;;
    "test")
        test_git_hooks "$2"
        ;;
    *)
        echo -e "${RED}Invalid command.${NC}"
        echo -e "Usage: $0 {setup-symlinks|test} <project_root>"
        exit 1
        ;;
esac

exit 0
