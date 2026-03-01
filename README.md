# Flutter Starter Kit

Interview-ready Flutter starter template with clean architecture and a fully
wired sample module.

## What Is Included

- Layered architecture (`data` / `domain` / `presentation`)
- Feature-first folder structure
- Dependency injection with `get_it`
- Routing with `go_router` + auth route guard
- API client with `dio`, safe API wrapper, and request-id tracing
- State management with `flutter_bloc`
- Immutable models/states with `freezed` + `json_serializable`
- Secure auth session persistence with `flutter_secure_storage`
- Product sample flow with search, sort, pull-to-refresh, and pagination
- Unit, widget, and BLoC tests

## Current Sample Features

- Login flow (`POST /auth/login`)
- Persisted auth session and guarded navigation
- Product list fetch (`GET /products`)
- Search products (`GET /products/search?q=...`)
- Sort and load more pagination pattern
- Error handling with typed `AppError`

## Environment Configuration

Use `dart-define` to control environment without code changes:

```bash
flutter run --dart-define=APP_FLAVOR=dev
flutter run --dart-define=APP_FLAVOR=staging
flutter run --dart-define=APP_FLAVOR=prod
```

Optional base URL override:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Requirements

- Flutter SDK (stable)
- Dart SDK `^3.11.0`

## Getting Started

```bash
flutter pub get
flutter run
```

## Run Quality Checks

```bash
flutter analyze
flutter test
```

## Code Generation

Run this after changing any `freezed`/`json_serializable` models or states:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Project Structure

```text
lib/
  app.dart
  main.dart
  core/
    config/
    data/
    di/
    domain/
    presentation/
  features/
    auth/
    product/
test/
  features/
```
