# AGENTS.md

Use this file as the default project bootstrap. Do not read the whole repository unless the task requires it.

## Project Summary

- Flutter starter kit using clean architecture and feature-first folders
- Two implemented sample features: `auth` and `product`
- Auth uses DummyJSON login and persists the session in secure storage
- Product listing supports remote fetch, local Drift cache, search, sort, refresh, and pagination
- Dependency injection is centralized with `get_it`
- Routing is handled with `go_router`

## Read This First

For most tasks, start with only these files:

1. `README.md`
2. `pubspec.yaml`
3. `lib/main.dart`
4. `lib/app.dart`
5. `lib/core/di/injection.dart`
6. `lib/core/presentation/router/app_router.dart`
7. `lib/core/presentation/router/auth_guard.dart`

This is enough to understand app boot, DI, routing, and top-level architecture.

## Read By Task

### Auth work

Read:

- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/bloc/auth_bloc.dart`
- `lib/features/auth/data/datasources/auth_datasource.dart`
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/data/local/auth_session_store.dart`

### Product work

Read:

- `lib/features/product/presentation/screens/product_screen.dart`
- `lib/features/product/presentation/bloc/product_bloc.dart`
- `lib/features/product/data/datasources/product_datasource.dart`
- `lib/features/product/data/repositories/product_repository_impl.dart`
- `lib/features/product/data/local/datasources/product_local_datasource.dart`
- `lib/features/product/data/local/database/product_dao.dart`
- `lib/core/data/local/app_database.dart`

### Networking or API error handling

Read:

- `lib/core/data/remote/dio_client.dart`
- `lib/core/data/remote/safe_api_call.dart`
- `lib/core/domain/models/api_result.dart`
- `lib/core/domain/models/app_error.dart`

### Theme or app shell work

Read:

- `lib/core/presentation/theme/app_theme.dart`
- `lib/core/presentation/widgets/`

## Directory Map

- `lib/core`: shared infrastructure and app-wide concerns
- `lib/features/auth`: login flow and persisted session
- `lib/features/product`: list flow with cache and search/sort/paging
- `test/features`: unit tests grouped by feature
- `docs/screenshots`: README images

## Working Rules For Future Agents

- Prefer targeted reads with `rg --files` and specific file opens
- Do not scan generated files unless the task is generation-related
- Avoid reading `build/`, `.dart_tool/`, `.idea/`, or platform folders unless the task is platform-specific
- Read tests for the feature you are changing before editing behavior
- If changing models annotated with `freezed`, `json_serializable`, or Drift schema/DAO code, expect generated files to need regeneration

## Common Commands

```bash
flutter pub get
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
```

## Notes

- Default API base URL comes from `lib/core/config/app_env.dart`
- App startup restores auth state during DI setup
- Product cache is primarily for the default listing: empty query, `title`, ascending
