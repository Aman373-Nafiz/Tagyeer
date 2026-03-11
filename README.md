# Taghyeer Flutter App

A production-quality Flutter mobile application built for the **Taghyeer Technologies** Flutter Developer Technical Assignment. The app integrates the [DummyJSON](https://dummyjson.com) open API and demonstrates clean architecture, state management, pagination, caching, and theme switching.


## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>= 3.0.0`
- Dart SDK `>= 3.0.0`
- Android Studio / VS Code with Flutter & Dart plugins
- Android Emulator or Physical Device

### Installation
```bash
# Step 1: Clone the repository
git clone https://github.com/Aman373-Nafiz/taghyeer-flutter.git

# Step 2: Navigate into the project
cd taghyeer-flutter

# Step 3: Generate native folders (android / ios)
flutter create . --project-name taghyeer_app

# Step 4: Install all dependencies
flutter pub get

# Step 5: Run the app
flutter run
```

### Demo Login Credentials
```
Username: emilys
Password: emilyspass
```

---

## ✨ Features

### 🔐 User Authentication
- Login screen with username and password fields and form validation
- Calls `POST https://dummyjson.com/auth/login` with proper headers and body
- On successful login, user data is saved locally using **SharedPreferences**
- On app restart, the saved session is read automatically — no login required again
- On logout, the cached session is fully cleared and the user is returned to the login screen

### 🏠 Bottom Navigation (3 Tabs)
- Persistent bottom navigation bar with **Products**, **Posts**, and **Settings** tabs
- Uses `IndexedStack` so each tab preserves its scroll position and loaded data when switching tabs

### 🛍️ Products Tab
- Fetches product list from `https://dummyjson.com/products?limit=10&skip=0`
- Displays product **thumbnail**, **title**, and **price** in a clean card list
- **Scroll-based pagination** — automatically loads the next page when you reach the bottom
- Uses `skip=0`, `skip=10`, `skip=20`... to load pages sequentially
- Handles all states: Loading, Loaded, Empty, Error, Pagination Loading, Pagination Error
- Pull-to-refresh support
- **Bonus:** Tap any product to open a full **Product Detail Screen** with image gallery, description, rating, stock, category, and discount info

### 📝 Posts Tab
- Fetches posts from `https://dummyjson.com/posts?limit=10&skip=0`
- Displays post **title** and a short **body preview** with tags, likes, and views
- **Scroll-based pagination** using skip — same pattern as products
- Handles all states: Loading, Loaded, Empty, Error, Pagination Loading, Pagination Error
- Pull-to-refresh support
- **Bonus:** Tap any post to open a full **Post Detail Screen** with complete body, tags, likes, dislikes, and views

### ⚙️ Settings Tab
- Displays the **cached user profile**: avatar image, full name, username, and email
- **Light / Dark theme toggle** with an animated sun/moon icon
- The selected theme is **persisted across app restarts** using SharedPreferences
- **Logout button** with a confirmation dialog — clears the session and navigates back to login

### 🌙 Theme Management
- Full **Light Mode** and **Dark Mode** support
- Both themes are completely customized: AppBar, Cards, Bottom Navigation, Buttons, Input Fields
- Theme choice is saved to device storage and restored instantly on next app launch

### ⚠️ Error Handling
- **No internet connection** — detected before every API call using `connectivity_plus`
- **Slow / timed-out API** — 15-second timeout on all HTTP requests
- **Server errors** — HTTP 4xx/5xx handled with meaningful messages
- **Empty responses** — dedicated empty state with icon and message
- **Pagination errors** — existing list stays visible with an inline retry banner at the bottom
- All error screens have a **Try Again** button that re-fires the request

---

## 🏗️ Architecture

This project follows **Clean Architecture** with strict separation of concerns across 3 layers:
```
Presentation Layer     Domain Layer        Data Layer
─────────────────    ──────────────    ──────────────────
UI Screens           Entities          Models (JSON)
BLoC / Cubit         Use Cases         Remote DataSources
Widgets              Repository        Local DataSources
                     Contracts         Repository Impls
```

---

## 🗂️ Folder Structure
```
lib/
├── core/
│   ├── constants/        # API endpoints, storage keys
│   ├── errors/           # Failure classes + Exception classes
│   ├── network/          # Connectivity / NetworkInfo
│   └── theme/            # Light and Dark ThemeData
│
├── data/
│   ├── datasources/      # HTTP calls + SharedPreferences access
│   ├── models/           # JSON serialization (extends entities)
│   └── repositories/     # Concrete repository implementations
│
├── domain/
│   ├── entities/         # Pure Dart data classes
│   ├── repositories/     # Abstract repository contracts
│   └── usecases/         # Single-action business logic classes
│
├── presentation/
│   ├── blocs/            # AuthBloc, ProductsBloc, PostsBloc, ThemeCubit
│   ├── pages/            # All screens
│   └── widgets/          # Reusable ErrorWidget, EmptyWidget
│
├── app.dart              # Root MaterialApp + auth navigation logic
├── app_router.dart       # Named route definitions
├── injection_container.dart  # GetIt dependency registration
└── main.dart             # Entry point
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.3 | BLoC pattern state management |
| `bloc` | ^8.1.2 | Base BLoC and Cubit library |
| `equatable` | ^2.0.5 | Value equality for states and events |
| `http` | ^1.1.0 | HTTP API requests |
| `shared_preferences` | ^2.2.2 | Local storage for session and theme |
| `get_it` | ^7.6.4 | Service locator / dependency injection |
| `cached_network_image` | ^3.3.0 | Network image loading and caching |
| `connectivity_plus` | ^5.0.2 | Internet connectivity detection |

---

## 🔄 State Management

| BLoC / Cubit | States | Purpose |
|---|---|---|
| `AuthBloc` | Initial, Loading, Authenticated, Unauthenticated, Error | Login, auto-login, logout |
| `ProductsBloc` | Initial, Loading, Loaded, Empty, Error, PaginationError | Fetch and paginate products |
| `PostsBloc` | Initial, Loading, Loaded, Empty, Error, PaginationError | Fetch and paginate posts |
| `ThemeCubit` | ThemeMode.light / ThemeMode.dark | Toggle and persist theme |

---

## 💾 Local Caching

| Data | Key | Saved When | Cleared When |
|---|---|---|---|
| User session | `cached_user` | After successful login | On logout |
| Theme preference | `theme_mode` | Every theme toggle | Never |

---

## 🗺️ Navigation Structure
```
App Start
 └── AuthBloc checks cache
      ├── Session found  → HomePage (Bottom Nav)
      │    ├── Tab 0: ProductsPage
      │    │    └── Tap card → ProductDetailPage (push/pop)
      │    ├── Tab 1: PostsPage
      │    │    └── Tap card → PostDetailPage (push/pop)
      │    └── Tab 2: SettingsPage
      │         └── Logout → LoginPage (via AuthBloc state)
      └── No session → LoginPage
           └── Login success → HomePage (via AuthBloc state)
```

---

## 🌐 API Reference

| Action | Method | Endpoint |
|---|---|---|
| Login | POST | `https://dummyjson.com/auth/login` |
| Get Products | GET | `https://dummyjson.com/products?limit=10&skip=N` |
| Get Posts | GET | `https://dummyjson.com/posts?limit=10&skip=N` |

### Login Request Body
```json
{
  "username": "emilys",
  "password": "emilyspass",
  "expiresInMins": 30
}
```

---

## 🛠️ Build Commands
```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d android
flutter run -d ios

# Build release APK
flutter build apk --release

# Build release AAB (Play Store)
flutter build appbundle --release

# Clean project
flutter clean && flutter pub get
```

---

## 👨‍💻 Author
Aman Bin Azad
Built for **Taghyeer Technologies** Flutter Developer Technical Assignment.