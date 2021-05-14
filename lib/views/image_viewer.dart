import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String image;
  ImageViewer(this.image);
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {


  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.image),
        )
    );
  }
}
