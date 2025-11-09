# Recallist

A Flutter application for managing items with spaced repetition and revision tracking. Recallist helps you organize information and track when you need to review it using customizable revision patterns.

## Features

- **Item Management**: Create and manage items with rich details
  - Title (required)
  - Notes
  - Tags (comma-separated)
  - Links (comma-separated)
  - Images (planned for future release)
- **Spaced Repetition**: Customizable revision patterns to optimize learning and retention

  - Set revision intervals (e.g., 1 day, 3 days, 7 days, 14 days)
  - Automatic calculation of next revision date
  - Track revision history

- **Dashboard**: View all your items at a glance

  - See last revised date
  - View next scheduled revision date
  - Pull-to-refresh to update items
  - Empty state guidance

- **Local Storage**: All data is stored locally using Hive database
  - Fast and efficient
  - No internet connection required
  - Data persists across app restarts

## Tech Stack

- **Flutter** (SDK ^3.9.2)
- **Hive** - Local NoSQL database for data persistence
- **GetIt** - Dependency injection
- **Path Provider** - File system access
- **Intl** - Date formatting and internationalization

## Prerequisites

Before you begin, ensure you have the following installed:

- Flutter SDK (3.9.2 or higher)
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

## Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd recallist
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Hive type adapters** (if needed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Project Structure

```
lib/
├── core/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── hive_data_source.dart      # Hive database operations
│   │   └── repositories/
│   │       ├── item_repository.dart       # Repository interface
│   │       └── local_item_repository.dart # Local repository implementation
│   ├── models/
│   │   ├── item.dart                      # Item model with Hive annotations
│   │   └── item.g.dart                    # Generated Hive adapter
│   └── service_locator.dart               # Dependency injection setup
├── features/
│   └── items/
│       ├── add_item/
│       │   ├── add_item_button.dart       # FAB for adding items
│       │   ├── add_item_sheet.dart        # Bottom sheet for item creation
│       │   └── widgets/                  # Reusable form widgets
│       └── dashboard/
│           └── item_card.dart             # Card widget for displaying items
└── main.dart                              # App entry point
```

## Running the App

1. **Check Flutter setup**

   ```bash
   flutter doctor
   ```

2. **Run on connected device/emulator**

   ```bash
   flutter run
   ```

3. **Run in debug mode with hot reload**

   ```bash
   flutter run --debug
   ```

4. **Run in release mode**
   ```bash
   flutter run --release
   ```

## Building for Different Platforms

### Android

```bash
flutter build apk          # APK file
flutter build appbundle    # App Bundle for Play Store
```

### iOS

```bash
flutter build ios          # iOS app (requires macOS and Xcode)
```

### Web

```bash
flutter build web
```

### Desktop

```bash
flutter build macos        # macOS (requires macOS)
flutter build windows     # Windows
flutter build linux       # Linux
```

## Usage

1. **Adding an Item**

   - Tap the floating action button (+) on the dashboard
   - Fill in the item details:
     - Title (required)
     - Notes (optional)
     - Tags (comma-separated, optional)
     - Links (comma-separated, optional)
     - Revision pattern (select from predefined patterns)
   - Tap "Save" to create the item

2. **Viewing Items**

   - All items are displayed on the dashboard
   - Each item card shows:
     - Title
     - Last revised date
     - Next scheduled revision date
   - Pull down to refresh the list

3. **Revision Tracking**
   - Items automatically calculate the next revision date based on:
     - The revision pattern you selected
     - The last revision date (or creation date if not yet revised)
   - The pattern repeats the last interval once all intervals are completed

## Development

### Code Generation

If you modify the `Item` model, regenerate the Hive adapter:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Architecture

The app follows a clean architecture pattern:

- **Models**: Data structures with Hive annotations
- **Data Sources**: Direct database operations (Hive)
- **Repositories**: Business logic layer (interface + implementation)
- **Features**: UI components organized by feature
- **Service Locator**: Dependency injection using GetIt

### Testing

Run tests with:

```bash
flutter test
```

## Future Enhancements

- Image support for items
- Item editing functionality
- Item deletion
- Search and filter items
- Export/import functionality
- Dark mode support
- Notifications for revision reminders
