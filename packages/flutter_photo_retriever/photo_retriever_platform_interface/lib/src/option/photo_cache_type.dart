/// 이미지 가져오는 방법 결정
/// memory: 바이너리 값을 리턴
/// local: 로컬에 이미지 저장 후 저장된 경로를 리턴
enum PhotoCacheType {
  memory(0), local(1)
  ;
  final int value;
  const PhotoCacheType(this.value);
}
