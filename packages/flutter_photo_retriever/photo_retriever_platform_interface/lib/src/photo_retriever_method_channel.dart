import 'dart:async';

import 'package:flutter/services.dart';
import 'package:photo_retriever_platform_interface/photo_retriever_platform_interface_lib.dart';

/// An implementation of [PhotoRetrieverPlatformInterface] that uses method channels.
class PhotoRetrieverMethodChannel extends PhotoRetrieverPlatformInterface {
  MethodChannel? _channel;

  final StreamController _streamController = StreamController<PhotoRetrieverEvent>.broadcast();

  void init() {
    _channel ??= const MethodChannel('flutter.startkit/photo_retriever')
      ..setMethodCallHandler((call) {
        return _handleMethodChannel(call);
      });
  }

  Future<dynamic> _handleMethodChannel(MethodCall call) async {
    switch (call.method) {
      case 'update':
        _streamController.add(SelectedUpdatedEvent(_convertJsonToPhotos(call.arguments.cast<String, dynamic>())));
      case 'galleryObserved':
        _streamController
            .add(GalleryUpdatedEvent(_convertJsonToObservedChange(call.arguments.cast<String, dynamic>())));
    }
  }

  /// 이미지 가져오는 방식 결정
  @override
  Future<void> setType(PhotoCacheType type) async {
    final res = await _channel!.invokeMethod('setCacheType', <String, int>{
      'type': type == PhotoCacheType.memory ? 0 : 1,
    });
    if (res != true) {
      throw PhotoRetrieveDefaultError();
    }
  }

  /// 썸네일 가져오기
  @override
  Future<List<RetrievedPhoto>> getPhotos(ThumbnailOption option) async {
    try {
      final res = await _channel!.invokeMethod('fetchThumbnails', option.toJson());
      if (res == null) {
        throw PhotoRetrieveDefaultError();
      }
      return _convertJsonToPhotos(res.cast<String, dynamic>());
    } on PlatformException catch(e) {
      throw PhotoRetrieveError.get(e.code);
    }
  }

  /// 선택된 사진의 오리지널 이미지 가져오기
  @override
  Future<RetrievedPhoto?> getOriginalPhoto(String id) async {
    try {
      final res = await _channel!.invokeMethod('fetchOriginalPhoto', <String, dynamic>{
        'identifier': id,
      });
      final int? type = res['type'];
      final item = res['item'];
      if (item == null || type == null) {
        throw PhotoRetrieveDefaultError();
      }
      final Map<String, dynamic> mapItem = item.cast<String, dynamic>();
      return _convertJsonFromPhotoByType(type, mapItem);
    } on PlatformException catch(e) {
      throw PhotoRetrieveError.get(e.code);
    }
  }

  /// 플랫폼으로부터 선택된 사진 변경 이벤트를 받을 수 있음
  @override
  Stream<SelectedUpdatedEvent> onSelectedAccessUpdated() {
    return _streamController.stream.where((e) => e is SelectedUpdatedEvent).cast<SelectedUpdatedEvent>();
  }

  /// 플랫폼으로부터 갤러리 업데이트 이벤트를 받을 수 있음
  @override
  Stream<GalleryUpdatedEvent> onGalleryUpdated() {
    return _streamController.stream.where((e) => e is GalleryUpdatedEvent).cast<GalleryUpdatedEvent>();
  }

  List<RetrievedPhoto> _convertJsonToPhotos(Map<String, dynamic> res) {
    final List<dynamic>? itemList = res['entities'];
    final int? type = res['type'];

    if (itemList == null || type == null) {
      throw PhotoRetrieveDefaultError();
    }
    return itemList.map((item) =>
      _convertJsonFromPhotoByType(type, item.cast<String, dynamic>())
    ).toList();
  }

  ObservedPhotoChange _convertJsonToObservedChange(Map<String, dynamic> res) {
    return ObservedPhotoChange.fromJson(res);
  }

  RetrievedPhoto _convertJsonFromPhotoByType(int type, Map<String, dynamic> item) {
    if (type == 0) {
      return RetrievedRawPhoto.fromJson(item);
    }
    if (type == 1) {
      return RetrievedPhotoPath.fromJson(item);
    }
    throw PhotoRetrieveDefaultError();
  }
}
