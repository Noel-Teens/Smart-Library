# Smart Library Management System

A mobile-first, gamified library platform built with Flutter that transforms traditional library operations into an engaging, digital-first experience.

## 📖 Overview

Smart Library is a role-based mobile application serving four user personas:

- **Students** — discover, borrow, and return books while earning points on leaderboards
- **Librarians** — manage the issuance pipeline, approve requests, and handle fines
- **Administrators** — full system control including user management and audit logging
- **Staff** — read-only access for operational monitoring

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) — single codebase for Android & iOS |
| State Management | Riverpod 2.x |
| Navigation | GoRouter (declarative, deep-link-ready) |
| Backend (planned) | Supabase (PostgreSQL, Auth, Realtime, Edge Functions) |
| Notifications (planned) | Firebase Cloud Messaging |

## 📁 Architecture

The codebase follows a **feature-first** pattern with **clean architecture** boundaries within each feature:

```
lib/
├── core/            # Shared infrastructure (theme, config, errors, utils)
├── features/
│   ├── auth/
│   ├── books/
│   ├── transactions/
│   ├── fines/
│   ├── gamification/
│   ├── notifications/
│   ├── admin/
│   └── librarian/
├── routing/         # GoRouter config + role-based guards
├── app.dart         # Root MaterialApp widget
├── main.dart        # Entry point
├── main_dev.dart    # Dev flavour
└── main_prod.dart   # Production flavour
```

Each feature contains `data/`, `domain/`, and `presentation/` layers:

- **Domain** — entities, abstract repository interfaces, and use cases (no framework dependencies)
- **Data** — models, data sources, and repository implementations
- **Presentation** — Riverpod providers, screens, and widgets

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.18.0 (Dart SDK ≥ 3.10.4)
- Android Studio or VS Code with Flutter extension
- An Android device or emulator

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd library_management_app

# Install dependencies
flutter pub get

# Download Inter font (see below)

# Run the app
flutter run
```

### Fonts

This app uses the **Inter** font family bundled offline. To set up:

1. Download Inter from [Google Fonts](https://fonts.google.com/specimen/Inter)
2. Extract and copy these files to `assets/fonts/`:
   - `Inter-Light.ttf` (300)
   - `Inter-Regular.ttf` (400)
   - `Inter-Medium.ttf` (500)
   - `Inter-SemiBold.ttf` (600)
   - `Inter-Bold.ttf` (700)
3. Uncomment the `fonts:` section in `pubspec.yaml`

> The app works without Inter — it falls back to the platform default font.
