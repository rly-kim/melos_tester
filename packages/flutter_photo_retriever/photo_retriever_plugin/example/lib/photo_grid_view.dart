import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_retriever_plugin/photo_retriever_plugin.dart';

class PhotoGridView extends StatefulWidget {
  PhotoGridView({super.key, required this.type, required this.photos});

  final PhotoRetrieverPlugin plugin = PhotoRetrieverPlugin();
  final List<RetrievedPhoto> photos;
  final PhotoCacheType type;

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  @override
  Widget build(BuildContext context) {
    return widget.photos.isEmpty
        ? const Text("가져온 사진이 없습니다.")
        : Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 1개의 행에 항목을 3개씩
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: widget.photos.length,
              itemBuilder: (BuildContext context, int index) {
                return GridItemSelector(type: widget.type, photo: widget.photos[index]);
              },
            ),
          );
  }
}

class GridItemSelector extends StatelessWidget {
  GridItemSelector({super.key, required this.type, required this.photo});

  final PhotoCacheType type;
  final RetrievedPhoto photo;
  final PhotoRetrieverPlugin plugin = PhotoRetrieverPlugin();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // type check by "res is RetrievedRawPhoto..."
        final res = await plugin.getOriginalPhoto(photo.localIdentifier);
        debugPrint(res.toString());
      },
      child: checkCacheType(type),
    );
  }

  Widget checkCacheType(PhotoCacheType type) {
    switch(type) {
      case PhotoCacheType.memory:
        return Image.memory(
          (photo as RetrievedRawPhoto).byteImage,
          fit: BoxFit.cover,
        );
      case PhotoCacheType.local:
        return Image.file(
          File((photo as RetrievedPhotoPath).localPath),
          fit: BoxFit.cover,
        );
    }
  }
}
