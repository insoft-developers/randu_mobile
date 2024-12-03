import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class JournalPhoto extends StatelessWidget {
  String url;
  JournalPhoto({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(url),
    ));
  }
}
