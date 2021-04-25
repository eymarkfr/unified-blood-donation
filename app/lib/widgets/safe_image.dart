import 'package:flutter/material.dart';

class SafeUrlImage extends StatelessWidget {
  final String? imageUrl;
  final String placeholderAsset;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const SafeUrlImage(
      {Key? key,
      this.imageUrl,
      required this.placeholderAsset,
      this.width,
      this.height,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Image.asset(
            placeholderAsset,
            height: height,
            width: width,
            fit: fit,
          )
        : Image.network(imageUrl!, height: height, width: width, fit: fit);
  }
}


dynamic getSafeImageProvider(String placeholderAsset, String? imageUrl) {
  return imageUrl == null ? AssetImage(placeholderAsset) : NetworkImage(imageUrl);
}

