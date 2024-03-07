
import 'package:photo_retriever_platform_interface/photo_retriever_platform_interface_lib.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class PhotoRetrieverPlatformInterface extends PlatformInterface {
  PhotoRetrieverPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static PhotoRetrieverPlatformInterface get instance => _instance;

  static PhotoRetrieverPlatformInterface _instance = PhotoRetrieverMethodChannel()..init();

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PhotoRetrieverApplePlatform] when
  /// they register themselves.
  static set instance(PhotoRetrieverPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setType(PhotoCacheType type) {
    throw UnimplementedError("setType() should be implemented");
  }

  Future<List<RetrievedPhoto>?> getPhotos(ThumbnailOption option) {
    throw UnimplementedError("getPhotos() should be implemented");
  }

  Future<RetrievedPhoto?> getOriginalPhoto(String id) {
    throw UnimplementedError("getOriginalPhoto() should be implemented");
  }
  Stream<SelectedUpdatedEvent> onSelectedAccessUpdated() {
    throw UnimplementedError("onSelectedAccessUpdated() should be implemented");
  }

  Stream<GalleryUpdatedEvent> onGalleryUpdated() {
    throw UnimplementedError("onGalleryUpdated() should be implemented");
  }
}
