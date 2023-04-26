// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:numfu/widgets/show_image.dart';
import 'package:numfu/widgets/show_progress.dart';

class WidgetImageNetwork extends StatelessWidget {
  const WidgetImageNetwork({
    Key? key,
    required this.urlImage,
    this.size,
    this.boxFit,
    this.width,
    this.height,
  }) : super(key: key);

  final String urlImage;
  final double? size;
  final BoxFit? boxFit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlImage,
      placeholder: (context, url) => const ShowProgress(),
      errorWidget: (context, url, error) =>
          const ShowImage(path: 'img/logo.png'),
      fit: boxFit ?? BoxFit.cover,
      width: width ?? size,
      height: size,
    );
  }
}
