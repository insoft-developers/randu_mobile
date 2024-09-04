import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/pengaturan/kode_rekening/kode_rekening_controller.dart';
import 'package:randu_mobile/pengaturan/kode_rekening/kode_rekening_detail.dart';

class KodeRekening extends StatefulWidget {
  const KodeRekening({Key? key}) : super(key: key);

  @override
  State<KodeRekening> createState() => _KodeRekeningState();
}

class _KodeRekeningState extends State<KodeRekening> {
  final KodeRekeningController _kodeRekeningController =
      Get.put(KodeRekeningController());

  @override
  void initState() {
    _kodeRekeningController.getAccountSelect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Pengaturan Kode Rekening"),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Obx(
          () => _kodeRekeningController.loading.value
              ? InputJurnalShimmer(tinggi: 50, jumlah: 20, pad: 0)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _kodeRekeningController.accountGroup.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColor.displayLine)),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => KodeRekeningDetail(
                              akun: index,
                              judul:
                                  _kodeRekeningController.accountGroup[index]));
                        },
                        splashColor: AppColor.mainColor,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  _kodeRekeningController.accountGroup[index]
                                      .toString(),
                                  style: const TextStyle(
                                      fontFamily: FontSetting.bold,
                                      fontSize: 16)),
                              Text(
                                  "Pengaturan " +
                                      _kodeRekeningController
                                          .accountGroup[index]
                                          .toString(),
                                  style: const TextStyle(
                                      fontFamily: FontSetting.reg,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
