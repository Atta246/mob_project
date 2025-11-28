
# mob_project

## Overview

mob_project is a cross-platform mobile application built with Flutter. It provides a modern, responsive user experience and supports Android, iOS, web, Windows, macOS, and Linux platforms.

## Features

- User authentication (login & signup)
- Home, trips, payment, and settings screens
- Custom bottom navigation
- Asset management (images)
- Platform-specific support (Android, iOS, Web, Desktop)

## Project Structure

- `lib/` - Main Dart codebase
  - `main.dart` - Entry point
  - `screens/` - UI screens (home, login, signup, payment, trips, settings)
  - `widgets/` - Reusable widgets (e.g., custom bottom navigation)
- `assets/` - Images and other static assets
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` - Platform-specific code
- `test/` - Unit and widget tests

## Getting Started

1. **Install Flutter:**
	- Follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install).
2. **Clone the repository:**
	```sh
	git clone https://github.com/Atta246/mob_project.git
	cd mob_project
	```
3. **Install dependencies:**
	```sh
	flutter pub get
	```
4. **Run the app:**
	```sh
	flutter run
	```

## Usage

Navigate through the app using the bottom navigation bar. Access different screens for trips, payments, and settings. Authentication is required for personalized features.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
