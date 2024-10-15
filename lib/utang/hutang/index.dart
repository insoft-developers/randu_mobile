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
import 'package:randu_mobile/utang/hutang/history/history.dart';
import 'package:randu_mobile/utang/hutang/hutang_controller.dart';
import 'package:randu_mobile/utang/hutang/pembayaran/index.dart';
import 'package:randu_mobile/utang/hutang/tambah/index.dart';
import 'package:randu_mobile/utils/ribuan.dart';
import 'package:randu_mobile/utils/tanggal.dart';

class Hutang extends StatefulWidget {
  const Hutang({Key? key}) : super(key: key);

  @override
  State<Hutang> createState() => _HutangState();
}

class _HutangState extends State<Hutang> {
  final HutangController _hutangController = Get.put(HutangController());
  final TextEditingController _textCari = TextEditingController();

  @override
  void initState() {
    _hutangController.getHutangData("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Daftar Hutang"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const TambahHutang())!
                  .then((value) => _hutangController.getHutangData(""));
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
                    defValue: _hutangController.selectedCategory.value,
                    label: "Kategori",
                    menuItems: _hutangController.categoryDropdown,
                    code: "debt-category")),
              ),
              Jarak(tinggi: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2,
                    child: Obx(() => SelectMonthReport(
                        defValue: _hutangController.thisMonth.value,
                        label: "Bulan",
                        menuItems: _hutangController.monthDropdown,
                        code: "debt-list")),
                  ),
                  Spasi(lebar: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1 / 2 - 30,
                    child: Obx(() => SelectYearReport(
                        defValue: _hutangController.thisYear.value,
                        label: "Tahun",
                        menuItems: _hutangController.yearDropdown,
                        code: "debt-list")),
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
                code: "debt-search",
              ),
              const Divider(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Obx(
                    () => _hutangController.loading.value
                        ? InputJurnalShimmer(tinggi: 160, jumlah: 10, pad: 0)
                        : _hutangController.hutangList.isEmpty
                            ? const Text('Tidak ada data')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: _hutangController.hutangList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showSlideupView(context,
                                          _hutangController.hutangList[index]);
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
                                                    _hutangController
                                                        .hutangList[index]
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
                                                    _hutangController.hutangList[
                                                                    index]
                                                                ['date'] ==
                                                            null
                                                        ? ''
                                                        : _hutangController
                                                            .hutangList[index]
                                                                ['date']
                                                            .toString(),
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
                                                _hutangController
                                                    .hutangList[index]['type']
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
                                                _hutangController
                                                    .hutangList[index]
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
                                                    _hutangController
                                                        .hutangList[index]
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
                                                    _hutangController
                                                        .hutangList[index]
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
                                                  child: _hutangController
                                                                      .hutangList[
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
                                                                _hutangController
                                                                    .hutangList[
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
                                                        _hutangController
                                                                        .hutangList[index]
                                                                    [
                                                                    'balance'] <=
                                                                0
                                                            ? "LUNAS"
                                                            : "Sisa   " +
                                                                Ribuan.formatAngka(_hutangController
                                                                    .hutangList[
                                                                        index][
                                                                        'balance']
                                                                    .toString()),
                                                        textAlign: TextAlign
                                                            .end,
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
              ),
              const Text("*Klik & Tahan Untuk Bayar Utang",
                  style: TextStyle(fontFamily: FontSetting.bold))
            ],
          )),
    );
  }
}

void showSlideupView(BuildContext context, Map<String, dynamic> dataList) {
  final HutangController _hc = Get.put(HutangController());
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
                                      Get.to(() =>
                                              DebtPayment(dataList: dataList))!
                                          .then(
                                              (value) => _hc.getHutangData(""));
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
                                DebtHistory(id: dataList['id'].toString()));
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

showDialogDelete(BuildContext context, int hutangId) {
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
      HutangController _hc = Get.put(HutangController());
      _hc.onDebtDelete(hutangId);
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
      HutangController _hc = Get.put(HutangController());
      _hc.onDebtSync(hutangId);
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
