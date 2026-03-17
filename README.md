# Flutter Starter Kit

Production-oriented Flutter starter kit with clean feature boundaries, sample auth and product flows, offline-first product caching, and test coverage for core business logic.

## What This Project Includes

- Feature-first structure with `data`, `domain`, and `presentation` layers
- Login flow backed by DummyJSON `POST /auth/login`
- Persisted auth session using `flutter_secure_storage`
- Protected navigation using `go_router` and an auth guard
- Product listing backed by DummyJSON `GET /products` and `GET /products/search`
- Search, sorting, order toggle, pull-to-refresh, and pagination
- Local product cache using Drift for the default listing
- Dependency injection with `get_it`
- Immutable models and states with `freezed` and `json_serializable`
- Unit tests for repositories, mappers, and BLoCs

## Screens

- Login
- Product list
- Product list with search and sorting

| Login | Products |
|---|---|
| <img src="docs/screenshots/login.png" width="240" alt="Login" /> | <img src="docs/screenshots/products.png" width="240" alt="Products" /> |

| Search + Sort |
|---|
| <img src="docs/screenshots/products_search_sort.png" width="320" alt="Search and Sort" /> |

## Architecture

Each feature follows the same layered split:

- `data`: remote/local datasources, DTOs, repository implementations, mappers
- `domain`: entities/models, repository contracts, use cases
- `presentation`: screens, widgets, BLoCs, events, states

Shared app concerns live under `lib/core`:

- `config`: flavor and API base URL resolution
- `data/remote`: Dio client and safe API wrapper
- `data/local`: Drift database
- `di`: service registration
- `presentation/router`: route definitions and auth redirect logic
- `domain/models`: shared result and error types

## Project Structure

```text
lib/
  app.dart
  main.dart
  core/
    config/
    data/
      local/
      remote/
    di/
    domain/models/
    presentation/
      constants/
      router/
      theme/
      widgets/
  features/
    auth/
      data/
        datasources/
        local/
        mappers/
        remote/model/dtos/
        repositories/
      domain/
        models/
        repositories/
        usecases/
      presentation/
        bloc/
        constants/
        screens/
    product/
      data/
        datasources/
        local/
          database/
          datasources/
          mappers/
          model/
        mappers/
        remote/model/dtos/
        repositories/
      domain/
        models/
        repositories/
        usecases/
      presentation/
        bloc/
        constants/
        screens/
        widgets/
test/
  features/
    auth/
    product/
```

## Feature Notes

### Auth

- The app starts at `/login`
- Demo credentials are predeclared in the UI: `emilys / emilyspass`
- Successful login stores the session in secure storage
- `AuthGuard` restores the saved session on startup
- Logged-in users are redirected to `/product`

### Product

- Default listing loads cached data first when available
- A background refresh updates the cache from the API
- If refresh fails but cache exists, the UI keeps showing stale data with an error banner
- Search requests use `/products/search`
- Sorting supports `title`, `price`, and `rating`
- Load-more paging is handled in `ProductBloc`

## Environment Configuration

The app reads compile-time values from `dart-define`.

### Flavor

```bash
flutter run --dart-define=APP_FLAVOR=dev
flutter run --dart-define=APP_FLAVOR=staging
flutter run --dart-define=APP_FLAVOR=prod
```

Current defaults:

- `dev` -> `https://dummyjson.com`
- `staging` -> `https://dummyjson.com`
- `prod` -> `https://dummyjson.com`

### Override API base URL

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Tech Stack

- Flutter
- `flutter_bloc`
- `go_router`
- `dio`
- `get_it`
- `drift` and `drift_flutter`
- `flutter_secure_storage`
- `freezed`
- `json_serializable`
- `shimmer`

## Getting Started

### Requirements

- Flutter SDK
- Dart SDK `^3.11.0`

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

With an explicit flavor:

```bash
flutter run --dart-define=APP_FLAVOR=dev
```

## Code Generation

Run this after changing `freezed`, `json_serializable`, or Drift-backed models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Quality Checks

```bash
flutter analyze
flutter test
```

## Tests Included

- Auth repository tests
- Auth BLoC tests
- Product mapper tests
- Product repository tests
- Product BLoC tests

## Suggested Next Steps

- Add environment-specific endpoints instead of using DummyJSON for every flavor
- Expand feature modules from the provided auth and product examples
- Add integration tests for navigation and persisted session restoration
