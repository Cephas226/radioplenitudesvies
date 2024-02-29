import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radioplenitudesvie/models/show.dart';
import '../../../consts/app_defaults.dart';
import '../../../consts/app_images.dart';
import 'package:get/route_manager.dart';

class ShowTile extends StatelessWidget {
  const ShowTile({
    super.key,
    required this.show,
    required this.onTap,
  });

  final Show show;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return
      show.name.isNotEmpty
          ?
      InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
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
                  child:
                  show.imagelink.isNotEmpty?
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: show.imagelink,
                    placeholder: (context, url) => const SpinKitThreeBounce(
                      color: Colors.redAccent,
                      size: 50.0,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                  :Image.asset(AppImages.DEFAULT, fit: BoxFit.cover),
                ),
              ),
            ),
           /* Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        basenameWithoutExtension(
                            const Utf8Decoder().convert(show.name.codeUnits)),
                        style: AppText.b1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )*/
          ],
        ),
      ),
    ):const SpinKitThreeBounce(
        color: Colors.redAccent,
        size: 50.0,
      );
  }
}
