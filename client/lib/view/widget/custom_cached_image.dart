import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCachedImage extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;
  const CustomCachedImage({
    super.key,
    required this.height,
    required this.width,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,

      // cache the image received from the server as a network image
      child: CachedNetworkImage(
        cacheManager: CacheManager(
          Config(
            'enebCacheKey', // cache key
            stalePeriod: const Duration(days: 1), // cache for 1 day
            maxNrOfCacheObjects: 100, // cache max 100 images
          ),
        ),
        imageUrl: imageUrl, // image url received from the server

        // error widget to display if the image fails to load
        errorWidget: (context, url, error) => const SizedBox.shrink(),
      ),
    );
  }
}
