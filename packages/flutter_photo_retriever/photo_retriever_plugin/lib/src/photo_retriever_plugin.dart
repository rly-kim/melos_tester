import 'package:photo_retriever_platform_interface/photo_retriever_platform_interface_lib.dart';

/// [PhotoRetrieverPlugin]은 플랫폼으로부터 사진을 가져오는 플러그인 인터페이스 입니다.
/// 메서드 요청이 실패할 경우 다음과 같은 에러들을 던집니다:
/// - UnknownMethodName: 정의되지 않은 메서드를 호출한 경우
/// - UnknownAsset: 사진 요청에 실패하는 경우 (ex) 존재 하지 않는 identifier
/// - SaveFailed: [PhotoCacheType.local]일 때 로컬 사진 저장에 실패 하는 경우 (ex) 경로 디렉터리 생성 실패, 사진 저장 실패
/// - NotInitialized: 네이티브에서 사용하는 객체가 초기화되지 않음
/// - PhotoRetrieveDefaultError: 응답값이 null로 떨어짐

class PhotoRetrieverPlugin {
  PhotoRetrieverPlatformInterface get _handler => PhotoRetrieverPlatformInterface.instance;

  Future<void> setType(PhotoCacheType type) async {
    _handler.setType(type);
  }

  Future<List<RetrievedPhoto>?> getPhotos(ThumbnailOption option) {
    return _handler.getPhotos(option);
  }

  Future<RetrievedPhoto?> getOriginalPhoto(String id) {
    return _handler.getOriginalPhoto(id);
  }

  Stream<SelectedUpdatedEvent> onSelectedAccessUpdated() {
    return _handler.onSelectedAccessUpdated();
  }

  Stream<GalleryUpdatedEvent> onGalleryUpdated() {
    return _handler.onGalleryUpdated();
  }
}
