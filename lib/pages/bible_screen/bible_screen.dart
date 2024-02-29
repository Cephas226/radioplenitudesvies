import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../dashboard/dashboard_controller.dart';
import '../home/home_page.dart';
import 'bible_screen_controller.dart';

final BibleScreenController bibleScreenController =
    Get.put(BibleScreenController());
final DashboardController dashbCtrl = Get.put(DashboardController());
class BibleScreenView extends StatefulWidget {
  const BibleScreenView({super.key});

  @override
  _BibleScreenViewState createState() => _BibleScreenViewState();
}

class _BibleScreenViewState extends State<BibleScreenView> {
  List<dynamic> listPsalms = [];

  @override
  void initState() {
    super.initState();
    listPsalms.addAll(List.generate(151, (counter) => "Psaume $counter"));
    listPsalms.insertAll(
        listPsalms.indexOf("Psaume 113"), ["Psaume 113A", "Psaume 113B"]);
    listPsalms
        .insertAll(listPsalms.indexOf("Psaume 9"), ["Psaume 9A", "Psaume 9B"]);
    listPsalms.remove("Psaume 0");
    listPsalms.remove("Psaume 9");
    listPsalms.remove("Psaume 113");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () => {
                  Get.back()
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            elevation: 0,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => InkWell(
                      onTap: () => {
                            Get.to(()=>BookList(
                                bookName: bibleScreenController.currentshortName
                                    .toUpperCase()))
                          },
                      child: Chip(
                        label: Text(
                            "${bibleScreenController.currentshortName} | ${bibleScreenController.currentChapter}"),
                      )),
                ),
              ],
            )),
        body: Obx(() => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: bibleScreenController.chapterVerses.length,
                      itemBuilder: (context, index) {
                        var chapterVerses =
                            bibleScreenController.chapterVerses[index];
                        return bibleScreenController.chapterVerses.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.all(5),
                                child: HtmlWidget(
                                    "${chapterVerses.verse} ${chapterVerses.text}",
                                    textStyle: const TextStyle(height: 1.5,fontSize: 23,fontFamily: "Times New Roman")),
                              )
                            : Container();
                      }),
                ),
              /*  Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: IconButton(
                              onPressed: () => {
                                    bibleScreenController.loadPreviousChapter(
                                        bibleScreenController.currentBook
                                            .toString(),
                                        bibleScreenController.currentChapter
                                            .toString())
                                  },
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white)),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: IconButton(
                              onPressed: () => {
                                    bibleScreenController.loadNextChapter(
                                        bibleScreenController.currentBook
                                            .toString(),
                                        bibleScreenController.currentChapter
                                            .toString())
                                  },
                              icon: const Icon(Icons.arrow_forward,
                                  color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                )*/
              ],
            )),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  final String bookName;

  BookList({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFF924504),
          title: const Text("Liste des livres"),
          elevation: 0,
          leading:
          IconButton(
              onPressed: () => {
              Get.offNamedUntil('/', (route) => false)
                  },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Hero(
            tag: bookName,
            child: Obx(
              () => Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, bottom: 10, right: 16),
                  child: Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: bibleScreenController.booksList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  child: ListTile(
                                    title: Text(bibleScreenController
                                        .booksList[index].longName
                                        .toString()[0]
                                        .toUpperCase() +
                                        bibleScreenController
                                            .booksList[index].longName
                                            .toString()
                                            .substring(1)),
                                    trailing: IconButton(
                                        onPressed: () => {
                                          bibleScreenController.loadChapters(
                                              bibleScreenController
                                                  .booksList[index].shortName
                                                  .toString()),
                                          Get.to(() => BookDetails(
                                              bookLongName: bibleScreenController
                                                  .booksList[index].longName.toString(),
                                              bookShortName: bibleScreenController
                                                  .booksList[index].shortName
                                                  .toString()))
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF924504),
                                        )),
                                  ),
                                  onTap: () => {
                                    bibleScreenController.loadChapters(
                                        bibleScreenController
                                            .booksList[index].shortName
                                            .toString()),
                                    Get.to(() => BookDetails(
                                        bookLongName: bibleScreenController
                                            .booksList[index].longName.toString(),
                                        bookShortName: bibleScreenController
                                            .booksList[index].shortName
                                            .toString()))
                                  },
                                ),
                                const Divider()
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            )));
  }
}

class BookDetails extends StatelessWidget {
  String bookShortName;
  String bookLongName;

  BookDetails({super.key, required this.bookShortName,required this.bookLongName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFF924504),
          title: Text(bookShortName),
          elevation: 0,
          leading: IconButton(
              onPressed: () => {
                    Get.back(),
                  },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: bibleScreenController.bookListChapters.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () => {
                          {
                            dashboardController.changeTabIndex(2),
                            bibleScreenController.loadInfo(
                                bookLongName,
                                bookShortName,
                                bibleScreenController.bookListChapters[index]
                                    .toString()),
                          },
                          Get.to(() => const BibleScreenView())
                        },
                    child: Container(
                      color: Colors.white70,
                      child: Center(
                        child: Text(
                          bibleScreenController.bookListChapters[index]
                              .toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ));
              },
            )));
  }
}
