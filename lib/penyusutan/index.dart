import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_search.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/select/select_year_report.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/penyusutan/penyusutan_controller.dart';
import 'package:randu_mobile/penyusutan/simulasi/index.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:randu_mobile/utils/tanggal.dart';

class Penyusutan extends StatefulWidget {
  const Penyusutan({Key? key}) : super(key: key);

  @override
  State<Penyusutan> createState() => _PenyusutanState();
}

class _PenyusutanState extends State<Penyusutan> {
  final PenyusutanController _penyusutanController =
      Get.put(PenyusutanController());
  final TextEditingController _textCari = TextEditingController();

  @override
  void initState() {
    _penyusutanController.akunBiayaPenyusutan();
    _penyusutanController.getDataPenyusutan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Obx(() => _penyusutanController.categoryLoading.value
                    ? TextShimmer(
                        lebar: MediaQuery.of(context).size.width, tinggi: 50)
                    : SelectMonthReport(
                        defValue: _penyusutanController.selectedCategory.value,
                        label: "Pilih Beban Penyusutan",
                        menuItems: _penyusutanController.categoryDropdown,
                        code: "penyusutan-category")),
              ),
              Jarak(tinggi: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    child: Obx(() => SelectMonthReport(
                        defValue: _penyusutanController.thisMonth.value,
                        label: "Bulan",
                        menuItems: _penyusutanController.monthDropdown,
                        code: "penyusutan-list")),
                  ),
                  Spasi(lebar: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2 - 30,
                    child: Obx(() => SelectYearReport(
                        defValue: _penyusutanController.thisYear.value,
                        label: "Tahun",
                        menuItems: _penyusutanController.yearDropdown,
                        code: "penyusutan-list")),
                  ),
                ],
              ),
              Jarak(tinggi: 5),
              InputSearch(
                hint: "Cari Transaksi",
                textInputType: TextInputType.text,
                iconData: Icons.search,
                textEditingController: _textCari,
                obsecureText: false,
                code: "penyusutan-search",
              ),
              const Divider(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Obx(
                    () => _penyusutanController.loading.value
                        ? InputJurnalShimmer(tinggi: 160, jumlah: 10, pad: 0)
                        : _penyusutanController.penyusutanList.isEmpty
                            ? const Text('Tidak ada data')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount:
                                    _penyusutanController.penyusutanList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showSlideupView(
                                          context,
                                          _penyusutanController
                                              .penyusutanList[index]);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: AppColor.displayLine),
                                          color: AppColor.display),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text("Dibuat Pada",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    Tanggal.getOnlyDate(
                                                        _penyusutanController
                                                            .penyusutanList[
                                                                index]
                                                                ['created_at']
                                                            .toString()),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text("Kategori",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    _penyusutanController
                                                        .penyusutanList[index][
                                                            'kategori_penyusutan']
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text("Beban",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    _penyusutanController
                                                        .penyusutanList[index]
                                                            ['beban_penyusutan']
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text("Akumulasi",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    _penyusutanController
                                                        .penyusutanList[index][
                                                            'akumulasi_penyusutan']
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text("Nama Asset",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    _penyusutanController
                                                        .penyusutanList[index]
                                                            ['name']
                                                        .toString(),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text("Nilai Awal",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    Ribuan.formatAngka(
                                                        _penyusutanController
                                                            .penyusutanList[
                                                                index][
                                                                'initial_value']
                                                            .toString()),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text(
                                                    "Umur Manfaat",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    _penyusutanController
                                                            .penyusutanList[
                                                                index]
                                                                ['useful_life']
                                                            .toString() +
                                                        ' Bulan',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          Jarak(tinggi: 2),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: const Text(
                                                    "Nilai Residu",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontSetting.semi,
                                                        color: AppColor
                                                            .mainColor)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    Ribuan.formatAngka(
                                                        _penyusutanController
                                                            .penyusutanList[
                                                                index][
                                                                'residual_value']
                                                            .toString()),
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1 /
                                                  4,
                                              child: _penyusutanController
                                                              .penyusutanList[
                                                          index]['sync_status'] ==
                                                      1
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              AppColor.putih),
                                                      child: const Row(
                                                        children: [
                                                          Icon(
                                                            Icons.sync,
                                                            color:
                                                                AppColor.hijau,
                                                          ),
                                                          Text("Sync",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      FontSetting
                                                                          .bold))
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              AppColor.putih),
                                                      child: const Row(
                                                        children: [
                                                          Icon(
                                                            Icons.sync_disabled,
                                                            color:
                                                                AppColor.merah,
                                                          ),
                                                          Text("not Sync",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      FontSetting
                                                                          .bold))
                                                        ],
                                                      ),
                                                    )),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                  ),
                ),
              ),
              const Text("*Klik & Tahan Untuk Lihat Simulasi",
                  style: TextStyle(fontFamily: FontSetting.bold))
            ],
          )),
    );
  }
}

void showSlideupView(BuildContext context, Map<String, dynamic> dataList) {
  final PenyusutanController _hc = Get.put(PenyusutanController());
  showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SizedBox(
          child: GestureDetector(
            onTap: () {},
            child: Container(
                height: 320,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                // margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: AppColor.putih,
                    border: Border.all(color: AppColor.mainColor, width: 10.0)),
                child: Column(
                  children: [
                    Text(dataList['name'],
                        style: const TextStyle(
                            fontSize: 16, fontFamily: FontSetting.bold),
                        textAlign: TextAlign.center),
                    const Divider(),
                    Jarak(tinggi: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            dataList['sync_status'] == 1
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColor.inactive,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(Icons.sync,
                                        color: AppColor.putih))
                                : GestureDetector(
                                    onTap: () {
                                      showDialogSync(context, dataList['id']);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColor.hijau,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Icon(Icons.sync,
                                            color: AppColor.putih)),
                                  ),
                            Jarak(tinggi: 2),
                            const Text("Sync")
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialogDelete(context, dataList['id']);
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColor.merah,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: AppColor.putih)),
                            ),
                            Jarak(tinggi: 2),
                            const Text("Hapus")
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                                () => Simulasi(id: dataList['id'].toString()));
                          },
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(Icons.list,
                                      color: AppColor.putih)),
                              Jarak(tinggi: 2),
                              const Text("Simulasi")
                            ],
                          ),
                        )
                      ],
                    ),
                    Jarak(tinggi: 20),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Tutup"))
                  ],
                )),
          ),
        );
      });
}

showDialogDelete(BuildContext context, int penyusutanId) {
  Widget cancelButton = TextButton(
    child: const Text(
      "Tidak",
      style: TextStyle(fontFamily: 'PoppinsBold'),
    ),
    onPressed: () {
      Get.back();
    },
  );

  Widget continueButton = TextButton(
    child: const Text(
      "Hapus Data ?",
      style: TextStyle(fontFamily: 'PoppinsBold'),
    ),
    onPressed: () {
      PenyusutanController _hc = Get.put(PenyusutanController());
      _hc.penyusutanDelete(penyusutanId);
    },
  );

  AlertDialog alert = AlertDialog(
    title:
        const Text("Peringatan", style: TextStyle(fontFamily: 'PoppinsBold')),
    content: const Text('Anda Ingin menghapus data ini? ',
        style: TextStyle(fontFamily: 'Poppins')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showDialogSync(BuildContext context, int hutangId) {
  Widget cancelButton = TextButton(
    child: const Text(
      "Tidak",
      style: TextStyle(fontFamily: 'PoppinsBold'),
    ),
    onPressed: () {
      Get.back();
    },
  );

  Widget continueButton = TextButton(
    child: const Text(
      "Sync Data ?",
      style: TextStyle(fontFamily: 'PoppinsBold'),
    ),
    onPressed: () {
      PenyusutanController _hc = Get.put(PenyusutanController());
      _hc.penyusutanSync(hutangId);
    },
  );

  AlertDialog alert = AlertDialog(
    title:
        const Text("Peringatan", style: TextStyle(fontFamily: 'PoppinsBold')),
    content: const Text('Sinkronisasi data ini ke jurnal..? ',
        style: TextStyle(fontFamily: 'Poppins')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
