/// 이미지 데이터 요청 옵션
///
/// .opportunistic(기본값): 여러장의 사진은 자동으로 밸런스, 퀄리티, 반응성 있는 한개 이상의 결과를 제공
/// .highQualityFormat: 여러장의 사진은 오직 고화질 이미지만 제공 가능. 시간이 많이 걸려도 상관 하지 않겠다.
/// .fastFormat: 여러장 사진은 오직 빠른 속도로 로딩 이미지를 제공. 이미지 퀄리티 저하 가능.
enum ImageDeliveryMode {
  opportunistic(0),
  highQualityFormat(1),
  fastFormat(2);
  final int value;
  const ImageDeliveryMode(this.value);
}
