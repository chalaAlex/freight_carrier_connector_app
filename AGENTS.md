# Repository Guidelines

## Project Structure & Module Organization
This is a Flutter app organized around feature-first clean architecture. Source code lives in `lib/`, with shared infrastructure under `lib/core/` and app-level config in `lib/cofig/`. Feature modules are grouped under `lib/feature/` and usually split into `data/`, `domain/`, and `presentation/`. Assets live in `assets/images/`, tests in `test/`, and platform code in `android/`, `ios/`, and `web/`.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `flutter run -t lib/main_dev.dart` starts the dev build.
- `flutter run -t lib/main_prod.dart` starts the production entrypoint.
- `flutter test` runs unit and widget tests in `test/`.
- `flutter analyze` checks lint and analyzer issues.
- `dart run build_runner build --delete-conflicting-outputs` regenerates `*.g.dart` files after model changes.

## Coding Style & Naming Conventions
Follow Dart defaults with 2-space indentation and the rules from `flutter_lints`. Use `PascalCase` for classes, `snake_case.dart` for filenames, and name BLoC artifacts consistently (`*_bloc.dart`, `*_event.dart`, `*_state.dart`). Keep feature code inside its module boundary and avoid editing generated files such as `*.g.dart` directly.

## Testing Guidelines
Use `flutter_test` for widget and unit tests. Mirror feature names in test paths where practical, such as `test/feature/chat/chat_test.dart`. Prefer descriptive test names that read like behavior statements. Run `flutter test` before submitting changes, and add focused tests when changing business logic, parsing, or navigation flows.

## Commit & Pull Request Guidelines
Recent commits use short, direct, lowercase messages, often starting with a verb like `adding`, `fixing`, or `integrating`. Keep commits focused on one change. For pull requests, include a brief summary, validation steps, linked issue if available, and screenshots or screen recordings for UI changes.

## Configuration & Security Notes
Environment-specific values are configured through `lib/cofig/env/` and `config.env`. Do not commit secrets, tokens, or local credentials. Authentication tokens are stored in secure storage via `TokenLocalDataSource`; preserve that pattern when touching auth code.
