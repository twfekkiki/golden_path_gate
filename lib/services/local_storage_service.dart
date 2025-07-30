import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorageService {
  static const String appLanguageKey = "app_lang";
  static const String appBrightnessKey = "app_brightness";

  static final LocalStorageService _instance = LocalStorageService._internal();
  static late SharedPreferences _preferences;

  static LocalStorageService get instance => _instance;

  LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }
  init() async {
    await SharedPreferences.getInstance()
        .then((value){
      _preferences = value;
    });
  }

  // Language Code
  String? _languageCode;
  String get languageCode => _languageCode ?? (_getFromDisk(appLanguageKey)??'en');

  set languageCode(String? value) {
    _languageCode = value;
    _saveToDisk(appLanguageKey, value);
  }

  Brightness? _brightness;
  Brightness get brightness {
    if(_brightness != null){
      return _brightness!;
    }
    String? value = _getFromDisk(appBrightnessKey);
    _brightness = Brightness.light;
    if(value != null){
      _brightness = Brightness.values.firstWhere((element){
        return element.name == value;
      });
    }
    return _brightness!;
  }

  set brightness(Brightness? value) {
    _brightness = value??Brightness.light;
    _saveToDisk(appBrightnessKey, value?.name);
  }


  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    if (value is String) {
      return value == "" ? null : value;
    } else {
      return value;
    }
  }

  void _saveToDisk<T>(String key, content) {
    if (content == null) _preferences.remove(key);
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }


}
