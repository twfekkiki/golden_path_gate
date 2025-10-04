import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/appConfirmDialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';


class AttachmentsView extends StatefulWidget {

  // final Function(List<FileModel>) onChanged;
  final List<FileModel> attachments;

  const AttachmentsView({super.key, /*required this.onChanged,*/ required this.attachments});

  @override
  State<AttachmentsView> createState() => _AttachmentsViewState();
}

class _AttachmentsViewState extends State<AttachmentsView> {

  List<String>? files;

  // late DropzoneViewController controller;

  @override
  void initState() {
    initFileLinks();
    super.initState();
  }

  initFileLinks() async {
    files = [];
    for(var file in widget.attachments){
      final ref = FirebaseStorage.instance.ref().child(file.path!);
      String url = await ref.getDownloadURL();
      files!.add(url);
    }

    WidgetsBinding.instance.addPostFrameCallback((timestamp){
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(files != null && files!.isNotEmpty) {
      return Container(
            width: 500,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kCornerRadius),
                border: Border.all(
                    color: Colors.grey.shade200
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(widget.attachments.length, (index){
                    var e = widget.attachments[index];
                    return Column(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap:(){
                                  openFileInNewTab(files![index]);
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
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
                                    child: getFileDisplay(e,files![index]),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () async {
                                      var result = await AppConfirmDialog.show(context);
                                      if(result){
                                        context.read<ShipmentsDetailsProvider>().deleteAttachment(widget.attachments[index]);
                                      }
                                      // setState(() {
                                      //   files.remove(e);
                                      // });
                                      // widget.onChanged(files);
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
                  })
              ),
            )
        );
    }
    return const SizedBox();
  }

  getFileDisplay(FileModel file,fullUrl){
    if(
    file.type.toLowerCase().contains('jpg') ||
        file.type.toLowerCase().contains('jpeg') ||
        file.type.toLowerCase().contains('png')
    ){
      return Image.network(
        fullUrl,
        // file.path!,
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
    if(file.type.toLowerCase().contains('pdf')){
      return Container(
        color: Colors.white,
        width: 80,
        height: 80,
        child: Icon(Icons.picture_as_pdf,size: 50,),
      );
    }
  }

  void openFileInNewTab(String fileUrl) async {
    final uri = Uri.parse(fileUrl);

    // For Flutter Web, this will open in a new tab
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        webOnlyWindowName: '_blank', // important for opening in new tab
      );
    } else {
      print('Could not launch $fileUrl');
    }
  }
}
