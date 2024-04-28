import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pixagallery/models/image_model.dart' as img;

class FullScreenImage extends StatelessWidget {
  final img.ImageModel image;

  const FullScreenImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: image.largeImageURL,
            child: PhotoView(
              imageProvider: NetworkImage(image.largeImageURL),
            ),
          ),
        ),
      ),
    );
  }
}
