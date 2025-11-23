import 'package:flutter/material.dart';

/// Represents a color preset for the LED controller
class LedPreset {
  final String id;
  final String name;
  final Color color;
  final int brightness;
  final bool isCustom;

  const LedPreset({
    required this.id,
    required this.name,
    required this.color,
    this.brightness = 100,
    this.isCustom = false,
  });

  /// Convert preset to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'brightness': brightness,
      'isCustom': isCustom,
    };
  }

  /// Create preset from JSON
  factory LedPreset.fromJson(Map<String, dynamic> json) {
    return LedPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['color'] as int),
      brightness: json['brightness'] as int? ?? 100,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  /// Create a copy with modified properties
  LedPreset copyWith({
    String? id,
    String? name,
    Color? color,
    int? brightness,
    bool? isCustom,
  }) {
    return LedPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  /// Default presets
  static List<LedPreset> get defaultPresets => [
        const LedPreset(
          id: 'warm_white',
          name: 'Warm White',
          color: Color(0xFFFFF8DC),
          brightness: 100,
        ),
        const LedPreset(
          id: 'cool_white',
          name: 'Cool White',
          color: Color(0xFFF0FFFF),
          brightness: 100,
        ),
        const LedPreset(
          id: 'red',
          name: 'Red',
          color: Color(0xFFFF0000),
          brightness: 100,
        ),
        const LedPreset(
          id: 'green',
          name: 'Green',
          color: Color(0xFF00FF00),
          brightness: 100,
        ),
        const LedPreset(
          id: 'blue',
          name: 'Blue',
          color: Color(0xFF0000FF),
          brightness: 100,
        ),
        const LedPreset(
          id: 'yellow',
          name: 'Yellow',
          color: Color(0xFFFFFF00),
          brightness: 100,
        ),
        const LedPreset(
          id: 'cyan',
          name: 'Cyan',
          color: Color(0xFF00FFFF),
          brightness: 100,
        ),
        const LedPreset(
          id: 'magenta',
          name: 'Magenta',
          color: Color(0xFFFF00FF),
          brightness: 100,
        ),
        const LedPreset(
          id: 'orange',
          name: 'Orange',
          color: Color(0xFFFFA500),
          brightness: 100,
        ),
        const LedPreset(
          id: 'purple',
          name: 'Purple',
          color: Color(0xFF800080),
          brightness: 100,
        ),
      ];
}
