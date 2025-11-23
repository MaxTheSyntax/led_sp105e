import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/led_preset.dart';

/// Service for managing LED presets
class PresetService {
  static const String _presetsKey = 'custom_presets';

  /// Load custom presets from storage
  Future<List<LedPreset>> loadCustomPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final presetsJson = prefs.getString(_presetsKey);
      
      if (presetsJson == null || presetsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(presetsJson);
      return decoded.map((json) => LedPreset.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Save custom presets to storage
  Future<bool> saveCustomPresets(List<LedPreset> presets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customPresets = presets.where((p) => p.isCustom).toList();
      final presetsJson = jsonEncode(
        customPresets.map((preset) => preset.toJson()).toList(),
      );
      return await prefs.setString(_presetsKey, presetsJson);
    } catch (e) {
      return false;
    }
  }

  /// Add a new custom preset
  Future<bool> addCustomPreset(LedPreset preset) async {
    final presets = await loadCustomPresets();
    presets.add(preset);
    return await saveCustomPresets(presets);
  }

  /// Delete a custom preset
  Future<bool> deleteCustomPreset(String presetId) async {
    final presets = await loadCustomPresets();
    presets.removeWhere((preset) => preset.id == presetId);
    return await saveCustomPresets(presets);
  }

  /// Get all presets (default + custom)
  Future<List<LedPreset>> getAllPresets() async {
    final customPresets = await loadCustomPresets();
    return [...LedPreset.defaultPresets, ...customPresets];
  }
}
