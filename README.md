# FixIt - Handyman Service Booking App

## Flutter Version
Flutter 3.47.6 (stable)

## How to run the app
1. Clone the repository.
2. Run `flutter pub get` to install all dependencies.
3. Run `flutter run` to start the application on your emulator or device.

## How to run the tests
Run `flutter test` in the terminal to execute the unit tests for business rules (cost calculation, status transitions, double-booking, and form validation).

## Architecture Overview
* **Presentation Layer:** Contains UI screens, widgets, and state notifiers.
* **State Management:** Uses `provider` (`ChangeNotifier`) for consistent state across Customer and Provider modes.
* **Domain Layer:** Core business rules (validators, cost calculators, double-booking logic) are isolated here for easy testing independent of the UI.
* **Data Layer:** Includes models (with `fromJson`, `toJson`, `copyWith`) and a mock repository that simulates a real API with network delays and random failures.

## Assumptions & Tech Stack
* **State Management:** `provider`
* **Local Persistence:** `shared_preferences` (used to save bookings, theme preferences, and user mode).
* **Booking ID Format:** Generated as FX-YYYYMMDD-XXXX using the booking date.
* **Bonus Features Implemented:** Dark Mode toggle and Hero Animations.
