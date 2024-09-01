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

import 'package:randu_mobile/utang/piutang/history/index.dart';
import 'package:randu_mobile/utang/piutang/pembayaran/index.dart';
import 'package:randu_mobile/utang/piutang/piutang_controller.dart';
import 'package:randu_mobile/utang/piutang/tambah/index.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:randu_mobile/utils/tanggal.dart';

class Piutang extends StatefulWidget {
  const Piutang({Key? key}) : super(key: key);

  @override
  State<Piutang> createState() => _PiutangState();
}

class _PiutangState extends State<Piutang> {
  final PiutangController _piutangController = Get.put(PiutangController());
  final TextEditingController _textCari = TextEditingController();

  @override
  void initState() {
    _piutangController.getPiutangData("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Daftar Piutang"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const TambahPiutang())!
                  .then((value) => _piutangController.getPiutangData(""));
            },
            child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.add)),
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Obx(() => SelectMonthReport(
                    defValue: _piutangController.selectedCategory.value,
                    label: "Kategori",
                    menuItems: _piutangController.categoryDropdown,
                    code: "piutang-category")),
              ),
              Jarak(tinggi: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    child: Obx(() => SelectMonthReport(
                        defValue: _piutangController.thisMonth.value,
                        label: "Bulan",
                        menuItems: _piutangController.monthDropdown,
                        code: "piutang-list")),
                  ),
                  Spasi(lebar: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2 - 30,
                    child: Obx(() => SelectYearReport(
                        defValue: _piutangController.thisYear.value,
                        label: "Tahun",
                        menuItems: _piutangController.yearDropdown,
                        code: "piutang-list")),
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
                code: "piutang-search",
              ),
              const Divider(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Obx(
                    () => _piutangController.loading.value
                        ? InputJurnalShimmer(tinggi: 160, jumlah: 10, pad: 0)
                        : _piutangController.piutangList.isEmpty
                            ? const Text('Tidak ada data')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount:
                                    _piutangController.piutangList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showSlideupView(
                                          context,
                                          _piutangController
                                              .piutangList[index]);
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
                                                        2 /
                                                        3 -
                                                    42,
                                                child: Text(
                                                    _piutangController
                                                        .piutangList[index]
                                                            ['name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.bold,
                                                        color:
                                                            AppColor.mainColor,
                                                        fontSize: 16)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1 /
                                                    3,
                                                child: Text(
                                                    Tanggal.getOnlyDate(
                                                        _piutangController
                                                            .piutangList[index]
                                                                ['created_at']
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
                                                .width,
                                            child: Text(
                                                _piutangController
                                                    .piutangList[index]['type']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily:
                                                        FontSetting.reg)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                                _piutangController
                                                    .piutangList[index]
                                                        ['sub_type']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily:
                                                        FontSetting.reg)),
                                          ),
                                          const Divider(),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        1 /
                                                        2 -
                                                    20,
                                                child: Text(
                                                    _piutangController
                                                        .piutangList[index]
                                                            ['from']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        1 /
                                                        2 -
                                                    22,
                                                child: Text(
                                                    _piutangController
                                                        .piutangList[index]
                                                            ['save']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            FontSetting.reg)),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1 /
                                                      4,
                                                  child: _piutangController
                                                                      .piutangList[
                                                                  index]
                                                              ['sync_status'] ==
                                                          1
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: AppColor
                                                                  .putih),
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons.sync,
                                                                color: AppColor
                                                                    .hijau,
                                                              ),
                                                              Text("Sync",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          FontSetting
                                                                              .bold))
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: AppColor
                                                                  .putih),
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .sync_disabled,
                                                                color: AppColor
                                                                    .merah,
                                                              ),
                                                              Text("not Sync",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          FontSetting
                                                                              .bold))
                                                            ],
                                                          ),
                                                        )),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                3 /
                                                                4 -
                                                            60,
                                                    child: Text(
                                                        "Rp. " +
                                                            Ribuan.formatAngka(
                                                                _piutangController
                                                                    .piutangList[
                                                                        index][
                                                                        'amount']
                                                                    .toString()),
                                                        textAlign: TextAlign
                                                            .end,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                FontSetting
                                                                    .bold,
                                                            color:
                                                                AppColor.hijau,
                                                            fontSize: 20)),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                3 /
                                                                4 -
                                                            60,
                                                    child: Text(
                                                        _piutangController
                                                                        .piutangList[index]
                                                                    [
                                                                    'balance'] <=
                                                                0
                                                            ? "LUNAS"
                                                            : "Sisa   " +
                                                                Ribuan.formatAngka(_piutangController
                                                                    .piutangList[
                                                                        index]
                                                                        [
                                                                        'balance']
                                                                    .toString()),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                FontSetting.bold,
                                                            color: AppColor.merah,
                                                            fontSize: 14)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

void showSlideupView(BuildContext context, Map<String, dynamic> dataList) {
  final PiutangController _hc = Get.put(PiutangController());
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
                    Text(
                        "Jumlah : " +
                            Ribuan.formatAngka(dataList['amount'].toString()),
                        style: const TextStyle(
                            color: AppColor.hijau,
                            fontSize: 24,
                            fontFamily: FontSetting.bold),
                        textAlign: TextAlign.center),
                    Text(
                        "Sisa : " +
                            Ribuan.formatAngka(dataList['balance'].toString()),
                        style: const TextStyle(
                            color: AppColor.merah,
                            fontSize: 20,
                            fontFamily: FontSetting.bold),
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
                        dataList['balance'] <= 0
                            ? Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColor.inactive,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Icon(
                                          Icons.check_circle_outline,
                                          color: AppColor.putih)),
                                  Jarak(tinggi: 2),
                                  const Text("Lunas")
                                ],
                              )
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => PiutangPayment(
                                              dataList: dataList))!
                                          .then((value) =>
                                              _hc.getPiutangData(""));
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColor.kuning,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Icon(Icons.attach_money,
                                            color: AppColor.putih)),
                                  ),
                                  Jarak(tinggi: 2),
                                  const Text("Bayar")
                                ],
                              ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                PiutangHistory(id: dataList['id'].toString()));
                          },
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColor.mainColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(Icons.history,
                                      color: AppColor.putih)),
                              Jarak(tinggi: 2),
                              const Text("History")
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

showDialogDelete(BuildContext context, int piutangId) {
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
      PiutangController _hc = Get.put(PiutangController());
      _hc.onPiutangDelete(piutangId);
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

showDialogSync(BuildContext context, int piutangId) {
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
      PiutangController _hc = Get.put(PiutangController());
      _hc.onPiutangSync(piutangId);
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
