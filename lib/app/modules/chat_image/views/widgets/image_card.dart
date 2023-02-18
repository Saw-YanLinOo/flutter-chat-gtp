import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/app/model/image_generation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    this.images,
    required this.onTapCopy,
    required this.onTapDownload,
  }) : super(key: key);

  final List<ImageGenerationData>? images;
  final Function(String) onTapDownload;
  final Function(String) onTapCopy;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        itemCount: images?.length,
        itemBuilder: (context, index) {
          var url = images?[index].url ?? '';

          print('image url :::::::::: $url');
          return Card(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: 150,
                    width: 150,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(.3),
                      highlightColor: Colors.grey,
                      child: Container(
                        height: 220,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            onTapDownload(url);
                          },
                          child: const Icon(Icons.save_alt, size: 28)),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            onTapCopy(url);
                          },
                          child: const Icon(Icons.copy, size: 28)),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
