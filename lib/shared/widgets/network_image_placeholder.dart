import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yha/core/theme/app_colors.dart';

class NetworkImagePlaceholder extends StatelessWidget {
  const NetworkImagePlaceholder({super.key, this.imageUrl, this.fit = BoxFit.cover, this.height, this.width, this.borderRadius});

  final String? imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl ?? '';
    Widget child;
    if (url.isEmpty) {
      child = Container(
        color: AppColors.border,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      );
    } else {
      child = CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: (context, url) => Container(
          color: AppColors.border,
          alignment: Alignment.center,
          child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.border,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
        ),
      );
    }
    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return SizedBox(height: height, width: width, child: child);
  }
}
