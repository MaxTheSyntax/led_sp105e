import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/led_preset.dart';
import '../services/sp105e_service.dart';
import '../services/preset_service.dart';
import '../widgets/preset_grid.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final SP105EService _sp105eService = SP105EService();
  final PresetService _presetService = PresetService();
  
  Color _currentColor = Colors.white;
  int _brightness = 100;
  List<LedPreset> _presets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPresets();
    _listenToConnectionState();
  }

  void _listenToConnectionState() {
    _sp105eService.connectionState.listen((connected) {
      if (!connected && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device disconnected'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  Future<void> _loadPresets() async {
    final presets = await _presetService.getAllPresets();
    setState(() {
      _presets = presets;
      _isLoading = false;
    });
  }

  Future<void> _sendColor(Color color, {int? brightness}) async {
    final brt = brightness ?? _brightness;
    final success = await _sp105eService.sendColor(color, brightness: brt);
    
    if (success) {
      setState(() {
        _currentColor = color;
        if (brightness != null) {
          _brightness = brightness;
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send color'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) {
              setState(() {
                _currentColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _sendColor(_currentColor);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showSavePresetDialog() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Custom Preset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Preset Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }

              final preset = LedPreset(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                color: _currentColor,
                brightness: _brightness,
                isCustom: true,
              );

              final success = await _presetService.addCustomPreset(preset);
              if (mounted) {
                Navigator.pop(context);
                
                if (success) {
                  await _loadPresets();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preset saved successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to save preset'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePreset(LedPreset preset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset'),
        content: Text('Are you sure you want to delete "${preset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _presetService.deleteCustomPreset(preset.id);
      if (success) {
        await _loadPresets();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preset deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LED Controller'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () => _sendColor(Colors.black, brightness: 0),
            tooltip: 'Turn Off',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Current Color Display
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Current Color',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: _currentColor,
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _currentColor.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Brightness: $_brightness%',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Slider(
                              value: _brightness.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: '$_brightness%',
                              onChanged: (value) {
                                setState(() {
                                  _brightness = value.round();
                                });
                              },
                              onChangeEnd: (value) {
                                _sendColor(_currentColor);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Color Picker Button
                    ElevatedButton.icon(
                      onPressed: _showColorPicker,
                      icon: const Icon(Icons.palette),
                      label: const Text('Pick Custom Color'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Presets Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Presets',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showSavePresetDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Save Current'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    PresetGrid(
                      presets: _presets,
                      onPresetTap: (preset) {
                        _sendColor(preset.color, brightness: preset.brightness);
                      },
                      onPresetDelete: (preset) {
                        if (preset.isCustom) {
                          _deletePreset(preset);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
