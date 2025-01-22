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

## CI/CD and Environment Management

### GitHub Actions Workflows

The project includes two GitHub Actions workflows:

1. **Continuous Integration (`flutter-ci.yml`):**
   - Manually triggered workflow
   - Validates code quality
   - Runs tests
   - Checks environment configuration

2. **Continuous Deployment (`flutter-cd.yml`):**
   - Manually triggered workflow
   - Builds APK and App Bundle
   - Supports multiple flavors (development, staging, production)
   - Validates environment configuration

### Environment Setup Script

`scripts/setup-env.sh` provides robust environment configuration:
- Validates environment file
- Checks required environment variables
- Supports different build flavors
- Provides informative environment setup logging

### Running Workflows

You can manually trigger workflows from the GitHub Actions tab:
- Select the desired flavor
- Optionally specify a custom environment file
- Run CI checks or build deployable artifacts

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



## Git Hooks

This project uses custom Git hooks to enforce code quality and commit message conventions.

### Prerequisites

Ensure you have the following tools installed:
- Flutter
- Dart
- Git

### Setup Git Hooks

There are two methods to set up git hooks:

#### Method 1: Using the Provided Script

1. Make the hook script executable:
   ```bash
   chmod +x scripts/git_hooks.sh
   ```

2. Set up symlinks using the script:
   ```bash
   # From the project root directory
   ./scripts/git_hooks.sh setup-symlinks .
   ```

3. Optional: Test the git hooks
   ```bash
   ./scripts/git_hooks.sh test .
   ```

#### Method 2: Manual Symlink Creation

1. Create symlinks manually:
   ```bash
   # From the project root directory
   ln -sf ../../scripts/pre-commit .git/hooks/pre-commit
   ln -sf ../../scripts/commit-msg .git/hooks/commit-msg
   ```

### Pre-Commit Checks

The pre-commit hook performs comprehensive checks to maintain code quality:

- Prevents committing files larger than 5MB
- Blocks committing binary files
- Runs `flutter analyze` to check code quality
- Executes `flutter test` to ensure all tests pass


If any of these checks fail, the commit will be rejected with a detailed error message.

### Commit Message Guidelines

#### Commit Message Format

Commits must follow the Conventional Commits format with optional emoji:

```
[emoji] <type>(<optional scope>): <description>
```

#### Valid Commit Message Types

| Gitmoji | Type | Description |
|---------|------|-------------|
| `:art:` | Code Style | Improve structure / format of the code |
| `:zap:` | Performance | Improve performance |
| `:fire:` | Cleanup | Remove code or files |
| `:bug:` | Bugfix | Fix a bug |
| `:ambulance:` | Hotfix | Critical hotfix |
| `:sparkles:` | Feature | Introduce new features |
| `:memo:` | Documentation | Add or update documentation |
| `:rocket:` | Deployment | Deploy stuff |
| `:lipstick:` | UI | Add or update the UI and style files |
| `:tada:` | Initial | Begin a project |
| `:white_check_mark:` | Testing | Add, update, or pass tests |
| `:lock:` | Security | Fix security or privacy issues |
| `:closed_lock_with_key:` | Secrets | Add or update secrets |
| `:bookmark:` | Release | Release / Version tags |
| `:rotating_light:` | Linting | Fix compiler / linter warnings |
| `:construction:` | WIP | Work in progress |
| `:green_heart:` | CI | Fix CI Build |
| `:arrow_down:` | Downgrade | Downgrade dependencies |
| `:arrow_up:` | Upgrade | Upgrade dependencies |
| `:pushpin:` | Pin | Pin dependencies to specific versions |
| `:construction_worker:` | Build | Add or update CI build system |
| `:chart_with_upwards_trend:` | Analytics | Add or update analytics or track code |
| `:recycle:` | Refactor | Refactor code |
| `:heavy_plus_sign:` | Dependency | Add a dependency |
| `:heavy_minus_sign:` | Dependency | Remove a dependency |
| `:wrench:` | Config | Add or update configuration files |
| `:hammer:` | Scripts | Add or update development scripts |
| `:globe_with_meridians:` | I18n | Internationalization and localization |
| `:pencil2:` | Typo | Fix typos |
| `:rewind:` | Revert | Revert changes |
| `:truck:` | Move | Move or rename resources |
| `:page_facing_up:` | License | Add or update license |
| `:boom:` | Breaking | Introduce breaking changes |
| `:wheelchair:` | Accessibility | Improve accessibility |
| `:bulb:` | Comments | Add or update comments in source code |
| `:loud_sound:` | Logging | Add or update logs |
| `:mute:` | Logging | Remove logs |
| `:children_crossing:` | UX | Improve user experience / usability |
| `:building_construction:` | Architecture | Make architectural changes |
| `:iphone:` | Responsive | Work on responsive design |
| `:see_no_evil:` | Gitignore | Add or update a .gitignore file |
| `:alembic:` | Experiment | Perform experiments |
| `:mag:` | SEO | Improve SEO |
| `:label:` | Types | Add or update types |
| `:goal_net:` | Error | Catch errors |
| `:dizzy:` | Animation | Add or update animations and transitions |
| `:passport_control:` | Auth | Work on authorization, roles and permissions |
| `:adhesive_bandage:` | Patch | Simple fix for a non-critical issue |
| `:coffin:` | Dead Code | Remove dead code |
| `:test_tube:` | Test | Add a failing test |
| `:necktie:` | Business | Add or update business logic |
| `:technologist:` | DX | Improve developer experience |
| `:safety_vest:` | Validation | Add or update code related to validation |

#### Examples of Valid Commit Messages

##### With Gitmoji (Conventional)
```bash
# Feature with Gitmoji
:sparkles: feat: add user authentication

# Fix with scope and Gitmoji
:bug: fix(login): resolve password reset issue

# Documentation update with Gitmoji
:memo: docs: update README with setup instructions
```

##### With Gitmoji
```bash
# Simple gitmoji commit
:sparkles: add user authentication feature

# Commit with scope
:bug:(login): resolve authentication error

# Commit with detailed description
:memo:(readme): update project documentation with new guidelines
```

##### Without Emoji
```bash
# Feature without emoji
feat: implement dark mode

# Fix with scope
fix(auth): resolve login validation bug

# Documentation update
docs: clarify installation steps
```

#### Invalid Commit Message Examples

```bash
# ❌ Missing type
just a random commit message

# ❌ Invalid type
unknown: add some changes

# ❌ Missing description
feat:

# ❌ Incorrect format
FEAT add new feature
```

#### Commit Message Validation

The Git hooks will:
- Validate commit message format
- Check for valid commit types
- Optionally validate emoji (if used)
- Ensure meaningful commit descriptions

#### Best Practices

1. Use present tense: "add feature" not "added feature"
2. Be concise but descriptive
3. Reference issue numbers if applicable
4. Use emojis to add visual context (optional)

#### Emoji Usage

- Emojis are completely optional
- Can be placed at the start of the commit message
- Provide visual context to commit type
- Must be followed by a space before the type

### Troubleshooting

- If a commit is rejected, carefully read the error message
- Ensure your code passes all checks before committing
- For formatting issues, run `dart format .` to automatically fix most formatting problems

## TODO

- [ ] Implement comprehensive test suite
- [X] Set up flavors for different environments (development, staging, production)
- [X] Implement Commit Hooks
- [X] Configure CI/CD pipeline for automatic apk building and publishing
- [ ] Add more documentation and examples
- [ ] Implement analytics integration
- [ ] Add offline support
- [ ] Implement automated testing workflows

## Credits

This project uses themes and design inspiration from [Nylo](https://github.com/nylo-core/nylo), an open-source Flutter framework. Special thanks to the Nylo team for their excellent theming and design resources.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.