import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget getCachedImage({
  required String imageUrl,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
}) {
  final imageWidget = CachedNetworkImage(
    imageUrl: imageUrl,
    fit: fit,
    placeholder: (context, url) => const Center(
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );

  // If borderRadius is provided, wrap in ClipRRect
  if (borderRadius != null) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: imageWidget,
    );
  }
  
  // Otherwise return the image directly
  return imageWidget;
}