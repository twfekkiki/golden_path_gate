import 'package:firebase_storage/firebase_storage.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseFileHandler {
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// Upload a list of FileModel objects to Firebase Storage
  /// Returns a list of uploaded file paths
  Future<List<String>> uploadFiles(List<FileModel> files) async {
    List<String> uploadedPaths = [];

    final DateTime now = DateTime.now();
    final String dateFolder = "${now.year}-${now.month}-${now.day}";

    try {
      for (var fileModel in files) {
        final String randomFileName = Uuid().v4();
        final String fileExtension = fileModel.type.split('/').last;//path.extension(fileModel.name); // keep original extension
        final String firebasePath = "Shipments/$dateFolder/$randomFileName.$fileExtension";

        print(firebasePath);
        final ref = storage.ref().child(firebasePath);


        final uploadTask = await ref.putData(
          fileModel.file!,
          SettableMetadata(contentType: fileModel.type),
        );
        if(uploadTask.state == TaskState.success) {
          uploadedPaths.add(firebasePath); // store the path for later use
        }
      }
      return uploadedPaths;
    } catch (e) {
      print("Error uploading files: $e");
      // Optionally, delete already uploaded files if you want to rollback
      await deleteFiles(uploadedPaths);
      rethrow;
    }
  }

  /// Delete files from Firebase Storage using their paths
  Future<void> deleteFiles(List<String> paths) async {
    for (var path in paths) {
      try {
        final ref = storage.ref().child(path);
        await ref.delete();
      } catch (e) {
        print("Error deleting file at $path: $e");
      }
    }
  }


  Future<bool> deleteFile(String storagePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      await storageRef.delete();
      return true;
    } catch (e) {
      print("Error deleting file: $e");
      return false;
    }
  }
}
