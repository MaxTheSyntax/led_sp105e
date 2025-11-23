# Troubleshooting Guide

This guide helps you resolve common issues with the SP105E LED Controller app.

## Connection Issues

### Device Not Found During Scan

**Symptoms:**
- Your SP105E controller doesn't appear in the device list
- The list is empty after scanning

**Solutions:**

1. **Check Power**
   - Ensure the SP105E controller is plugged in and powered on
   - Verify the LED strip is connected to the controller
   - Look for indicator lights on the controller

2. **Enable Bluetooth**
   - Open your phone's Settings
   - Turn Bluetooth ON
   - On Android, also enable Location services (required for BLE scanning)

3. **Permissions**
   - Grant the app Bluetooth permissions when prompted
   - On Android: Settings → Apps → SP105E LED Controller → Permissions
   - On iOS: Settings → SP105E LED Controller → Bluetooth

4. **Range**
   - Move within 10-15 feet of the controller
   - Remove obstacles between your phone and controller
   - Metal walls and furniture can block signals

5. **Reset the Controller**
   - Unplug the controller from power
   - Wait 10 seconds
   - Plug it back in
   - Try scanning again

6. **Restart the App**
   - Close the app completely
   - Clear it from recent apps
   - Reopen and try again

### Connection Fails or Drops

**Symptoms:**
- Tapping a device shows "Failed to connect"
- Connection succeeds but immediately disconnects
- "Device disconnected" notification appears

**Solutions:**

1. **Close Other Apps**
   - Make sure no other Bluetooth apps are running
   - Ensure the official SP105E app is closed
   - Only one device can connect at a time

2. **Unpair/Forget Device**
   - Go to phone Settings → Bluetooth
   - Find the SP105E device
   - Tap "Forget" or "Unpair"
   - Try connecting through the app again

3. **Restart Bluetooth**
   - Turn Bluetooth OFF
   - Wait 5 seconds
   - Turn Bluetooth ON
   - Try connecting again

4. **Restart Your Phone**
   - Sometimes the Bluetooth stack needs a full restart
   - Power off your phone
   - Turn it back on
   - Try again

5. **Check for Interference**
   - Move away from WiFi routers
   - Turn off other Bluetooth devices nearby
   - Microwave ovens can also interfere

## Color Issues

### Colors Don't Match Selection

**Symptoms:**
- You pick blue but LEDs show red
- Colors are inverted or wrong
- White appears as a different color

**Cause:**
The SP105E protocol can vary between firmware versions. Different models may use different byte sequences.

**Solutions:**

1. **Try Different Brightness Levels**
   - Some controllers respond differently at various brightness levels
   - Test at 50%, 75%, and 100%

2. **Test Built-in Presets**
   - Try the default presets (Red, Green, Blue, etc.)
   - If presets work but custom colors don't, the protocol may need adjustment

3. **Protocol Adjustment** (Advanced)
   - The protocol implementation is in `lib/services/sp105e_service.dart`
   - Common variations:
     - Some use header byte `0x56` instead of `0x38`
     - RGB order might be BGR or GRB
     - Checksum calculation varies
   - Consider using a BLE sniffer app to capture the official app's protocol
   - Modify the `sendColor` method accordingly

4. **Report the Issue**
   - If you identify your specific controller's protocol
   - Please share on GitHub to help others
   - Include your controller model and working byte sequence

### LEDs Don't Respond to Commands

**Symptoms:**
- Connection works but colors don't change
- LEDs stay on previous color
- No response to any button

**Solutions:**

1. **Verify Connection**
   - Make sure you see the device name in the app bar
   - Try disconnecting and reconnecting
   - Check the controller is actually connected (not just discovered)

2. **Test the Controller**
   - Use the official SP105E app to verify the controller works
   - If the official app works, the issue is in our protocol implementation
   - If the official app doesn't work, the controller may be faulty

3. **Check Characteristic Permissions**
   - The controller's BLE characteristic must allow writes
   - This is usually automatic but can fail on some devices

4. **Power Cycle**
   - Disconnect from the app
   - Unplug the controller
   - Wait 30 seconds
   - Plug back in and reconnect

## Preset Issues

### Can't Save Custom Presets

**Symptoms:**
- "Save Current" button doesn't work
- Presets disappear after closing app
- Error message when saving

**Solutions:**

1. **Storage Permissions**
   - Some Android versions require storage permissions
   - Settings → Apps → SP105E LED Controller → Permissions
   - Grant Storage permission if requested

2. **Check Available Storage**
   - Ensure your phone has some free storage space
   - Even a few MB is sufficient for presets

3. **Clear App Data** (Last Resort)
   - This will delete all custom presets
   - Settings → Apps → SP105E LED Controller → Storage
   - Tap "Clear Data"
   - Reopen app and try again

### Presets Show Wrong Colors

**Symptoms:**
- Saved preset shows different color when applied
- Custom preset doesn't match what you saved

**Cause:**
This is related to the protocol issue. The color is stored correctly but sent incorrectly.

**Solution:**
- See "Colors Don't Match Selection" above

## App Performance Issues

### App is Slow or Laggy

**Solutions:**

1. **Close Background Apps**
   - Free up system resources
   - Close unnecessary apps

2. **Restart the App**
   - Completely close and reopen

3. **Update Flutter** (For Developers)
   - Keep dependencies up to date
   - Run `flutter pub upgrade`

### Color Changes Are Delayed

**Cause:**
Network congestion or slow Bluetooth communication.

**Solutions:**

1. **Move Closer**
   - Reduce distance to controller
   - Aim for under 10 feet

2. **Reduce Brightness Slider Speed**
   - Drag the slider more slowly
   - The app sends updates when you release

3. **Use Presets**
   - Presets are faster than the color picker
   - Single tap instead of multiple updates

## Permission Issues

### Android: Location Permission Denied

**Symptom:**
App says it needs location permission for Bluetooth scanning.

**Why:**
Android requires location permission for BLE scanning (even though we don't use location).

**Solution:**
1. Settings → Apps → SP105E LED Controller → Permissions
2. Grant "Location" permission
3. Choose "Allow only while using the app"
4. Your location is never accessed or stored

### iOS: Bluetooth Permission Denied

**Solution:**
1. Settings → Privacy → Bluetooth
2. Enable for SP105E LED Controller
3. Restart the app

## Build/Installation Issues

### Flutter Build Fails

**Solutions:**

1. **Clean Build**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Flutter Version**
   ```bash
   flutter --version
   ```
   Ensure you have Flutter 3.8.1 or higher

3. **Update Dependencies**
   ```bash
   flutter pub upgrade
   ```

### Android Build Errors

**Common Issues:**

1. **minSdkVersion Error**
   - Check `android/app/build.gradle.kts`
   - Should be `minSdk = 21`

2. **Bluetooth Permission Error**
   - Verify `AndroidManifest.xml` has all Bluetooth permissions
   - See the file for the complete list

### iOS Build Errors

**Common Issues:**

1. **Info.plist Missing Keys**
   - Must have `NSBluetoothAlwaysUsageDescription`
   - Must have `NSBluetoothPeripheralUsageDescription`

2. **Deployment Target**
   - iOS 12.0 or higher required

## Getting More Help

If you've tried everything and still have issues:

1. **Check GitHub Issues**
   - https://github.com/MaxTheSyntax/led_sp105e/issues
   - Search for similar problems

2. **Open a New Issue**
   - Describe your problem in detail
   - Include:
     - Phone model and OS version
     - SP105E controller model
     - Steps to reproduce
     - Screenshots if applicable

3. **Provide Logs**
   - Run the app with `flutter run`
   - Copy any error messages
   - Include in your issue report

4. **Test Checklist**
   Before reporting, confirm you've tried:
   - [ ] Controller is powered on
   - [ ] Bluetooth is enabled
   - [ ] Permissions granted
   - [ ] Official app works
   - [ ] Restarted app
   - [ ] Restarted phone
   - [ ] Moved closer to controller

## FAQ

**Q: Can I connect to multiple controllers?**
A: Not currently. The app connects to one controller at a time.

**Q: Can I use the app without internet?**
A: Yes! The app only uses Bluetooth and local storage. No internet required.

**Q: Does the app collect my data?**
A: No. All data stays on your device. No analytics, no tracking.

**Q: Will this work with other LED controllers?**
A: Maybe. If your controller uses a similar protocol, it might work. Try it!

**Q: Can I schedule colors or create animations?**
A: Not yet. These are potential future features.

**Q: My LEDs flicker when changing colors**
A: This is normal during color transitions with some controllers.

**Q: Can I name my controller?**
A: The controller name comes from the device itself. You can't rename it in the app.

**Q: What happens if I lose connection?**
A: The LEDs will stay on the last color sent. They won't turn off automatically.
