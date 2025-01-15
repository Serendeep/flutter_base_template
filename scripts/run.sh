#!/bin/bash

# Default values
FLAVOR="development"
ENV_FILE=".env"

# Help message
show_help() {
    echo "Usage: ./run.sh [OPTIONS]"
    echo "Options:"
    echo "  -f, --flavor     Specify the flavor (development|staging|production)"
    echo "  -e, --env-file   Specify the environment file (default: .env)"
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

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables from $ENV_FILE"
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "Warning: Environment file $ENV_FILE not found"
fi

# Set environment-specific variables if not already set
case $FLAVOR in
    development)
        : ${DEV_API_BASE_URL:="https://dev-api.example.com"}
        : ${ENABLE_LOGGING:="true"}
        ;;
    staging)
        : ${STAGING_API_BASE_URL:="https://staging-api.example.com"}
        : ${ENABLE_LOGGING:="true"}
        ;;
    production)
        : ${PROD_API_BASE_URL:="https://api.example.com"}
        : ${ENABLE_LOGGING:="false"}
        ;;
esac

# Run the app
echo "Running app with flavor: $FLAVOR"
flutter run --flavor "$FLAVOR" -t "lib/main_${FLAVOR}.dart"
