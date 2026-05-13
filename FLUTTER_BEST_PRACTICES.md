# Flutter Best Practices — Claude Code Guide

A portable reference covering every major Flutter topic. Use this in any Flutter project.

---

## Architecture: MVVM

Split every feature into a **UI layer** (View + ViewModel) and a **Data layer** (Repository + Service).

- **Service** — wraps one external data source (HTTP, Supabase, SQLite). Returns raw data only. Holds no state.
- **Repository** — single source of truth. Transforms raw data into domain models. Owns caching, error handling, and retry logic.
- **ViewModel** — extends `ChangeNotifier`. Exposes UI-ready state and Commands. Never imports Flutter widgets.
- **View** — reads ViewModel state via `ListenableBuilder`. Calls Commands on user actions. Contains zero business logic.

Views and ViewModels have a **one-to-one** relationship per feature. Repositories and Services have a **many-to-many** relationship.

### Strict rules
- ViewModels never create their own dependencies — receive them via constructor.
- Views never call Repositories, Services, `http`, or Supabase directly.
- Only Repositories mutate domain models — never the UI layer.
- The only logic allowed in a View: simple `if` statements, animation logic, layout logic (screen size), and simple routing.

### Command pattern
Wrap every async ViewModel action in a `Command` object that tracks its own `running` and `error` state. Views listen to the Command directly via `ListenableBuilder` — no manual `isLoading` flags, no `setState`.

### Data handling
- Use **immutable domain models** with `copyWith()`. Only Repositories call `copyWith` to produce new instances.
- Use a **sealed `Result<T>`** with `Success` and `Failure` variants in Services instead of throwing — forces callers to handle both outcomes.
- Use **optimistic state** for instant-feeling actions (like/save): update UI immediately, revert on network failure.
- Use **cache-first** for offline support: serve cached data immediately, then refresh silently in the background when online.

### Abstract repositories
Always define an abstract class for each Repository. The ViewModel depends on the abstract class, not the concrete implementation — allows swapping real vs fake for tests and different environments.

### Package structure
- Organise the data layer by **type** — repositories and services are reused across features.
- Organise the UI layer by **feature** — each feature has exactly one View and one ViewModel.
- Place shared widgets in `ui/core/` — never in a folder called `/widgets` (clashes with Flutter SDK naming).
- Domain models (plain Dart classes) live in `domain/models/` — used by both layers.
- Wire all DI in `main.dart` once at startup.

---

## Dependency Injection

Use the `provider` package as a DI container. Wire layers in `main.dart` in order: Service → Repository → ViewModel. No class creates its own dependencies internally — every dependency is injected via constructor. This makes every class independently testable.

---

## Naming Conventions

- View: `HomeScreen`, `LoginScreen`
- ViewModel: `HomeViewModel`, `TripViewModel`
- Repository: `UserRepository`, `TripRepository`
- Service: `ApiService`, `LocationService`
- Use-case: `GetFilteredFeedUseCase`
- Files: `snake_case` matching the class name
- Private helpers: underscore prefix

---

## Adaptive & Responsive

- Use `MediaQuery.of(context)` for screen size, orientation, text scale, and platform brightness.
- Use `LayoutBuilder` to build based on parent constraints — not raw screen size.
- Always wrap Scaffold body with `SafeArea` to avoid notch and status bar overlap.
- Use `Expanded` to fill all remaining flex space; use `Flexible` to fill proportionally.
- Never hardcode pixel sizes — derive layout from `MediaQuery` or `LayoutBuilder` breakpoints.
- Breakpoints: mobile < 600dp, tablet 600–1200dp, desktop > 1200dp.

---

## Design & Theming

- Define all colours in `ThemeData` — never scatter raw `Colors.blue` in widgets.
- Always read colours via `Theme.of(context).colorScheme` and text styles via `.textTheme`.
- AppBar background: always use `Theme.of(context).colorScheme.inversePrimary`.
- Use `NestedTheme` to override theme for a widget subtree without affecting the whole app.
- Use Material 3 `colorScheme` tokens — not legacy colour constants.

---

## Navigation

- Use `Navigator.push/pop` for simple linear flows.
- Use `go_router` for apps with deep linking, web URLs, or nested navigation (recommended for 90% of apps).
- Always route from the View — never from the ViewModel.
- Pass data forward via constructor; pass data back via `Navigator.pop(result)`.

---

## State Management

- Single widget local state: `StatefulWidget` + `setState`.
- State shared across widgets: `ChangeNotifier` + `Provider`.
- Complex, async, or global state: `Riverpod` or `flutter_bloc`.
- Use `setState` only for purely local UI state (toggle visibility, animation flags).

---

## Networking

- Always wrap `http` calls in a Service class — never call `http.get` from a widget or ViewModel.
- Return `Result<T>` from Services — never throw to the caller.
- Set a timeout on every request (10 seconds is a safe default).
- Parse large JSON payloads in a `compute()` isolate to avoid janking the UI.
- Inject `http.Client` into Services so they can be tested with a mock client.

---

## JSON Serialization

- Use manual `dart:convert` for small, simple models.
- Use `json_serializable` for nested models or anything with many fields — run `dart run build_runner build` after changes.
- Create separate **API models** (matching the raw JSON shape) and **domain models** (matching the app's needs). Transform in the Repository, not the ViewModel.

---

## Persistence

- Simple key-value data (settings, tokens): `shared_preferences`.
- File storage: `path_provider` + `dart:io`.
- Local relational data: `sqflite`.
- Cloud auth + database: `supabase_flutter`.
- Always enable **Row Level Security (RLS)** on every Supabase table.
- Never store credentials or anon keys in source control — use environment variables or a `.env` file (gitignored).

---

## Animations

- Use **implicit animations** (`AnimatedContainer`, `AnimatedOpacity`) for state-driven changes — no controller needed.
- Use **explicit animations** (`AnimationController` + `Tween`) for loops, sequences, or gesture-driven animations.
- Use **Hero** for shared-element transitions between routes — use the same `tag` on both widgets.
- Always set a `curve` (e.g. `Curves.easeInOut`) on implicit animations.
- Dispose `AnimationController` in `dispose()`.

---

## Accessibility

- Wrap every custom interactive widget with `Semantics` (provide a label and role).
- Use `Focus` and `FocusTraversalGroup` for keyboard and switch access.
- Never convey meaning with colour alone — pair it with a label, icon, or pattern.
- Test with TalkBack (Android) and VoiceOver (iOS) before shipping.

---

## Android Splash Screen

The default Flutter project already wires `LaunchTheme` and `NormalTheme` in `AndroidManifest.xml` — no manifest changes needed.

- `res/values/colors.xml` — define the splash background colour.
- `res/drawable/launch_background.xml` — set the background colour layer and optionally centre an icon.
- `res/values/styles.xml` — `LaunchTheme` and `NormalTheme` are already present; customise background colours.
- `res/values-v31/styles.xml` — Android 12+ SplashScreen API: use `windowSplashScreenBackground` and `windowSplashScreenAnimatedIcon`.
- `MainActivity.kt` — add `splashScreen.setOnExitAnimationListener { it.remove() }` to prevent the fade flicker on Android 12+.
- The `NormalTheme` background should match your app's primary scaffold background to avoid a colour flash during orientation changes.

---

## General Rules

- Use `const` constructors wherever possible to skip unnecessary rebuilds.
- Always check `mounted` before calling `setState` after an `await`.
- Dispose `TextEditingController`, `AnimationController`, `ChangeNotifier`, and `StreamSubscription` in `dispose()`.
- Prefer `final` everywhere — mutability should be explicit and deliberate.
- A widget with more than 5 lines of non-layout logic needs a ViewModel.
- Domain layer use-cases are optional — only add them when ViewModel logic becomes too complex or is repeated across multiple ViewModels.
