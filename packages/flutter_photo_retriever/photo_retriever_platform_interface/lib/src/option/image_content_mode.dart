/// 요청한 이미지 사이즈가 어떤 모드로 보여야할 지 설정
/// .aspectFit (default): 이미지 사이즈에 맞춰서 잘리지 않게 배치 (지정한 타겟 사이즈에 맞게 줄임)
/// .aspectFill: 이미지가 잘리더라도 화면에 꽉 채워짐(타겟 사이즈에 채우는 방식으로 스케일 줄임)
enum ImageContentMode {
  aspectFill(0),
  aspectFit(1);
  final int value;
  const ImageContentMode(this.value);
}
