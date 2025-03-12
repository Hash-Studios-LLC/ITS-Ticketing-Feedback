import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import '../theme/app_theme.dart';
import '../models/media_file.dart';

class StatBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const StatBox({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class GoodPracticeItem extends StatelessWidget {
  final String text;

  const GoodPracticeItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✓  ',
            style: TextStyle(
              color: AppTheme.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class BadPracticeItem extends StatelessWidget {
  final String text;

  const BadPracticeItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✗  ',
            style: TextStyle(
              color: AppTheme.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class MediaItem extends StatelessWidget {
  final MediaFile file;
  final VoidCallback onRemove;

  const MediaItem({
    super.key,
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.gray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          _buildMediaPreview(),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (file.isImage) {
      if (file.bytes != null) {
        return Image.memory(
          file.bytes!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } else if (file.path != null && !kIsWeb) {
        return Image.file(
          File(file.path!),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      } else {
        return const Center(child: Text('Image Preview'));
      }
    } else {
      return Container(
        color: Colors.black12,
        child: const Center(
          child: Icon(
            Icons.videocam,
            size: 36,
            color: AppTheme.gray,
          ),
        ),
      );
    }
  }
}