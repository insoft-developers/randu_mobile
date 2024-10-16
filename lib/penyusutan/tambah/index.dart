import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/textarea.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/penyusutan/tambah/tambah_penyusutan_controller.dart';

class TambahPenyusutan extends StatefulWidget {
  const TambahPenyusutan({Key? key}) : super(key: key);

  @override
  State<TambahPenyusutan> createState() => _TambahPenyusutanState();
}

class _TambahPenyusutanState extends State<TambahPenyusutan> {
  final TambahPenyusutanController _tpc = Get.put(TambahPenyusutanController());
  final TextEditingController _tName = TextEditingController();
  final TextEditingController _tInitValue = TextEditingController();
  final TextEditingController _umur = TextEditingController();
  final TextEditingController _residu = TextEditingController();
  final TextEditingController _note = TextEditingController();

  @override
  void initState() {
    _tpc.getPenyusutanCategory();
    _tpc.getAkumulasiData();
    _tpc.getBebanPenyusutanData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Tambah Penyusutan"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Jarak(tinggi: 20),
              Obx(() => _tpc.categoryLoading.value
                  ? TextShimmer(
                      lebar: MediaQuery.of(context).size.width, tinggi: 50)
                  : SelectMonthReport(
                      defValue: _tpc.selectedKategori.value,
                      label: "",
                      menuItems: _tpc.categoryDropdown,
                      code: "tambah-penyusutan")),
              Jarak(tinggi: 20),
              Obx(() => _tpc.akumulasiLoading.value
                  ? TextShimmer(
                      lebar: MediaQuery.of(context).size.width, tinggi: 50)
                  : SelectMonthReport(
                      defValue: _tpc.selectedAkumulasi.value,
                      label: "",
                      menuItems: _tpc.akumulasiDropdown,
                      code: "akumulasi-penyusutan")),
              Jarak(tinggi: 20),
              Obx(() => _tpc.bebanLoading.value
                  ? TextShimmer(
                      lebar: MediaQuery.of(context).size.width, tinggi: 50)
                  : SelectMonthReport(
                      defValue: _tpc.selectedBeban.value,
                      label: "",
                      menuItems: _tpc.bebanDropdown,
                      code: "beban-penyusutan")),
              Jarak(tinggi: 20),
              InputText(
                  hint: "Input Nama Asset",
                  textInputType: TextInputType.text,
                  textEditingController: _tName,
                  obsecureText: false,
                  code: ""),
              Jarak(tinggi: 20),
              InputText(
                  hint: "Nilai Awal",
                  textInputType: TextInputType.number,
                  textEditingController: _tInitValue,
                  obsecureText: false,
                  code: "nilai-awal-penyusutan"),
              Jarak(tinggi: 2),
              Obx(() => Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(_tpc.nilaiAwalRibuan.value.toString(),
                      style: const TextStyle(
                          fontFamily: FontSetting.reg, color: Colors.red)))),
              Jarak(tinggi: 20),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 3 / 4 - 40,
                    child: InputText(
                        hint: "Umur Manfaat",
                        textInputType: TextInputType.number,
                        textEditingController: _umur,
                        obsecureText: false,
                        code: ""),
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(top: 14, bottom: 14, left: 10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                          color: AppColor.mainColor),
                      width: MediaQuery.of(context).size.width * 1 / 4,
                      child: const Text("Bulan",
                          style: TextStyle(
                              color: AppColor.putih,
                              fontFamily: FontSetting.bold)))
                ],
              ),
              Jarak(tinggi: 20),
              InputText(
                  hint: "Nilai Residu",
                  textInputType: TextInputType.number,
                  textEditingController: _residu,
                  obsecureText: false,
                  code: "residu-penyusutan"),
              Jarak(tinggi: 2),
              Obx(() => Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(_tpc.nilaiResiduRibuan.value.toString(),
                      style: const TextStyle(
                          fontFamily: FontSetting.reg, color: Colors.red)))),
              Jarak(tinggi: 5),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text(
                    "Nilai residu adalah nilai sisa atau nilai perkiraan yang diharapkan dari suatu aset setelah habis masa manfaatnya."),
              ),
              Jarak(tinggi: 20),
              TextArea(
                  hint: "Keterangan", textEditingController: _note, maxline: 6),
              Jarak(tinggi: 5),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text(
                    "Penyusutan Ini Menggunakan Metode Garis Lurus. Penyusutan Aset (Aktiva Tetap) dengan beban penyusutan tetap setiap bulan."),
              ),
              Jarak(tinggi: 30),
              Obx(
                () => _tpc.loading.value
                    ? const SizedBox(
                        child: Center(child: CircularProgressIndicator()))
                    : ElevatedButton(
                        onPressed: () {
                          _tpc.penyusutanStore(
                              _tName.text,
                              _tInitValue.text.isEmpty
                                  ? 0
                                  : int.parse(_tInitValue.text),
                              _umur.text.isEmpty ? 0 : int.parse(_umur.text),
                              _residu.text.isEmpty
                                  ? 0
                                  : int.parse(_residu.text));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.mainColor),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text("Submit", style: TextStyle(color: Colors.white)))),
              ),
              Jarak(tinggi: 30)
            ],
          ),
        ));
  }
}
