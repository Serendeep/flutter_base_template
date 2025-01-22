#!/bin/bash

# Default values
FLAVOR="development"
ENV_FILE=".env.development"

# Help message
show_help() {
    echo "Usage: ./setup-env.sh [OPTIONS]"
    echo "Options:"
    echo "  -f, --flavor     Specify the flavor (development|staging|production)"
    echo "  -e, --env-file   Specify the environment file (default: .env.development)"
    echo "  -h, --help       Show this help message"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--flavor)
            FLAVOR="$2"
            shift 2
            ;;
        -e|--env-file)
            ENV_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate flavor
if [[ ! "$FLAVOR" =~ ^(development|staging|production)$ ]]; then
    echo "Invalid flavor: $FLAVOR"
    echo "Must be one of: development, staging, production"
    exit 1
fi

# Ensure .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Environment file $ENV_FILE not found"
    exit 1
fi

# Load and validate environment variables
echo "Loading environment variables from $ENV_FILE"
set -a
source "$ENV_FILE"
set +a

# Validate required environment variables
REQUIRED_VARS=(
    "API_BASE_URL"
    "APP_NAME"
    "ENVIRONMENT"
)

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Required environment variable $var is not set"
        exit 1
    fi
done

# Print environment summary (without sensitive data)
echo "Environment Setup Complete:"
echo "Flavor: $FLAVOR"
echo "Environment: $ENVIRONMENT"
echo "App Name: $APP_NAME"
echo "API Base URL: ${API_BASE_URL%????}****"  # Mask last 4 characters of URL

exit 0
