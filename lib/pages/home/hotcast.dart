import 'package:flutter/material.dart';
import '../../../consts/app_colors.dart';
import '../../../consts/app_defaults.dart';
import '../../../consts/app_images.dart';
import '../../../consts/app_sizes.dart';
import '../../themes/text.dart';
import 'package:get/route_manager.dart';

class HotcastTile extends StatelessWidget {
  const HotcastTile({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.b1.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  AppSizes.wGap20,
                  Container(
                    padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING / 2),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            ClipRRect(
              borderRadius: AppDefaults.defaultBottomSheetRadius,
              child: Container(
                width: Get.width * 0.6,
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    AppImages.podcastImages[3],
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