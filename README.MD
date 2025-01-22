# Flutter Base Template

A production-ready Flutter application template with a robust architecture and essential features pre-configured.

## Features

- BLoC Pattern with Base Implementation
- Environment Flavors (Development, Staging, Production)
- Push Notifications with Firebase Cloud Messaging
- Theme Management
- Routing System
- Error Handling
- Logging
- Environment Configuration
- Visual Environment Indicators

## Project Structure

```
lib/
├── core/               # Core functionality and base classes
├── modules/           # Feature modules
├── routes/            # Navigation and routing
├── services/          # Services (Push notifications, Database, etc.)
├── utils/             # Utilities and helpers
│   ├── config/        # Configuration (Flavors, Environment)
│   ├── networking/    # Network related utilities
│   └── theme/         # Theme configuration
└── main.dart          # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code
- Firebase project (for push notifications)
- ImageMagick (for generating flavor-specific icons)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter_base_template.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
```bash
cp .env.example .env.development
cp .env.example .env.staging
cp .env.example .env.production
```

4. Generate flavor-specific icons:
```bash
./scripts/generate_icons.sh
```

### Running the App

The app supports three environments: development, staging, and production. Each environment has its own:
- App Icon
- App Name
- Environment Banner (except production)
- Configuration

## Scripts

### Generating App Icons

The project includes a script to generate app icons for different environments:

```bash
# Navigate to the scripts directory
cd scripts

# Make the script executable
chmod +x generate_icons.sh

# Run the icon generation script
./generate_icons.sh
```

#### Custom Logo
- Place your custom logo at `assets/logo.png`
- If no logo is present, the script will download the Flutter logo
- Icons will be generated with a flavor-specific banner

### Running the App

```bash
chmod +x scripts/run.sh
```

#### Development Environment
```bash
./scripts/run.sh development 
```

#### Staging Environment
```bash
./scripts/run.sh staging 
```

#### Production Environment
```bash
./scripts/run.sh production 
```

### Troubleshooting

- Ensure ImageMagick is installed: 
  ```bash
  # For Ubuntu/Debian
  sudo apt-get install imagemagick
  
  # For macOS
  brew install imagemagick
  ```
- Check Flutter and Dart SDK versions
- Verify script permissions with `chmod +x scripts/*.sh`

## Environment Configuration

### Environment Files
- `.env.development` - Development environment variables
- `.env.staging` - Staging environment variables
- `.env.production` - Production environment variables

### Visual Indicators
- Development: Green banner with "development"
- Staging: Orange banner with "staging"
- Production: No banner

### App Icons
Each environment has its own distinctive app icon:
- Development: Green icon with "Dev" label
- Staging: Orange icon with "Staging" label
- Production: Blue icon

## Architecture

### BLoC Pattern
- Base BLoC implementation with error handling
- Standardized event and state management
- Automatic error logging

### Services
- Push Notification Service with Firebase integration
- Database Service for local storage
- Theme Service for dynamic theme management

### Navigation
- Route management using GoRouter
- Deep linking support
- Screen transitions

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## TODO

- [ ] Implement comprehensive test suite
- [X] Set up flavors for different environments (development, staging, production)
- [ ] Configure CI/CD pipeline for automatic apk building and publishing
- [ ] Add more documentation and examples
- [ ] Implement analytics integration
- [ ] Add offline support
- [ ] Implement automated testing workflows

## Credits

This project uses themes and design inspiration from [Nylo](https://github.com/nylo-core/nylo), an open-source Flutter framework. Special thanks to the Nylo team for their excellent theming and design resources.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


This README gives a clear overview of the project, including its folder structure, dependencies, and key features. Feel free to customize any sections according to your project needs.