import 'package:flutter/foundation.dart';

abstract class RetrievedPhoto {
  final String localIdentifier;

  RetrievedPhoto({required this.localIdentifier});
}

class RetrievedRawPhoto extends RetrievedPhoto {

  RetrievedRawPhoto({required this.byteImage, required super.localIdentifier});

  factory RetrievedRawPhoto.fromJson(dynamic json) {
    return RetrievedRawPhoto(
      localIdentifier: json["localIdentifier"] ?? "",
      byteImage: json["byteImage"] ?? Uint8List(0),
    );
  }

  final Uint8List byteImage;
}

class RetrievedPhotoPath extends RetrievedPhoto {

  RetrievedPhotoPath({required this.localPath, required super.localIdentifier});

  factory RetrievedPhotoPath.fromJson(dynamic json) {
    return RetrievedPhotoPath(
      localIdentifier: json["localIdentifier"] ?? "",
      localPath: json["localPath"] ?? "",
    );
  }

  final String localPath;
}
