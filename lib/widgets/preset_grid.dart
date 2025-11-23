import 'package:flutter/material.dart';
import '../models/led_preset.dart';

class PresetGrid extends StatelessWidget {
  final List<LedPreset> presets;
  final Function(LedPreset) onPresetTap;
  final Function(LedPreset)? onPresetDelete;

  const PresetGrid({
    super.key,
    required this.presets,
    required this.onPresetTap,
    this.onPresetDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (presets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No presets available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        return _PresetCard(
          preset: preset,
          onTap: () => onPresetTap(preset),
          onDelete: preset.isCustom && onPresetDelete != null
              ? () => onPresetDelete!(preset)
              : null,
        );
      },
    );
  }
}

class _PresetCard extends StatelessWidget {
  final LedPreset preset;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _PresetCard({
    required this.preset,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (onDelete != null)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.grey,
                ),
              )
            else
              const SizedBox(height: 8),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: preset.color,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: preset.color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                preset.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (preset.isCustom)
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.amber,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
