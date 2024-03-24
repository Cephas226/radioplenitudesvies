import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../consts/app_defaults.dart';
import '../../consts/app_images.dart';
import '../models/pod_model.dart';
import '../themes/text.dart';
import 'package:get/route_manager.dart';
import 'package:path/path.dart';

class ShowSpecialTile extends StatelessWidget {
  const ShowSpecialTile({
    super.key,
    required this.showSpecial,
    required this.imageLink,
    required this.onTap,
  });

  final PodCast showSpecial;
  final String imageLink;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppDefaults.defaultBoxShadow,
          borderRadius: AppDefaults.defaulBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: AppDefaults.defaultBottomSheetRadius,
              child: SizedBox(
                width: Get.width * 0.6,
                child:
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: imageLink.isNotEmpty
                      ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageLink,
                    placeholder: (context, url) => const SpinKitThreeBounce(
                      color: Colors.redAccent,
                      size: 50.0,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                      : Image.asset(
                    AppImages.APPBAR2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
