import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //return 'ca-app-pub-3940256099942544/6300978111';
      return 'ca-app-pub-8321174993863627/4707691143';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw new UnsupportedError("Platform not supported!");
  }
}
