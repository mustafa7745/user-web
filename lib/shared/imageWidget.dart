import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui_web' as ui_web;

class HtmlImageWidget extends StatelessWidget {
  final String imageUrl;
  final String width;
  final String height;

  HtmlImageWidget({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    // Register the HTML element
    // Using a static method to ensure it's only registered once
    ui_web.platformViewRegistry.registerViewFactory('imageElement',
        (int viewId) {
      print(viewId);
      final imgElement = html.ImageElement(src: imageUrl)
        ..style.width = width // Set width to 100% or desired size
        ..style.height = height; // Maintain aspect ratio
      return imgElement;
    });

    // Return HtmlElementView to embed the HTML image element
    return const HtmlElementView(viewType: 'imageElement');
  }
}
