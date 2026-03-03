import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeBackgroundImage extends StatelessWidget {
  final String? imagePath;
  final Widget? fallback;
  final BoxFit fit;

  const SafeBackgroundImage({
    super.key,
    this.imagePath,
    this.fallback,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return fallback ?? const SizedBox.shrink();
    }

    bool isNetwork = imagePath!.startsWith('http');
    bool isSvg = imagePath!.toLowerCase().endsWith('.svg');

    try {
      if (isSvg) {
        if (isNetwork) {
          return SvgPicture.network(
            imagePath!,
            fit: fit,
            placeholderBuilder: (context) =>
                fallback ?? const SizedBox.shrink(),
          );
        } else {
          return SvgPicture.asset(
            imagePath!,
            fit: fit,
            placeholderBuilder: (context) =>
                fallback ?? const SizedBox.shrink(),
          );
        }
      }

      return Image(
        image: isNetwork
            ? NetworkImage(imagePath!) as ImageProvider
            : AssetImage(imagePath!),
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return fallback ?? const SizedBox.shrink();
        },
      );
    } catch (e) {
      return fallback ?? const SizedBox.shrink();
    }
  }
}
