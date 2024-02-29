import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:radioplenitudesvie/consts/app_images.dart';
import 'package:radioplenitudesvie/models/author.dart';
import 'package:radioplenitudesvie/models/torrent_cover_model.dart';
import '../../../consts/app_defaults.dart';
import 'package:get/route_manager.dart';

import '../../themes/text.dart';
import '../dashboard/dashboard_controller.dart';
import '../torrent_screen/torrent_view.dart';

class AuthorPocket extends StatelessWidget {
  const AuthorPocket({
    super.key,
    required this.author,
    required this.onTap,
  });

  final Author author;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
        child: Column(children: [
          Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppDefaults.defaultBoxShadow,
                borderRadius: AppDefaults.defaulBorderRadius,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ClipRRect(
                    borderRadius: AppDefaults.defaultBottomSheetRadius,
                    child: InkWell(
                        onTap: onTap,
                        child: SizedBox(
                          width: Get.width * 0.6,
                          child: AspectRatio(
                            aspectRatio: 9 / 10,
                            child: author.imagelink.isNotEmpty
                                ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: author.imagelink,
                              placeholder: (context, url) => const SpinKitThreeBounce(
                                color: Colors.redAccent,
                                size: 50.0,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                                : Image.asset(
                              AppImages.APPBAR1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 200,
                              child: Text(
                                const Utf8Decoder().convert(author.name.codeUnits),
                                style: AppText.b1.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                )
              ])),

        ],));
  }
}
