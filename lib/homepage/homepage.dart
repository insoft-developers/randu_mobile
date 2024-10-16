import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/homepage_controller.dart';
import 'package:randu_mobile/journal/index.dart';
import 'package:randu_mobile/journal/jurnal_controller.dart';
import 'package:randu_mobile/journal/tambah/input_jurnal/index.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/index.dart';
import 'package:randu_mobile/laporan/index.dart';
import 'package:randu_mobile/pengaturan/index.dart';
import 'package:randu_mobile/penyusutan/index.dart';
import 'package:randu_mobile/penyusutan/penyusutan_controller.dart';
import 'package:randu_mobile/penyusutan/tambah/index.dart';
import 'package:randu_mobile/utang/index.dart';
import 'package:randu_mobile/utils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController _homePageController = Get.put(HomePageController());
  final JurnalController _jurnalController = Get.put(JurnalController());
  final PenyusutanController _penyusutanController =
      Get.put(PenyusutanController());
  var pages = [
    const Journal(),
    const Laporan(),
    const Utang(),
    const Penyusutan(),
    const Pengaturan(),
  ];

  @override
  void initState() {
    // _homePageController.getBranchName();
    _homePageController.initUserInfo();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Keluar Aplikasi...?',
              style: TextStyle(fontFamily: FontSetting.bold),
            ),
            content: const Text('Anda yakin ingin keluar dari Aplikasi...? ',
                style: TextStyle(fontFamily: FontSetting.reg)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: const Text('Ya'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              Obx(
                () => _homePageController.pageTitle.value == ''
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const InputJurnal())!.then((value) =>
                                  _jurnalController.getJournalList());
                            },
                            child: const Text("Input Jurnal")),
                      )
                    // ignore: unrelated_type_equality_checks
                    : _homePageController.pageTitle == 'Penyusutan'
                        ? GestureDetector(
                            onTap: () {
                              Get.to(() => const TambahPenyusutan())!.then(
                                  (value) => _penyusutanController
                                      .getDataPenyusutan());
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.add)),
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
                              Get.to(() => const JurnalCepat())!.then((value) =>
                                  _jurnalController.getJournalList());
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
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 230,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(
                          color: AppColor.mainColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                "images/randu_icon.png",
                                fit: BoxFit.contain,
                                width: 120,
                              ),
                            ),
                            Jarak(tinggi: 30),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Obx(
                                () => Text(_homePageController.userName.value,
                                    style: const TextStyle(
                                        fontFamily: FontSetting.bold,
                                        fontSize: 16,
                                        color: Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Obx(
                                () => Text(_homePageController.userEmail.value,
                                    style: const TextStyle(
                                        fontFamily: FontSetting.reg,
                                        fontSize: 13,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Jarak(tinggi: 20),
                    ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Image.asset("images/jurnal_icon.png")),
                            Spasi(lebar: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Jurnal",
                                    style: TextStyle(
                                        fontFamily: FontSetting.bold,
                                        fontSize: 15)),
                                Text("Jurnal Akuntansi",
                                    style: TextStyle(
                                        fontFamily: FontSetting.reg,
                                        fontSize: 13)),
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
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Image.asset("images/laporan_icon.png")),
                            Spasi(lebar: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Laporan",
                                    style: TextStyle(
                                        fontFamily: FontSetting.bold,
                                        fontSize: 15)),
                                Text("Lihat Laporan",
                                    style: TextStyle(
                                        fontFamily: FontSetting.reg,
                                        fontSize: 13)),
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
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Image.asset("images/utang_icon.png")),
                            Spasi(lebar: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Utang / Piutang",
                                    style: TextStyle(
                                        fontFamily: FontSetting.bold,
                                        fontSize: 15)),
                                Text("Data Utang / Piutang",
                                    style: TextStyle(
                                        fontFamily: FontSetting.reg,
                                        fontSize: 13)),
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
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child:
                                    Image.asset("images/penyusutan_icon.png")),
                            Spasi(lebar: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Penyusutan",
                                    style: TextStyle(
                                        fontFamily: FontSetting.bold,
                                        fontSize: 15)),
                                Text("Data Aset dan Peralatan",
                                    style: TextStyle(
                                        fontFamily: FontSetting.reg,
                                        fontSize: 13)),
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
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 40,
                                child:
                                    Image.asset("images/pengaturan_icon.png")),
                            Spasi(lebar: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Pengaturan Aplikasi",
                                    style: TextStyle(
                                        fontFamily: FontSetting.bold,
                                        fontSize: 15)),
                                Text("Data Bisnis dan Aplikasi",
                                    style: TextStyle(
                                        fontFamily: FontSetting.reg,
                                        fontSize: 13)),
                              ],
                            )
                          ]),
                      onTap: () {
                        _homePageController.changeTabIndex(4);
                        _homePageController
                            .changePageTitle("Pengaturan Aplikasi");
                        Get.back();
                      },
                    ),
                    Jarak(tinggi: 80),
                    Text("VERSI " + Constant.VERSION,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: FontSetting.reg, fontSize: 13)),
                    Text(Constant.RELEASE_DATE,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: FontSetting.reg, fontSize: 13)),
                    Jarak(tinggi: 200),
                  ],
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Column(
                      children: [
                        const Divider(),
                        Jarak(tinggi: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          color: Colors.white,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _homePageController.showWebsite();
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                            1 /
                                            2 -
                                        50,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.support_agent,
                                            color: AppColor.mainColor,
                                            size: 30),
                                        Spasi(lebar: 5),
                                        const Text("Bantuan",
                                            style: TextStyle(
                                                fontFamily: FontSetting.bold,
                                                color: AppColor.mainColor))
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showAlertDialog(context);
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                            1 /
                                            2 -
                                        100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.exit_to_app,
                                            color: AppColor.merah, size: 30),
                                        Spasi(lebar: 5),
                                        const Text("Keluar",
                                            style: TextStyle(
                                                fontFamily: FontSetting.bold,
                                                color: AppColor.merah))
                                      ],
                                    ),
                                  ),
                                ),
                                Spasi(lebar: 10),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  showAlertDialog(BuildContext context) {
    final HomePageController _homepage = HomePageController();
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
          child: const Text("Ya",
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontSetting.reg,
              ))),
      onPressed: () {
        _homepage.logout();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Keluar Aplikasi",
          style: TextStyle(
            fontFamily: FontSetting.bold,
            color: Colors.green,
          )),
      content: const Text("Anda yakin ingin keluar dari aplikasi?",
          style: TextStyle(
            fontFamily: FontSetting.reg,
            fontSize: 15,
          )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
