# FixIt - Handyman Service Booking App

A comprehensive Flutter application for booking handyman services, supporting both customer and provider modes.

## Flutter Version
Tested and built with **Flutter 3.47.6**.

## How to Run the App
To run the app locally, execute the following commands in your terminal:
```bash
flutter pub get
flutter run
```

## How to Run the Tests
To run the domain business rules and unit tests, execute:
```bash
flutter test
```

## Architecture Overview
This project follows a clean, layered architecture to separate concerns:
- **Presentation Layer**: Contains all UI elements and Widgets.
- **State Layer**: Manages the application state.
- **Domain Layer**: Contains core business logic, validators, and rules (e.g., cost calculation, double booking checks).
- **Data Layer**: Contains Data Models and a Mock Repository for data operations.

## Assumptions & Tech Stack
- **State Management**: Used the `provider` package for clean and scalable state management.
- **Local Storage**: Used `shared_preferences` for persisting data locally (such as saving bookings and toggling user mode).
