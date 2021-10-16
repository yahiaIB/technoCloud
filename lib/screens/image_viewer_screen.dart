import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewWrapper extends StatelessWidget {
  HeroPhotoViewWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale = PhotoViewComputedScale.contained,
    this.maxScale ,
    this.viewExitButton = true
  });

  final ImageProvider? imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final bool viewExitButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              imageProvider: imageProvider,
              backgroundDecoration: backgroundDecoration,
              minScale: minScale,
              maxScale: maxScale,
              loadingBuilder: (_,__) =>Center(child: CircularProgressIndicator(backgroundColor: Colors.blueAccent)),
              heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
            ),
          ),
          viewExitButton ? Positioned(
            right: 30,
            top: 30,
            child: IconButton(
              icon: Icon(Icons.clear),
              iconSize: 24,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ): Container()
        ],
      ),
    );
  }
}