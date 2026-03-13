# Contributing

Thanks for contributing to this project.

## Development Setup

```bash
flutter pub get
flutter analyze
flutter test
```

## Branch and PR Workflow

1. Fork the repository.
2. Create a feature branch from `main`.
3. Keep commits focused and descriptive.
4. Open a pull request with:
   - clear summary
   - linked issue (if available)
   - screenshots for UI changes

## Code Guidelines

- Follow existing architecture and folder conventions.
- Keep business logic in `domain`/`data`; keep widgets focused on UI.
- Prefer small, testable units.
- Avoid unrelated refactors in feature PRs.

## Required Checks

Before submitting:

```bash
flutter analyze
flutter test
```

If models/states changed, also run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Commit Message Style (Recommended)

- `feat: add logout action to app bar`
- `fix: handle provider scope in search callbacks`
- `docs: improve readme structure section`

## Reporting Issues

Please include:
- steps to reproduce
- expected vs actual behavior
- environment details (`flutter --version`, platform)
