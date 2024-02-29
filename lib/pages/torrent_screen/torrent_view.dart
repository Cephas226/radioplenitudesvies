import 'dart:io';
import 'dart:math';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../consts/app_defaults.dart';
import '../../consts/app_sizes.dart';
import '../../themes/text.dart';
import 'torrent_screen_controller.dart';
import 'package:http/http.dart' as http;

class TorrentScreenView extends StatefulWidget {
  DateTime selectedDate;
  DateTime lastDate;

  TorrentScreenView(
      {required this.selectedDate, required this.lastDate, super.key});

  @override
  _TorrentScreenViewState createState() => _TorrentScreenViewState();
}

class _TorrentScreenViewState extends State<TorrentScreenView> {
  //DateTime? selectedDate;
  Random random = new Random();
  final TorrentScreenController torrentController =
      Get.put(TorrentScreenController());

  @override
  void initState() {
    setState(() {
      //widget.selectedDate = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
            body: Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              stretch: true,
              onStretchTrigger: () {
                return Future<void>.value();
              },
              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                centerTitle: true,
                background: CalendarAppBar(
                  backButton: false,
                  accent: const Color.fromARGB(255, 0, 0, 0),
                  onDateChanged: (value) => setState(() => {
                        widget.selectedDate = value as DateTime,
                        torrentController.fetchTorrents(
                            widget.selectedDate.toString().split(' ')[0])
                      }),
                  //firstDate: widget.selectedDate,
                  lastDate: widget.lastDate,
                  events: List.generate(
                      100,
                      (index) => DateTime.now()
                          .subtract(Duration(days: index * random.nextInt(5)))),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.DEFAULT_PADDING * 0.25),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    InkWell(
                        child: const Icon(Icons.arrow_circle_left,
                            color: Colors.black, size: 30),
                        onTap: () => Get.back()),
                    Obx(() => Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        child: torrentController.torrents.isNotEmpty
                            ?
                        Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List<Widget>.generate(
                                    torrentController.torrents.length, (index) {
                                  var item = torrentController.torrents[index];
                                  return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(5.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                item.daily_attachments.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var attachment =
                                                  item.daily_attachments[index];
                                              return Column(children: [
                                                Image.network(
                                                  attachment['attachment']
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 27, 6, 6),
                                                      boxShadow: AppDefaults
                                                          .defaultBoxShadow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.00),
                                                    ),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5,
                                                        horizontal: 109),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          InkWell(
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(Icons.download_for_offline, color: Colors.white),
                                                                            onPressed: () async =>
                                                                                {
                                                                              _saveImage(attachment['attachment'].toString(), item.id, context),
                                                                            },
                                                                            iconSize:
                                                                                30.0,
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(Icons.share, color: Colors.white),
                                                                            onPressed: () async =>
                                                                                {
                                                                              shareNetworkImage(attachment['attachment'].toString(), "Medite avec moi !")
                                                                            },
                                                                            iconSize:
                                                                                30.0,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ]);
                                            },
                                          ),
                                        ),
                                        const Divider()
                                      ]);
                                }),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Revenez sur les précédentes méditations ...',
                                  style: AppText.h6,
                                )))),
                    AppSizes.hGap30,
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  _saveImage(url, name, context) async {
    if (await Permission.storage.request().isGranted) {
      ScaffoldMessenger.of(context as BuildContext)
          .showSnackBar(mysnackBar("Image sauvegardé"));
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {}
  }

  SnackBar mysnackBar(message) {
    return SnackBar(content: Text(message as String));
  }

  Future<void> shareNetworkImage(String imageUrl, String text) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Directory directory = await getTemporaryDirectory();
    final File file = await File('${directory.path}/Image.png')
        .writeAsBytes(response.bodyBytes);
    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: text,
    );
  }
}
