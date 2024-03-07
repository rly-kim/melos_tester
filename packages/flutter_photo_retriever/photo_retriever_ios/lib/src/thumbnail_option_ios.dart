import 'package:photo_retriever_platform_interface/photo_retriever_platform_interface_lib.dart';

class IosThumbnailOption extends ThumbnailOption {
  final ImageDeliveryMode deliveryMode;
  final ImageResizeMode resizeMode;
  final ImageContentMode contentMode;
  final ThumbImageLoadOption format;
  final double width;
  final double height;
  final double quality;

  IosThumbnailOption({
    ImageDeliveryMode? deliveryMode,
    ImageResizeMode? resizeMode,
    ImageContentMode? contentMode,
    ThumbImageLoadOption? format,
    double? width,
    double? height,
    double? quality,
  }):
        deliveryMode = deliveryMode ?? ImageDeliveryMode.opportunistic,
        resizeMode = resizeMode ?? ImageResizeMode.none,
        contentMode = contentMode ?? ImageContentMode.aspectFit,
        format = format ?? ThumbImageLoadOption.png,
        width = width ?? 100,
        height = height ?? 100,
        quality = quality ?? 50
  ;

  @override
  Map<String, dynamic> toJson() {
    return {
      "option": {
        "deliveryMode": deliveryMode.value,
        "resizeMode": resizeMode.value,
        "contentMode": contentMode.value,
        "width": width,
        "height": height,
        "quality": quality,
        "format": format.value,
      }
    };
  }
}
