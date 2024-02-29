import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:radioplenitudesvie/pages/dashboard/dashboard_page.dart';
import '../../../consts/app_defaults.dart';
import 'package:get/route_manager.dart';

import '../dashboard/dashboard_controller.dart';
import '../torrent_screen/torrent_view.dart';
final DashboardController dashboardController = Get.put(DashboardController());

class TorrentCoover extends StatelessWidget {
  const TorrentCoover({
    Key? key,
    required this.torrent,
  }) : super(key: key);

  final dynamic torrent;
  DateTime premiereDateDuMois(int annee, int mois) {
    return DateTime(annee, mois, 1);
  }
  DateTime derniereDateDuMois(int annee, int mois) {
    return DateTime(annee, mois + 1, 0);
  }
  @override
  Widget build(BuildContext context) {

    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: AppDefaults.defaultBoxShadow,
          borderRadius: AppDefaults.defaulBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: AppDefaults.defaultBottomSheetRadius,
                child: InkWell(child: SizedBox(
                  width: Get.width * 0.3,
                  child: AspectRatio(
                    aspectRatio: 7 / 10,
                    child:
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: torrent['imagelink'].toString(),
                      placeholder: (context, url) => const SpinKitThreeBounce(
                        color: Colors.redAccent,
                        size: 50.0,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                  ),
                ),onTap: ()=>{
                  //dashboardController.changeTabIndex(1),
                  Get.to(()=>TorrentScreenView(
                      selectedDate:premiereDateDuMois(int.parse(accueilController.currentYear.value.toString()), int.parse(basenameWithoutExtension(
                torrent['name'].toString()))),
                lastDate:derniereDateDuMois(int.parse(accueilController.currentYear.value.toString()), int.parse(basenameWithoutExtension(
                torrent['name'].toString())))
                  )
                  ),
                })
            ),
            /*SizedBox(
                child: Text(basenameWithoutExtension(
                    torrent['name'].toString().replaceFirst(RegExp(r'^\d+-\w+\s+'), '')),
                  style: AppText.b1.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ))*/
          ],
        ),
      ),
    );
  }
}
