import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/color/app_color.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/homepage/homepage_controller.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/journal/index.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';
import 'package:randu_mobile/journal/tambah/input_jurnal/index.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/index.dart';
import 'package:randu_mobile/laporan/index.dart';
import 'package:randu_mobile/pengaturan/index.dart';
import 'package:randu_mobile/penyusutan/index.dart';
import 'package:randu_mobile/utang/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController _homePageController = Get.put(HomePageController());
  final JurnalController _jurnalController = Get.put(JurnalController());
  var pages = [
    const Journal(),
    const Laporan(),
    const Utang(),
    const Penyusutan(),
    const Pengaturan(),
  ];

  @override
  void initState() {
    _homePageController.getBranchName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Obx(
              () => _homePageController.pageTitle.value == ''
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const InputJurnal())!.then(
                                (value) => _jurnalController.getJournalList());
                          },
                          child: const Text("Input Jurnal")),
                    )
                  : const SizedBox(),
            ),
            Obx(
              () => _homePageController.pageTitle.value == ''
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                          onPressed: () {
                            Get.to(() => const JurnalCepat())!.then(
                                (value) => _jurnalController.getJournalList());
                          },
                          child: const Text("Jurnal Cepat",
                              style: TextStyle(color: AppColor.mainColor))),
                    )
                  : const SizedBox(),
            )
          ],
          backgroundColor: AppColor.mainColor,
          title: Obx(
            () => Text(
              _homePageController.pageTitle.toString(),
            ),
          ),
        ),
        body: Obx(() => pages[_homePageController.tabIndex.value]),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 150,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColor.mainColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/randu.png",
                        fit: BoxFit.contain,
                        width: 70,
                      ),
                      Spasi(lebar: 20),
                      Obx(
                        () => _homePageController.branchLoading.value
                            ? TextShimmer(lebar: 150, tinggi: 30)
                            : SizedBox(
                                width: 150,
                                child: Obx(
                                  () => Text(
                                      _homePageController.branchName.value
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'RubikBold',
                                          fontSize: 20,
                                          color: Colors.white)),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      height: 40, child: Image.asset("images/jurnal_icon.png")),
                  Spasi(lebar: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Jurnal",
                          style:
                              TextStyle(fontFamily: 'RubikBold', fontSize: 15)),
                      Text("Jurnal Akuntansi",
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 13)),
                    ],
                  )
                ]),
                onTap: () {
                  _homePageController.changeTabIndex(0);
                  _homePageController.changePageTitle("");
                  Get.back();
                },
              ),
              Jarak(tinggi: 10),
              ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      height: 40,
                      child: Image.asset("images/laporan_icon.png")),
                  Spasi(lebar: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Laporan",
                          style:
                              TextStyle(fontFamily: 'RubikBold', fontSize: 15)),
                      Text("Lihat Laporan",
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 13)),
                    ],
                  )
                ]),
                onTap: () {
                  _homePageController.changeTabIndex(1);
                  _homePageController.changePageTitle("Laporan");
                  Get.back();
                },
              ),
              Jarak(tinggi: 10),
              ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      height: 40, child: Image.asset("images/utang_icon.png")),
                  Spasi(lebar: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Utang / Piutang",
                          style:
                              TextStyle(fontFamily: 'RubikBold', fontSize: 15)),
                      Text("Data Utang / Piutang",
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 13)),
                    ],
                  )
                ]),
                onTap: () {
                  _homePageController.changeTabIndex(2);
                  _homePageController.changePageTitle("Utang & Piutang");
                  Get.back();
                },
              ),
              Jarak(tinggi: 10),
              ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      height: 40,
                      child: Image.asset("images/penyusutan_icon.png")),
                  Spasi(lebar: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Penyusutan",
                          style:
                              TextStyle(fontFamily: 'RubikBold', fontSize: 15)),
                      Text("Data Aset dan Peralatan",
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 13)),
                    ],
                  )
                ]),
                onTap: () {
                  _homePageController.changeTabIndex(3);
                  _homePageController.changePageTitle("Penyusutan");
                  Get.back();
                },
              ),
              Jarak(tinggi: 10),
              ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      height: 40,
                      child: Image.asset("images/pengaturan_icon.png")),
                  Spasi(lebar: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Pengaturan Aplikasi",
                          style:
                              TextStyle(fontFamily: 'RubikBold', fontSize: 15)),
                      Text("Data Bisnis dan Aplikasi",
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 13)),
                    ],
                  )
                ]),
                onTap: () {
                  _homePageController.changeTabIndex(4);
                  _homePageController.changePageTitle("Pengaturan Aplikasi");
                  Get.back();
                },
              ),
              Jarak(tinggi: 40),
              ListTile(
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(height: 40, child: Image.asset("images/exit.png")),
                  Spasi(lebar: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Keluar",
                          style:
                              TextStyle(fontFamily: 'RubikBold', fontSize: 15)),
                      Text("Keluar dari Aplikasi",
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 13)),
                    ],
                  )
                ]),
                onTap: () {
                  _homePageController.logout();
                },
              ),
            ],
          ),
        ));
  }
}
