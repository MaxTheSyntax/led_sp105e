# Project Structure

This document explains the organization of the SP105E LED Controller app.

## Directory Structure

```
led_sp105e/
├── lib/                      # Main application code
│   ├── main.dart            # App entry point
│   ├── models/              # Data models
│   │   └── led_preset.dart  # Preset data structure
│   ├── services/            # Business logic services
│   │   ├── sp105e_service.dart    # Bluetooth communication
│   │   └── preset_service.dart    # Preset storage
│   ├── screens/             # UI screens
│   │   ├── home_screen.dart       # Device scanning screen
│   │   └── control_screen.dart    # LED control interface
│   └── widgets/             # Reusable UI components
│       └── preset_grid.dart       # Preset display grid
├── android/                 # Android platform code
├── ios/                     # iOS platform code
├── test/                    # Unit and widget tests
├── pubspec.yaml            # Dependencies and app config
└── README.md               # Project documentation
```

## Key Files Explained

### `lib/main.dart`
- Entry point of the application
- Sets up the app theme and navigation
- Initializes the HomeScreen

### `lib/models/led_preset.dart`
- Defines the `LedPreset` data model
- Contains preset properties: id, name, color, brightness
- Includes default presets (Warm White, Cool White, RGB colors, etc.)
- Provides JSON serialization for storage

### `lib/services/sp105e_service.dart`
- Handles all Bluetooth communication
- Scans for SP105E devices
- Manages device connection/disconnection
- Sends color commands to the LED controller
- Implements the SP105E protocol

### `lib/services/preset_service.dart`
- Manages custom preset storage
- Uses SharedPreferences for persistence
- Provides CRUD operations for presets
- Combines default and custom presets

### `lib/screens/home_screen.dart`
- Device discovery screen
- Lists available Bluetooth devices
- Handles device selection and connection
- Shows Bluetooth status

### `lib/screens/control_screen.dart`
- Main control interface
- Color picker integration
- Brightness control slider
- Preset management (view, create, delete)
- Connection status monitoring

### `lib/widgets/preset_grid.dart`
- Displays presets in a grid layout
- Handles preset selection
- Shows custom preset indicators
- Provides delete functionality for custom presets

## Architecture Pattern

The app follows a simple **service-based architecture**:

1. **Models**: Define data structures
2. **Services**: Handle business logic and external communication (Bluetooth, storage)
3. **Screens**: Main UI pages
4. **Widgets**: Reusable UI components

### Data Flow

```
User Interaction (Screen)
    ↓
Service Layer (Bluetooth/Storage)
    ↓
External System (SP105E Controller/Device Storage)
    ↓
State Update (setState)
    ↓
UI Update (Screen)
```

## Dependencies

Key packages used in this project:

- **flutter_blue_plus** (^1.32.12): Bluetooth Low Energy communication
- **flutter_colorpicker** (^1.1.0): Interactive color selection UI
- **shared_preferences** (^2.3.2): Local data persistence
- **permission_handler** (^11.3.1): Runtime permissions management

## Platform-Specific Code

### Android (`android/`)
- **AndroidManifest.xml**: Bluetooth permissions and features
- **build.gradle.kts**: Minimum SDK version (21) for BLE support

### iOS (`ios/`)
- **Info.plist**: Bluetooth usage descriptions for App Store compliance

## Testing

- **test/widget_test.dart**: Basic widget tests
- Tests verify the home screen loads correctly

## Configuration Files

- **pubspec.yaml**: App metadata, dependencies, assets
- **analysis_options.yaml**: Dart linter rules
- **.gitignore**: Files to exclude from version control

## Building and Running

### Development
```bash
flutter run
```

### Testing
```bash
flutter test
```

### Build for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Customization Points

If you need to customize the app:

1. **Add new presets**: Edit `lib/models/led_preset.dart` → `defaultPresets`
2. **Change theme**: Edit `lib/main.dart` → `ThemeData`
3. **Modify protocol**: Edit `lib/services/sp105e_service.dart` → `sendColor()`
4. **Add features**: Create new screens in `lib/screens/`
5. **Adjust UI**: Modify existing screens or create new widgets

## Code Style

- Uses Dart 3.8.1+
- Follows Flutter/Dart style guidelines
- Uses `flutter_lints` for code quality
- Prefers `const` constructors where possible
- Uses meaningful variable and function names

## State Management

Currently using **StatefulWidget** with **setState** for simplicity:
- Suitable for this app's complexity level
- Easy to understand and maintain
- Could be upgraded to Provider/Riverpod if app grows

## Future Enhancements

Potential areas for extension:
- Add animation effects (fade, strobe, rainbow)
- Schedule colors for different times of day
- Create color patterns/sequences
- Support multiple controllers simultaneously
- Add color transition animations
- Export/import preset collections
