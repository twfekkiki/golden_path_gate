import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class FireStoreImage extends StatefulWidget {
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final WidgetBuilder? errorBuilder;

  const FireStoreImage({
    super.key,
    required this.path,
    this.fit,
    this.width,
    this.height,
    this.errorBuilder,
  });

  @override
  State<FireStoreImage> createState() => _FireStoreImageState();
}

class _FireStoreImageState extends State<FireStoreImage> {
  late String url;
  bool initialized = false;
  bool error = false;

  @override
  void initState() {
    final ref = FirebaseStorage.instance.ref().child(widget.path);
    ref
        .getDownloadURL()
        .then((value) {
          url = value;

          if (mounted) {
            setState(() {
              initialized = true;
            });
          }
        })
        .onError((err, stackTrance) {
          if (mounted) {
            setState(() {
              error = true;
            });
          }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context);
      }
    }
    if (initialized) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
      );
    }
    return Center(
      child: SpinKitThreeBounce(size: 15, color: AppColors.primary),
    );
  }
}
