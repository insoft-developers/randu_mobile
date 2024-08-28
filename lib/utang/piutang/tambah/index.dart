import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/textarea.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';

import 'package:randu_mobile/utang/piutang/tambah/tambah_piutang_controller.dart';

class TambahPiutang extends StatefulWidget {
  const TambahPiutang({Key? key}) : super(key: key);

  @override
  State<TambahPiutang> createState() => _TambahPiutangState();
}

class _TambahPiutangState extends State<TambahPiutang> {
  final TambahPiutangController _thc = Get.put(TambahPiutangController());
  final TextEditingController _tName = TextEditingController();
  final TextEditingController _tNominal = TextEditingController();
  final TextEditingController _tKeterangan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Piutang Baru"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            Jarak(tinggi: 20),
            Obx(() => SelectMonthReport(
                defValue: _thc.selectedCategory.value,
                label: "",
                menuItems: _thc.categoryDropdown,
                code: "tambah-piutang")),
            Jarak(tinggi: 20),
            Obx(() => _thc.loading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 50)
                : SelectMonthReport(
                    defValue: _thc.selectedSub.value,
                    label: "",
                    menuItems: _thc.subCategoryDropdown,
                    code: "piutang-sub-category")),
            Jarak(tinggi: 20),
            InputText(
                hint: "Input Nama",
                textInputType: TextInputType.text,
                textEditingController: _tName,
                obsecureText: false,
                code: "tambah-piutang"),
            Jarak(tinggi: 20),
            Obx(() => _thc.piutangFromLoading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 50)
                : SelectMonthReport(
                    defValue: _thc.selectedPiutangFrom.value,
                    label: "",
                    menuItems: _thc.piutangFromDropdown,
                    code: "piutang-from")),
            Jarak(tinggi: 20),
            Obx(() => _thc.piutangToLoading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 50)
                : SelectMonthReport(
                    defValue: _thc.selectedPiutangTo.value,
                    label: "",
                    menuItems: _thc.piutangToDropdown,
                    code: "piutang-to")),
            Jarak(tinggi: 20),
            InputText(
                hint: "Nominal",
                textInputType: TextInputType.number,
                textEditingController: _tNominal,
                obsecureText: false,
                code: "nominal-piutang"),
            Jarak(tinggi: 5),
            Obx(() => Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(_thc.nominalRibuan.value.toString(),
                    style: const TextStyle(
                        fontFamily: FontSetting.reg, color: Colors.red)))),
            Jarak(tinggi: 20),
            TextArea(
                hint: "Keterangan",
                textEditingController: _tKeterangan,
                maxline: 6),
            Jarak(tinggi: 30),
            Obx(
              () => _thc.storeLoading.value
                  ? const SizedBox(
                      child: Center(child: CircularProgressIndicator()))
                  : ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: AppColor.mainColor),
                      onPressed: () {
                        _thc.onPiutangStore(
                            _tName.text,
                            _tNominal.text.toString().isEmpty
                                ? 0
                                : int.parse(_tNominal.text),
                            _tKeterangan.text);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text("SUBMIT"))),
            ),
            Jarak(tinggi: 20)
          ],
        ),
      ),
    );
  }
}
