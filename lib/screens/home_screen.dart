import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/sp105e_service.dart';
import 'control_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SP105EService _sp105eService = SP105EService();
  List<ScanResult> _devices = [];
  bool _isScanning = false;
  bool _bluetoothEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  Future<void> _checkBluetoothState() async {
    final state = await FlutterBluePlus.adapterState.first;
    setState(() {
      _bluetoothEnabled = state == BluetoothAdapterState.on;
    });
    
    if (_bluetoothEnabled) {
      _startScan();
    }
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    _sp105eService.scanForDevices().listen((devices) {
      if (mounted) {
        setState(() {
          _devices = devices;
        });
      }
    }).onDone(() {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await _sp105eService.connect(device);
    
    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ControlScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to device'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SP105E LED Controller'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          if (!_bluetoothEnabled)
            Container(
              color: Colors.red.shade100,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.bluetooth_disabled, color: Colors.red),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Bluetooth is disabled. Please enable it in settings.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isScanning ? 'Scanning...' : 'Available Devices',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (!_isScanning && _bluetoothEnabled)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _startScan,
                    tooltip: 'Scan for devices',
                  ),
              ],
            ),
          ),
          if (_isScanning)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: _devices.isEmpty && !_isScanning
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_searching,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No devices found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Make sure your SP105E controller is powered on',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index].device;
                      final rssi = _devices[index].rssi;
                      final name = device.platformName.isEmpty 
                          ? 'Unknown Device' 
                          : device.platformName;
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.bluetooth,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(name),
                          subtitle: Text(device.remoteId.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$rssi dBm',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () => _connectToDevice(device),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sp105eService.stopScan();
    super.dispose();
  }
}
