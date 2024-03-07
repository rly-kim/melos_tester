import 'package:photo_retriever_platform_interface/photo_retriever_platform_interface_lib.dart';

sealed class PhotoRetrieverEvent {}

final class SelectedUpdatedEvent extends PhotoRetrieverEvent {
  final List<RetrievedPhoto>? updatedPhotos;

  SelectedUpdatedEvent(this.updatedPhotos);
}

final class GalleryUpdatedEvent extends PhotoRetrieverEvent {
  final ObservedPhotoChange changes;

  GalleryUpdatedEvent(this.changes);
}
