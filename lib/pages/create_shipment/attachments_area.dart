import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/appConfirmDialog.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/firestorageImage.dart';
import 'package:toastification/toastification.dart';

class AttachmentsArea extends StatefulWidget {
  final Function(List<FileModel>) onChanged;
  final Function(FileModel)? onDeleteFile;
  final List<FileModel>? initialFiles;
  final String? label;
  final int max;

  const AttachmentsArea({
    super.key,
    required this.onChanged,
    this.label,
    this.initialFiles,
    this.onDeleteFile,
    this.max = 4,
  });

  @override
  State<AttachmentsArea> createState() => _AttachmentsAreaState();
}

class _AttachmentsAreaState extends State<AttachmentsArea> {
  List<FileModel> files = [];

  late DropzoneViewController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCornerRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        alignment: Alignment.center,
        //fit: StackFit.expand,
        children: [
          DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.auto,
            onCreated: (DropzoneViewController ctrl) => controller = ctrl,
            onDropFile: (DropzoneFileInterface file) async {
              onFilesDropped(file);
            },
            // onLoaded: () {
            //   print("onLoaded");
            // },
            // onError: (err) {
            //   print(err);
            // },
          ),
          if (((widget.initialFiles ?? <FileModel>[]) + files).isEmpty)
            Text("Drop files here"),
          if (((widget.initialFiles ?? <FileModel>[]) + files).isNotEmpty)
            Positioned.fill(
              child:  SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                child: Row(
                  // direction: Axis.horizontal,
                  // crossAxisAlignment: WrapCrossAlignment.start,
                  // spacing: 12,
                  // runSpacing: 12,
                  children:
                  ((widget.initialFiles ?? <FileModel>[]) + files)
                      .map<Widget>((e) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 12
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          kCornerRadius,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          kCornerRadius,
                                        ),
                                        child: getFileDisplay(e),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (e.isLoaded) {
                                          var result =
                                          await AppConfirmDialog.show(
                                            context,
                                          );
                                          if (result ?? false) {
                                            if (widget.onDeleteFile !=
                                                null) {
                                              widget.onDeleteFile!(e);
                                            }
                                          }
                                        } else {
                                          setState(() {
                                            files.remove(e);
                                          });
                                          widget.onChanged(files);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outlined,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              e.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w200,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                      .toList(),
                ),
              )
            ),
        ],
      ),
    );
  }

  getFileDisplay(FileModel file) {
    if (file.isLoaded) {
      if (file.type.toLowerCase().contains('jpg') ||
          file.type.toLowerCase().contains('jpeg') ||
          file.type.toLowerCase().contains('png')) {
        return FireStoreImage(
          path: file.path!,
          fit: BoxFit.cover,
          errorBuilder: (context) {
            return Container(
              color: Colors.white,
              child: Icon(Icons.close, size: 50),
            );
          },
        );
      }
      if (file.type.toLowerCase().contains('pdf')) {
        return Container(
          color: Colors.white,
          child: Icon(Icons.picture_as_pdf, size: 50),
        );
      }
    } else {
      if (file.type.toLowerCase().contains('jpg') ||
          file.type.toLowerCase().contains('jpeg') ||
          file.type.toLowerCase().contains('png')) {
        return Image.memory(
          file.file!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, errorTrace) {
            return Container(
              color: Colors.white,
              child: Icon(Icons.close, size: 50),
            );
          },
        );
      }
      if (file.type.toLowerCase().contains('pdf')) {
        return Container(
          color: Colors.white,
          child: Icon(Icons.picture_as_pdf, size: 50),
        );
      }
    }
  }

  onFilesDropped(DropzoneFileInterface file, {String? label}) async {
    if (((widget.initialFiles ?? []).length + files.length) >= widget.max) {
      toastification.show(
        context: context,
        title: Text(AppLocalizations.of(context).trans("noMoreFiles")),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: AlignmentDirectional.topEnd,
        type: ToastificationType.error,
      );
      return;
    }

    if (file.type.toLowerCase().contains('pdf') ||
        file.type.toLowerCase().contains('jpg') ||
        file.type.toLowerCase().contains('jpeg') ||
        file.type.toLowerCase().contains('png')) {
      var result = await controller.getFileData(file);
      files.add(
        FileModel(
          file: result,
          type: file.type,
          name: file.name.split('.')[0],
          label: widget.label,
        ),
      );
      setState(() {});
      widget.onChanged(files);
    }
  }
}
