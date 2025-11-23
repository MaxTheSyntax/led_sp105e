# SP105E LED Controller

A Flutter mobile app for controlling LEDs using the SP105E Bluetooth Magic Dream Color LED Controller. This app provides a better alternative to the default controller app with an intuitive interface and powerful features.

## Features

✨ **Color Picker** - Interactive color wheel to select any color you want for your LEDs

🎨 **Built-in Presets** - 10 pre-configured color presets including:
- Warm White
- Cool White
- Red, Green, Blue
- Yellow, Cyan, Magenta
- Orange, Purple

⭐ **Custom Presets** - Create and save your own color presets with custom names

💾 **Persistent Storage** - Your custom presets are saved and available across app restarts

🎚️ **Brightness Control** - Adjust LED brightness from 0-100%

📱 **Easy Connection** - Automatic Bluetooth scanning and simple device connection

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Android device with Bluetooth (Android 5.0+) or iOS device (iOS 12.0+)
- SP105E LED controller

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/MaxTheSyntax/led_sp105e.git
   cd led_sp105e
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Usage

1. **Launch the app** - The app will automatically start scanning for Bluetooth devices
2. **Connect to your SP105E** - Tap on your LED controller from the list of available devices
3. **Control your LEDs** - Once connected, you can:
   - Pick a custom color using the color picker
   - Select from built-in presets
   - Adjust brightness with the slider
   - Save your current color as a custom preset
   - Tap on any preset to apply it instantly
   - Long press on custom presets to delete them

## Permissions

The app requires the following permissions:

- **Bluetooth** - To scan and connect to the SP105E controller
- **Location** (Android only) - Required by Android for Bluetooth scanning

## Compatibility

- **Android**: 5.0 (API 21) and above
- **iOS**: 12.0 and above
- **SP105E Controller**: All versions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

Built with Flutter and love for better LED control! 💡
