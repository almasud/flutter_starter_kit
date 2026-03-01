# Flutter Starter Kit

Opinionated Flutter starter kit with a clean, scalable structure and one
working sample feature (`product`) that demonstrates the end-to-end flow.

## What This Project Includes

- Layered architecture: `data` / `domain` / `presentation`
- Feature-first folder structure (`features/product`)
- Dependency injection with `get_it`
- Declarative routing with `go_router`
- Networking with `dio`
- Typed API result and error model (`ApiResult`, `AppError`)
- DTO to domain mapping
- State management with `flutter_bloc`
- Model and state generation using `freezed` + `json_serializable`
- Unit and widget tests

## Architecture Overview

`lib/core`
- Shared app setup and cross-cutting concerns
- DI container (`core/di/injection.dart`)
- Router (`core/presentation/router/app_router.dart`)
- API client and safe call wrapper (`core/data/remote`)
- App theme and common widgets

`lib/features/product`
- `data`: remote DTOs, datasource, repository implementation, mappers
- `domain`: entities/models, repository contract, use case
- `presentation`: Bloc, events/states, screen UI

## Current Feature Scope

Implemented sample features:
- Auth/login screen using DummyJSON `POST /auth/login`
- Login state handling with `flutter_bloc`
- Route transition from login to product list on success
- Product list screen
- Fetch products from `https://dummyjson.com/products`
- Loading, success, and failure states
- Pull-to-refresh and retry UI

## Project Structure

```text
lib/
  app.dart
  main.dart
  core/
    data/
    di/
    domain/
    presentation/
  features/
    product/
      data/
      domain/
      presentation/
test/
  features/
    product/
```

## Requirements

- Flutter SDK (stable)
- Dart SDK `^3.11.0`

## Getting Started

```bash
flutter pub get
flutter run
```

## Run Tests

```bash
flutter test
```

## Code Generation

Run this after updating `freezed`/`json_serializable` models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Main Dependencies

- `go_router`
- `dio`
- `get_it`
- `flutter_bloc`
- `freezed_annotation`
- `json_annotation`

Dev dependencies:
- `build_runner`
- `freezed`
- `json_serializable`

## Notes

This repository is positioned as a starter kit, but it already includes a
fully wired sample feature to demonstrate architecture and development
conventions for future modules.
