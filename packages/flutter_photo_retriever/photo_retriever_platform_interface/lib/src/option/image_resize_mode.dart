
/// 요청된 이미지의 크기를 조정하는 방법을 지정
///
/// none: 리사이징 안함
/// fast: 타겟 사이즈와 비슷하거나 약간 더 큰 크기로 효율적으로 조정.
/// exact: 타겟 사이즈랑 정확하게 일치하도록 이미지 크기를 조정.
enum ImageResizeMode {
  none(0),
  fast(1),
  exact(2);

  final int value;
  const ImageResizeMode(this.value);
}
