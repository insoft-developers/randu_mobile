import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_transaksi.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/journal/tambah/jurnal_cepat/jurnal_cepat_controller.dart';

class JurnalCepat extends StatefulWidget {
  const JurnalCepat({Key? key}) : super(key: key);

  @override
  State<JurnalCepat> createState() => _JurnalCepatState();
}

class _JurnalCepatState extends State<JurnalCepat> {
  final JurnalCepatController _jurnalCepatController =
      Get.put(JurnalCepatController());
  final TextEditingController _tanggalText = TextEditingController();
  final TextEditingController _nominalText = TextEditingController();
  final TextEditingController _keteranganlText = TextEditingController();

  @override
  void initState() {
    var now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    _tanggalText.text = formattedDate;
    _jurnalCepatController.getTransactionList();
    super.initState();
  }

  _onDateChange() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), 
        firstDate: DateTime(2022)
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(
          pickedDate); 
      setState(() {
        _tanggalText.text =
            formattedDate; 
          
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Jurnal Cepat"),
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(4)),
                height: 50,
                child: TextField(
                  controller: _tanggalText,
                  decoration: const InputDecoration(
                    hintText: "",
                    label: Text(""),
                    border: InputBorder.none,
                    filled: false,
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  readOnly: true,
                  onTap: () {},
                ),
              ),
              Jarak(tinggi: 20),
              Obx(
                () => _jurnalCepatController.transactionLoading.value
                    ? TextShimmer(
                        lebar: MediaQuery.of(context).size.width, tinggi: 50)
                    : SelectTransaksi(
                        defValue: _jurnalCepatController.jenisTransaksi.value,
                        label: "Jenis Transaksi",
                        menuItems: _jurnalCepatController.transaksiDropdown),
              ),
              Jarak(tinggi: 20),
              Obx(
                () => _jurnalCepatController.loadingTerimaDari.value
                    ? TextShimmer(
                        lebar: MediaQuery.of(context).size.width, tinggi: 50)
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownSearch<String>(
                          showSearchBox: true,
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: _jurnalCepatController.accountDropdown,
                          dropdownSearchDecoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text("Pilih diterima dari")),
                          onChanged: (value) {
                            _jurnalCepatController.onchangeReceiveFrom(
                                _jurnalCepatController.accountDropdown
                                    .indexOf(value!));
                          },
                          selectedItem: "",
                        ),
                      ),
              ),
              Jarak(tinggi: 20),
              Obx(
                () => _jurnalCepatController.loadingTerimaDari.value
                    ? TextShimmer(
                        lebar: MediaQuery.of(context).size.width, tinggi: 50)
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownSearch<String>(
                          showSearchBox: true,
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: _jurnalCepatController.saveDropdown,
                          dropdownSearchDecoration: const InputDecoration(
                              border: InputBorder.none,
                              label: Text("Pilih simpan ke")),
                          onChanged: (value) {
                            _jurnalCepatController.onchangeSaveTo(
                                _jurnalCepatController.saveDropdown
                                    .indexOf(value!));
                          },
                          selectedItem: "",
                        ),
                      ),
              ),
              Jarak(tinggi: 20),
              InputText(
                  hint: "Nama Transaksi",
                  textInputType: TextInputType.text,
                  textEditingController: _keteranganlText,
                  obsecureText: false,
                  code: ""),
              Jarak(tinggi: 20),
              InputText(
                  hint: "Nominal",
                  textInputType: TextInputType.number,
                  textEditingController: _nominalText,
                  obsecureText: false,
                  code: "journal-nominal"),
              Jarak(tinggi: 5),
              Obx(() => Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                      _jurnalCepatController.nominalRibuan.value.toString(),
                      style: const TextStyle(
                          fontFamily: FontSetting.reg, color: Colors.red)))),
              Jarak(tinggi: 30),
              Obx(
                () => _jurnalCepatController.saveLoading.value
                    ? const SizedBox(
                        child: Center(child: CircularProgressIndicator()))
                    : SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppColor.mainColor),
                            onPressed: () {
                              _jurnalCepatController.saveQuickJournal(
                                  _tanggalText.text,
                                  _keteranganlText.text,
                                  _nominalText.text.isEmpty
                                      ? 0
                                      : int.parse(_nominalText.text));
                            },
                            child: const Text("Simpan",
                                style: TextStyle(
                                    fontFamily: 'RubikBold', fontSize: 18)))),
              ),
              Jarak(tinggi: 50),
            ],
          ),
        ));
  }
}
