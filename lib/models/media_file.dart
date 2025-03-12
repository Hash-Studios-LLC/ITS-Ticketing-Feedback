import 'package:flutter/foundation.dart' show Uint8List;

class MediaFile {
  final String name;
  final String? path;
  final Uint8List? bytes;
  final bool isImage;

  MediaFile({
    required this.name,
    this.path,
    this.bytes,
    required this.isImage,
  });
}