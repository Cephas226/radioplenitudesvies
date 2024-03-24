import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../consts/app_defaults.dart';
import '../../consts/app_images.dart';
import '../themes/text.dart';
import 'package:get/route_manager.dart';

class PodcastListTile extends StatelessWidget {
  const PodcastListTile({
    super.key,
    required this.podCast,
    required this.styleContainer,
    required this.textColor
  });
  final dynamic podCast;
  final Color textColor;
  final BoxDecoration styleContainer;

  @override
  Widget build(BuildContext context) {
    return
      Container(
      decoration: styleContainer,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppDefaults.defaulBorderRadius,
            child: SizedBox(
              width: Get.width * 0.1,
              child: AspectRatio(
                aspectRatio: 8 / 8,
                child: Image.asset(
                  AppImages.COVER,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),

                      child:
                      Text(
                        basenameWithoutExtension(const Utf8Decoder()
                            .convert('${podCast.tag.title}'.codeUnits)),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style: AppText.b1.copyWith(
                          fontSize: 12,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
