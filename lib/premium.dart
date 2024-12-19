import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/homepage_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Premium extends StatefulWidget {
  const Premium({Key? key}) : super(key: key);

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
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
        backgroundColor: Colors.white,
        body: Container(
            margin: const EdgeInsets.all(30),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Jarak(tinggi: 24),
                const Text("Profit Dulu Upgrade Kemudian",
                    style: TextStyle(
                        fontFamily: FontSetting.reg,
                        color: AppColor.mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                Jarak(tinggi: 30),
                const Text(
                    "Terima Kasih Telah Menjadi Pengguna Setia Aplikasi  Randu.",
                    style: TextStyle(
                        fontFamily: FontSetting.reg,
                        color: AppColor.mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Jarak(tinggi: 10),
                Image.asset("images/thank_you.png"),
                Jarak(tinggi: 30),
                const Text(
                    "Jika bisnis Anda belum menghasilkan profit (keuntungan) atau hanya digunakan untuk mencatat keuangan sehari-hari, Anda dapat terus menggunakan aplikasi ini secara gratis tanpa biaya sepeser pun, tanpa ada batasan transaksi berapapun.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: FontSetting.reg,
                        color: AppColor.mainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                Jarak(tinggi: 20),
                const Text(
                    "Namun, apabila bisnis Anda sudah menghasilkan keuntungan lebih dari Rp10 juta per bulan atau omset lebih dari Rp50 juta per bulan, kami mengundang Anda untuk meng-upgrade ke versi premium dengan biaya hanya Rp819 per hari. Apa arti Rp819 dibandingkan dengan profit Rp10 juta per bulan, bukan? \nJika Anda menjalankan bisnis nirlaba (yayasan, panti asuhan, atau organisasi) atau menggunakan Randu untuk keperluan pendidikan baik sebagai pengajar maupun siswa, silakan hubungi kami melalui menu ticketing untuk mendapatkan akses premium secara gratis.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: FontSetting.reg,
                        color: AppColor.mainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                Jarak(tinggi: 20),
                const Text("Tim Randu, Sayangku Padamu Selalu.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: FontSetting.reg,
                        color: AppColor.mainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Jarak(tinggi: 30),
                ElevatedButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse('https://app.randu.co.id'),
                          mode: LaunchMode.externalApplication);
                    },
                    child: const Text("UPGRADE PREMIUM SEKARANG"))
              ],
            )),
      ),
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
