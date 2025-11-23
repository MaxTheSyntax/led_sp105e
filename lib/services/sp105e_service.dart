import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Service for communicating with SP105E LED Controller
class SP105EService {
  static final SP105EService _instance = SP105EService._internal();
  factory SP105EService() => _instance;
  SP105EService._internal();

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  
  final _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionState => _connectionStateController.stream;
  bool get isConnected => _connectedDevice != null;
  String? get connectedDeviceName => _connectedDevice?.platformName;

  // SP105E specific UUIDs (common Bluetooth LE characteristics)
  static const String serviceUuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
  static const String characteristicUuid = '0000ffe1-0000-1000-8000-00805f9b34fb';

  /// Scan for SP105E devices
  Stream<List<ScanResult>> scanForDevices() {
    final controller = StreamController<List<ScanResult>>();
    final devices = <String, ScanResult>{};

    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
    );

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        // Filter for SP105E or LED controller devices
        final name = result.device.platformName.toLowerCase();
        if (name.contains('sp105e') || 
            name.contains('sp1') ||
            name.contains('led') || 
            name.contains('magic') ||
            name.contains('dream') ||
            name.contains('rgb') ||
            name.contains('light')) {
          devices[result.device.remoteId.toString()] = result;
        }
      }
      controller.add(devices.values.toList());
    });

    controller.onCancel = () {
      subscription.cancel();
      FlutterBluePlus.stopScan();
    };

    return controller.stream;
  }

  /// Stop scanning
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  /// Connect to a device
  Future<bool> connect(BluetoothDevice device) async {
    try {
      await device.connect(timeout: const Duration(seconds: 15));
      _connectedDevice = device;

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      
      // Find the service and characteristic
      for (var service in services) {
        if (service.uuid.toString().toLowerCase().contains('ffe0') ||
            service.characteristics.isNotEmpty) {
          for (var characteristic in service.characteristics) {
            if (characteristic.properties.write) {
              _writeCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      if (_writeCharacteristic == null && services.isNotEmpty) {
        // Fallback: use first writable characteristic
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            if (characteristic.properties.write) {
              _writeCharacteristic = characteristic;
              break;
            }
          }
          if (_writeCharacteristic != null) break;
        }
      }

      _connectionStateController.add(true);
      return true;
    } catch (e) {
      debugPrint('Connection error: $e');
      _connectionStateController.add(false);
      return false;
    }
  }

  /// Disconnect from device
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _writeCharacteristic = null;
      _connectionStateController.add(false);
    }
  }

  /// Send color to the LED controller
  /// 
  /// NOTE: The SP105E protocol implementation is based on common LED controller
  /// protocols. The exact byte sequence may need adjustment based on your specific
  /// SP105E firmware version. Common protocol variations include:
  /// - Some versions use 0x38 as header, others use 0x56
  /// - Checksum calculation may vary by model
  /// 
  /// If colors don't work correctly, you may need to:
  /// 1. Capture the protocol from the official app using a BLE sniffer
  /// 2. Adjust the byte sequence in this method accordingly
  Future<bool> sendColor(Color color, {int brightness = 100}) async {
    if (_writeCharacteristic == null) {
      debugPrint('No write characteristic available');
      return false;
    }

    try {
      // SP105E protocol: Send RGB values
      final red = color.red;
      final green = color.green;
      final blue = color.blue;
      
      // Apply brightness
      final adjustedRed = (red * brightness / 100).round();
      final adjustedGreen = (green * brightness / 100).round();
      final adjustedBlue = (blue * brightness / 100).round();

      // Create command packet (common LED controller protocol format)
      // Format: [Header, Red, Green, Blue, White, Mode, Speed, Footer]
      final data = Uint8List.fromList([
        0x38, // Header byte (common for many LED controllers)
        adjustedRed,
        adjustedGreen,
        adjustedBlue,
        0x00, // White channel (not used)
        0x01, // Mode (static color)
        0x00, // Speed (not used for static)
        0x83, // Footer/checksum byte
      ]);

      // Use withoutResponse: true for better performance during rapid updates
      await _writeCharacteristic!.write(data, withoutResponse: true);
      debugPrint('Sent color: R=$adjustedRed G=$adjustedGreen B=$adjustedBlue');
      return true;
    } catch (e) {
      debugPrint('Error sending color: $e');
      return false;
    }
  }

  /// Turn off LEDs
  Future<bool> turnOff() async {
    return sendColor(Colors.black, brightness: 0);
  }

  void dispose() {
    _connectionStateController.close();
  }
}
