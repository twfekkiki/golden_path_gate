import 'package:flutter/foundation.dart';

class FileModel {
  Uint8List? file;
  String type;
  String name;
  String? path;
  String? label;

  FileModel({this.file, required this.type, required this.name, this.path,this.label});

  Map<String, dynamic> get toMap => {
    "type": type,
    "name": name,
    "path": path,
    "label": label,
  };

  factory FileModel.fromJson(Map<String, dynamic> data) {
    return FileModel(
      type: data['type'],
      name: data['name'],
      path: data['path'],
      label: data['label']
    );
  }


  bool get isLoaded {
    return path != null;
  }
}
