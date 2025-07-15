import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class FileModel {
  Uint8List file;
  String type;
  String name;

  FileModel(this.file, this.type,this.name);


}


class AttachmentsArea extends StatefulWidget {
  const AttachmentsArea({super.key});

  @override
  State<AttachmentsArea> createState() => _AttachmentsAreaState();
}

class _AttachmentsAreaState extends State<AttachmentsArea> {

  List<FileModel> files = [];

  late DropzoneViewController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kCornerRadius),
          border: Border.all(
              color: Colors.grey.shade200
          )
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.auto,
            onCreated: (DropzoneViewController ctrl) => controller = ctrl,
            onLoaded: () => print('Zone loaded'),
            onError: (String? ev) => print('Error: $ev'),
            // onHover: () => print('Zone hovered'),
            onDropFile: (DropzoneFileInterface file) async {
              print('Drop: ${file.name}');
              print(file.type);
              print(file.webkitRelativePath);
              if(
              file.type.toLowerCase().contains('pdf') ||
                  file.type.toLowerCase().contains('jpg') ||
                  file.type.toLowerCase().contains('jpeg') ||
                  file.type.toLowerCase().contains('png')
              ){
                var result = await controller.getFileData(file);
                files.add(FileModel(result,file.type,file.name.split('.')[0]));
                setState(() {

                });
              }

            } ,
            onDropString: (String s) => print('Drop: $s'),
            // onDropFiles: (List<DropzoneFileInterface> files) => print('Drop multiple: $files'),
            // onDropStrings: (List<String> strings) => print('Drop multiple: $strings'),
            onLeave: () => print('Zone left'),
          ),
          if(files.isEmpty)
            Text("Drop files here"),
          if(files.isNotEmpty)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 12,
                  runSpacing: 12,
                  children: files.map<Widget>((e){
                    return Column(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kCornerRadius),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 1,
                                      blurRadius: 4
                                    )
                                  ]
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(kCornerRadius),
                                  child: getFileDisplay(e),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        files.remove(e);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_circle_outlined,
                                      size: 25,
                                      color: Colors.red,
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            e.name,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                              color: Colors.black87
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    );
                  }).toList()

                ),
              ),
            )
          // Container(
          //   width: 400,
          //   height: 200,
          //   child: Center(
          //     child: Text("Drop files here"),
          //   ),
          // ),
        ],
      ),
    );
  }

  getFileDisplay(FileModel file){
    if(
    file.type.toLowerCase().contains('jpg') ||
        file.type.toLowerCase().contains('jpeg') ||
        file.type.toLowerCase().contains('png')
    ){
      return Image.memory(
        file.file,
        fit: BoxFit.cover,
        errorBuilder: (context,error,errorTrace){
          return Container(
            color: Colors.white,
            width: 80,
            height: 80,
            child: Icon(Icons.close,size: 50,),
          );
        },
      );
    }

    if(
    file.type.toLowerCase().contains('pdf')
        // ||
        // file.type.toLowerCase().contains('jpeg') ||
        // file.type.toLowerCase().contains('png')
    ){
      return Container(
        color: Colors.white,
        width: 80,
        height: 80,
        child: Icon(Icons.picture_as_pdf,size: 50,),
      );
    }
  }
}
