import 'package:flutter/cupertino.dart';

import 'local_storage_service.dart';

class AppConfigService extends ChangeNotifier{

  AppConfigService();

  set lang(String value) {
    LocalStorageService.instance.languageCode = value;
    notifyListeners();
  }
  String get lang => LocalStorageService.instance.languageCode;

  set brightness(Brightness value) {
    LocalStorageService.instance.brightness = value;
    notifyListeners();
  }
  Brightness get brightness => LocalStorageService.instance.brightness;
}