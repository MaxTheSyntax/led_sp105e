# SP105E LED Controller - Usage Guide

## App Overview

The SP105E LED Controller app provides an intuitive interface for controlling your LED strips via Bluetooth. This guide will walk you through all the features.

## Getting Started

### 1. First Launch

When you first open the app, you'll see the **Home Screen** which displays:
- App title: "SP105E LED Controller"
- A list of available Bluetooth devices
- A scan/refresh button
- Status messages for Bluetooth availability

**Important:** Make sure Bluetooth is enabled on your phone and your SP105E controller is powered on.

### 2. Connecting to Your Device

1. The app automatically scans for devices when launched
2. Look for your SP105E controller in the device list (may show as "SP105E", "LED", or similar)
3. Tap on your device to connect
4. Wait for the connection to establish (a loading indicator will appear)
5. Once connected, you'll be taken to the **Control Screen**

## Control Screen Features

### Current Color Display

At the top of the control screen, you'll see:
- A large circular color preview showing the current LED color
- The color has a nice glow effect
- Below it shows the current brightness percentage

### Brightness Control

- Use the slider to adjust brightness from 0% to 100%
- Drag the slider to your desired brightness
- The color is automatically sent to the LEDs when you release the slider

### Pick Custom Color Button

Tap the **"Pick Custom Color"** button to:
1. Open a full-screen color picker
2. Choose any color using the color wheel
3. See a live preview of your selection
4. Tap **"Apply"** to send the color to your LEDs
5. Or tap **"Cancel"** to dismiss without changes

### Presets Section

The presets section shows all available color presets in a grid layout:

#### Built-in Presets (10 total):
- **Warm White** - Cozy, yellowish white
- **Cool White** - Bright, bluish white
- **Red** - Pure red
- **Green** - Pure green
- **Blue** - Pure blue
- **Yellow** - Bright yellow
- **Cyan** - Sky blue
- **Magenta** - Hot pink
- **Orange** - Sunset orange
- **Purple** - Deep purple

#### Using Presets:
- Tap any preset to instantly apply that color
- The color is sent immediately to your LEDs
- No need to adjust brightness - presets remember their own brightness

### Custom Presets

#### Creating a Custom Preset:

1. Choose your desired color using the color picker
2. Adjust the brightness to your liking
3. Tap the **"Save Current"** button in the presets section
4. Enter a name for your preset (e.g., "Sunset Glow", "Ocean Blue")
5. Tap **"Save"**
6. Your custom preset now appears in the preset grid with a ⭐ star icon

#### Managing Custom Presets:

- **Apply:** Tap on a custom preset to use it
- **Delete:** Tap the small **X** button in the corner of a custom preset
- **Delete (alternative):** Long-press on a custom preset for the delete option

Custom presets are automatically saved and will be available the next time you open the app!

## Additional Features

### Turn Off LEDs

- Tap the power button (⚡) in the top-right corner of the app bar
- This sends a "black" color with 0% brightness to turn off the LEDs

### Disconnect

- Tap the back button to disconnect and return to the device list
- If the device disconnects unexpectedly, you'll see a notification

### Reconnecting

- If you lose connection, simply go back to the home screen
- Tap the refresh button to scan again
- Connect to your device

## Tips and Troubleshooting

### Device Not Showing Up?

- Make sure your SP105E controller is powered on
- Check that Bluetooth is enabled on your phone
- Try tapping the refresh button
- Move closer to the controller
- Restart the controller by unplugging and replugging it

### Colors Not Working?

The SP105E protocol can vary between firmware versions. If the colors don't match what you select:

1. Try adjusting the brightness
2. Test the built-in presets first
3. The protocol implementation can be customized if needed

### Connection Issues?

- Make sure you're not too far from the controller (typical range: 10-30 feet)
- Only one device can connect at a time - make sure no other phone is connected
- Try closing other Bluetooth apps
- Restart your phone's Bluetooth

### App Permissions

The app needs the following permissions:

**Android:**
- Bluetooth - to scan and connect
- Location - required by Android for Bluetooth LE scanning (your location is never collected)

**iOS:**
- Bluetooth - to scan and connect

You'll be prompted to grant these permissions when you first launch the app.

## Best Practices

1. **Create presets for your favorite colors** - much faster than picking each time
2. **Name your presets descriptively** - makes them easier to find later
3. **Test brightness levels** - some colors look better at different brightness levels
4. **Stay within range** - for best performance, stay within 15 feet of the controller

## Keyboard Shortcuts

None - this is a touch-based mobile app!

## Support

If you encounter issues or have feature requests, please open an issue on the GitHub repository:
https://github.com/MaxTheSyntax/led_sp105e

Enjoy your customizable LED lighting! 💡✨
