/*
*  flutter developer Amin Azizzadeh
*  This class is created for convenience. To fix problem "Flutter web : Could not find an option named "--web-renderer""
* */

import 'dart:html' as html;
import 'dart:ui_web';

import 'package:flutter/material.dart';

class WebImageWidget extends StatelessWidget {
  final String imageUrl;

  const WebImageWidget(
    this.imageUrl, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    platformViewRegistry.registerViewFactory(
      imageUrl,
      (int viewId) {
        final img = html.ImageElement();
        img.src = imageUrl;
        img.draggable = false;
        img.style.width = '100%';
        img.style.height = '100%';

        // Image loading error handling
        img.onError.listen((event) {
          print("Failed to load image: $imageUrl");

          img.src =
              'assets/noimage.jpg'; // example: Default image if there is no link
        });

        return img;
      },
    );

    return HtmlElementView(viewType: imageUrl);
  }
}
