# Flutter Base Template

**Flutter Base Template** is a Flutter project designed with a clean architecture that leverages BLoC for state management, Dio for networking, and Sqflite for local database management. The folder structure is organized into modules, repositories, services, and utilities, making the app scalable and maintainable.

## Table of Contents

- [Flutter Base Template](#flutter-base-template)
  - [Table of Contents](#table-of-contents)
  - [Project Structure](#project-structure)
    - [Key Modules and Utilities](#key-modules-and-utilities)
  - [Features](#features)
  - [Dependencies](#dependencies)
  - [Getting Started](#getting-started)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [License](#license)

## Project Structure

The project follows a modular architecture to ensure separation of concerns, maintainability, and scalability. Here's a quick breakdown of the folder structure:

```plaintext
lib/
├── main.dart                        # Entry point of the application
├── bloc/
│   ├── base_bloc.dart               # Base class for all BLoCs
├── models/                          # Contains all data models
├── modules/                         # Contains all feature-specific modules
│   └── home/
│       ├── bloc/
│       │   ├── home_bloc.dart       # BLoC class for home module
│       │   ├── home_event.dart      # Events for home BLoC
│       │   └── home_state.dart      # States for home BLoC
│       ├── controller/              # Controllers for home module
│       └── views/
│           └── home_page.dart       # Home page UI
├── repository/
│   ├── base_repo.dart               # Base repository class
│   ├── base_repo_implementation.dart# Implementation of the base repository
│   ├── local/                       # Local data sources
│   └── remote/                      # Remote data sources (APIs)
├── routes/
│   ├── app_router.dart              # App-wide route definitions
│   └── app_routes.dart              # Static route names
├── services/
│   ├── push_notification_service.dart# Service for push notifications
│   ├── db/
│   │   ├── database_helper.dart     # Database helper for managing SQLite
│   │   └── database_service.dart    # Database service
│   └── storage/
│       └── storage_service.dart     # Local storage management (e.g., Shared Preferences)
├── utils/
│   ├── bloc_dispatcher.dart         # Helper for dispatching events in BLoCs
│   ├── constants.dart               # App-wide constants
│   ├── shared_prefs.dart            # Shared preferences helper
│   ├── networking/                  # Networking utilities
│   │   ├── api_client.dart          # API client using Dio
│   │   ├── app_config.dart          # Configuration settings for different environments
│   │   └── url_provider.dart        # URL provider for APIs
│   ├── theme/
│   │   ├── light_theme.dart         # Light theme configuration
│   │   └── theme.dart               # App-wide theme management
│   └── widgets/
│       ├── background.dart          # Reusable background widget
│       ├── back_button.dart         # Custom back button
│       ├── custom_app_bar.dart      # Custom app bar widget
│       ├── debounced_button.dart    # Button with debounce functionality
│       ├── html_widget.dart         # Widget to render HTML content
│       └── loading_indicator.dart   # Loading indicator widget
```

### Key Modules and Utilities

- **BLoC Architecture**: Manages state effectively with separation of concerns.
- **Repository Pattern**: Handles local and remote data sources.
- **Push Notifications**: Firebase Cloud Messaging (FCM) integration using `firebase_messaging`.
- **Local Storage**: Management of local data using SQLite and SharedPreferences.
- **Theme Management**: Light theme configuration with a scalable approach to theme design.

## Features

- **State Management**: Utilizing `flutter_bloc` for predictable state management.
- **Networking**: API communication using Dio with error handling, token management, and URL providers.
- **Database**: SQLite integration for local storage.
- **Push Notifications**: Firebase Cloud Messaging for push notifications.
- **Responsive UI**: A set of reusable widgets for a consistent user experience across the app.
- **Modular Structure**: Each feature has its own module to ensure separation of concerns.

## Dependencies

This project leverages the following dependencies:

- `flutter_bloc`: State management using the BLoC pattern.
- `intl`: For internationalization and localization.
- `shared_preferences`: For storing key-value data locally.
- `equatable`: Simplifies equality checks between objects.
- `dio`: Powerful HTTP client for Dart, for making API requests.
- `go_router`: A declarative routing package.
- `logger`: For logging and debugging.
- `rxdart`: Reactive extensions for Dart for async operations.
- `sqflite`: SQLite plugin for Flutter to store data locally.
- `pinput`: A widget for handling input PINs.
- `firebase_messaging`: For handling push notifications.
- `firebase_core`: Firebase initialization.
- `webview_flutter`: To load web content within the app.
- `theme_provider`: For easy management of app themes.

## Getting Started

To start using **Klackr Mobile**:

1. Clone the repository:

   ```bash
   git clone https://github.com/techineur/flutter_base_template.git
   cd flutter_base_template
   ```

2. Install the dependencies:

   ```bash
   flutter pub get
   ```

3. Run the project:

   ```bash
   flutter run
   ```

4. Customize configurations in `app_config.dart` as needed for different environments (development, production).

## Usage

- The app's main entry point is `main.dart`.
- Navigation is managed using `go_router`. Define routes in `app_router.dart` and static route names in `app_routes.dart`.
- BLoCs are used for state management. Each module, such as `home`, contains its own BLoC for managing events and states.
- Customize the themes and colors in the `theme` directory.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a pull request

## TODO

- [ ] Implement comprehensive test suite
- [ ] Set up flavors for different environments (development, staging, production)
- [ ] Configure CI/CD pipeline for automatic apk building and publishing


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

 ```
This README gives a clear overview of the project, including its folder structure, dependencies, and key features. Feel free to customize any sections according to your project needs.
