import 'dart:io';
import 'dart:math';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radioplenitudesvie/pages/home/home_page.dart';
import 'package:share_plus/share_plus.dart';
import '../../consts/app_defaults.dart';
import '../../consts/app_sizes.dart';
import '../../models/note.dart';
import '../../themes/text.dart';
import 'note_view.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
        RefreshIndicator(
          onRefresh: () => torrentController.fetchTorrents(
              widget.selectedDate.toString().split(' ')[0]),
            child: Scaffold(
            body:
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
                        background: Column(
                          children: [
                            Expanded(child: CalendarAppBar(
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
                            ),)
                          ],
                        )
                      ),
                    ),
                    Obx(() => SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.DEFAULT_PADDING * 0.25),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  child:  Chip(
                                    backgroundColor:torrentController.isTorrent.value?Colors.grey:Colors.white,
                                    label:const Text(
                                        "Torrent de Vie"),
                                  ),
                                  onTap: ()=>{
                                    torrentController.isTorrent.value = true
                                  },
                                ),
                                const SizedBox(height: 70,width: 10),
                                InkWell(
                                  child:  Chip(
                                    backgroundColor:torrentController.isTorrent.value?Colors.white:Colors.grey,
                                    label: const Text(
                                        "Mes notes"),
                                  ),
                                  onTap: ()=>{
                                    torrentController.isTorrent.value = false
                                  },
                                )
                              ],
                            ),
                            torrentController.isTorrent.value ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /* Container(
                                  width: 50,
                                  height: 50,
                                  margin:const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.black),
                                  child: IconButton(
                                    icon:
                                    const Icon(Icons.arrow_back_ios, color: Colors.white),
                                    onPressed: () async =>
                                    {
                                      Get.back()
                                    },
                                    iconSize:
                                    30.0,
                                  ),
                                ),*/
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin:const EdgeInsets.only(left: 5,right: 10),
                                  decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.black),
                                  child: IconButton(
                                    icon:
                                    const Icon(Icons.download, color: Colors.white),
                                    onPressed: () async =>
                                    {
                                      torrentController.torrents.map((torrent) => _saveImage(torrent.daily_attachments.toString(), torrent.id, context))
                                    },
                                    iconSize:
                                    30.0,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin:const EdgeInsets.only(left: 5,right: 10),
                                  decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.black),
                                  child: IconButton(
                                    icon:
                                    const Icon(Icons.share, color: Colors.white),
                                    onPressed: () async =>
                                    {
                                      print('ok'),
                                      torrentController.torrents.map((torrent) => shareNetworkImage(torrent.daily_attachments.toString(),"Medite avec moi !"))
                                      // shareNetworkImage(attachment['attachment'].toString(), "Medite avec moi !")
                                    },
                                    iconSize:
                                    30.0,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin:const EdgeInsets.only(left: 5,right: 10),
                                  decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.black),
                                  child: IconButton(
                                    icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                    onPressed: () async =>
                                    {
                                      Get.to(()=>NoteScreenView())
                                  },
                                    iconSize:
                                    30.0,
                                  ),
                                )
                              ],
                            ):Container(),
                            torrentController.isTorrent.value ?
                            Obx(() => Container(
                                margin: const EdgeInsets.symmetric(vertical: 0),
                                child: torrentController.torrents.isNotEmpty
                                    ?
                                Column(
                                  key: _scaffoldKey,
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
                                                  /*Container(
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
                                                      ))*/
                                                ]);
                                              },
                                            ),
                                          ),
                                          const Divider()
                                        ]);
                                  }),
                                )
                                    : Center(
                                    child: Text(
                                      'Revenez sur les précédentes méditations ...',
                                      style: AppText.h6,
                                    )))): Container(
                                margin: const EdgeInsets.symmetric(vertical: 0),
                                child: !torrentController.isTorrent.value
                                    ?
                                Obx(() => Container(
                                    key: _scaffoldKey,
                                    margin: const EdgeInsets.symmetric(vertical: 0),
                                    child: torrentController.torrents.isNotEmpty
                                        ?
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: torrentController.notes.length,
                                      itemBuilder: (context, index) {
                                        Note note = torrentController.notes[index] as Note;
                                        return GestureDetector(
                                          onTap: () {
                                            // Get.to(() => NoteScreenView(note: note));
                                          },
                                          onLongPress: () {

                                          },
                                          child: NoteCard(
                                            title: note.title,
                                            date: note.cdt,
                                          ),
                                        );
                                      },
                                    )
                                        : Center(
                                        child: Text(
                                          'Revenez sur les précédentes méditations ...',
                                          style: AppText.h6,
                                        ))))
                                    : Center(
                                    child: Text(
                                      '...',
                                      style: AppText.h6,
                                    ))),
                            AppSizes.hGap30,
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
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
  Widget _buildSection({Widget? child}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: child!,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCompleted() {
    return Obx(
          () => ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: torrentController.notes.length,
            itemBuilder: (context, index) {
              Note note = torrentController.notes[index] as Note;
              return GestureDetector(
                onTap: () {
                 // Get.to(() => ViewTodoScreen(todo: note));
                },
                onLongPress: () {
                  // torrentController.toggleTodo(note);
                },
                child: NoteCard(
                  title: note.title,
                  date: note.cdt,
                ),
              );
            },
          ),
    );
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
class NoteCard extends StatelessWidget {
  const NoteCard({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);
  final String title;
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.fromLTRB(0, 2, 0, 5),
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 2,
            spreadRadius: 10,
          )
        ],
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Text(''),
        ],
      ),
    );
  }
}
