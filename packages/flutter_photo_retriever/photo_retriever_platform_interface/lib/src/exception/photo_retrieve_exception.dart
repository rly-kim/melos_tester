sealed class PhotoRetrieveError extends Error {
  static PhotoRetrieveError get(String code) {
    switch(code) {
      case "unknownMethodName":
        return UnknownMethodName();
      case "unknownAsset":
        return UnknownAsset();
      case "saveFailed":
        return SaveFailed();
      case "notInitialized":
        return NotInitialized();
      case "error":
      default:
        return PhotoRetrieveDefaultError();
    }
  }
}

class UnknownMethodName extends PhotoRetrieveError {
  final String code = "unknownMethodName";
  final String message = "정의되지 않은 메서드 입니다.";
}

class UnknownAsset extends PhotoRetrieveError {
  final String code = "unknownAsset";
  final String message = "사진을 불러 오는 데 실패 했습니다.";
}

class SaveFailed extends PhotoRetrieveError {
  final String message = "사진 저장에 실패 했습니다.";
  final String code = "saveFailed";
}

class NotInitialized extends PhotoRetrieveError {
  final String code = "notInitialized";
  final String message = "초기화에 실패 했습니다.";
}

class PhotoRetrieveDefaultError extends PhotoRetrieveError {
  final String code = "error";
  final String message = "오류가 발생 했습니다.";
}
//
// extension PhotoRetrieveErrorX on PhotoRetrieveError {
//   static PhotoRetrieveError get(String code) {
//     switch(code) {
//       case "unknownMethodName":
//         return UnknownMethodName();
//       case "unknownAsset":
//         return UnknownAsset();
//       case "saveFailed":
//         return SaveFailed();
//       case "notInitialized":
//         return NotInitialized();
//       case "error":
//       default:
//         return PhotoRetrieveDefaultError();
//     }
//   }
// }
