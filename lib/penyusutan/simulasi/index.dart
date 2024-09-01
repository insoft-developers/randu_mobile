import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/penyusutan/simulasi/simulasi_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';

class Simulasi extends StatefulWidget {
  String id;
  Simulasi({Key? key, required this.id}) : super(key: key);

  @override
  State<Simulasi> createState() => _SimulasiState();
}

class _SimulasiState extends State<Simulasi> {
  final SimulasiController _simulasiController = Get.put(SimulasiController());

  @override
  void initState() {
    _simulasiController.getSimulasiData(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Simulasi Penyusutan"),
        ),
        body: Column(
          children: [
            Jarak(tinggi: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColor.mainColor),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    child: const Text("Nilai Awal",
                        style: TextStyle(
                            fontFamily: FontSetting.bold,
                            color: AppColor.putih)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    child: const Text("Penyusutan",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: FontSetting.bold,
                            color: AppColor.putih)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 3 - 20,
                    child: const Text("Nilai Akhir",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontFamily: FontSetting.bold,
                            color: AppColor.putih)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Obx(
                  () => _simulasiController.loading.value
                      ? InputJurnalShimmer(tinggi: 80, jumlah: 10, pad: 0)
                      : ListView.builder(
                          itemCount: _simulasiController.simulasiList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColor.display,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      _simulasiController.simulasiList[index]
                                              ['month']
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: FontSetting.bold,
                                          fontSize: 16)),
                                  const Divider(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    3 -
                                                10,
                                        child: Text(
                                            Ribuan.formatAngka(
                                                _simulasiController
                                                    .simulasiList[index]
                                                        ['initial_book_value']
                                                    .toString()),
                                            style: const TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    3 -
                                                10,
                                        child: Text(
                                            Ribuan.formatAngka(
                                                _simulasiController
                                                    .simulasiList[index]
                                                        ['shrinkage']
                                                    .toString()),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    1 /
                                                    3 -
                                                20,
                                        child: Text(
                                            Ribuan.formatAngka(
                                                _simulasiController
                                                    .simulasiList[index]
                                                        ['final_book_value']
                                                    .toString()),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontFamily: FontSetting.reg)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                ),
              ),
            ),
          ],
        ));
  }
}
