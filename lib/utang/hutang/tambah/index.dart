import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/textarea.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/text_shimmer.dart';
import 'package:randu_mobile/utang/hutang/tambah/tambah_hutang_controller.dart';

class TambahHutang extends StatefulWidget {
  const TambahHutang({Key? key}) : super(key: key);

  @override
  State<TambahHutang> createState() => _TambahHutangState();
}

class _TambahHutangState extends State<TambahHutang> {
  final TambahHutangController _thc = Get.put(TambahHutangController());
  final TextEditingController _tName = TextEditingController();
  final TextEditingController _tNominal = TextEditingController();
  final TextEditingController _tKeterangan = TextEditingController();
  final TextEditingController _tanggalText = TextEditingController();

  @override
  void initState() {
    var now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    _tanggalText.text = formattedDate;
    super.initState();
  }

  _onDateChange() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2101));
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate!);
    setState(() {
      _tanggalText.text = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Hutang Baru"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            Jarak(tinggi: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                onTap: () {
                  _onDateChange();
                },
              ),
            ),
            Jarak(tinggi: 20),
            Obx(() => SelectMonthReport(
                defValue: _thc.selectedCategory.value,
                label: "",
                menuItems: _thc.categoryDropdown,
                code: "tambah-hutang")),
            Jarak(tinggi: 20),
            Obx(() => _thc.loading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 50)
                : SelectMonthReport(
                    defValue: _thc.selectedSub.value,
                    label: "",
                    menuItems: _thc.subCategoryDropdown,
                    code: "debt-sub-category")),
            Jarak(tinggi: 20),
            InputText(
                hint: "Input Nama",
                textInputType: TextInputType.text,
                textEditingController: _tName,
                obsecureText: false,
                code: "tambah-hutang"),
            Jarak(tinggi: 20),
            Obx(() => _thc.debtFromLoading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 50)
                : SelectMonthReport(
                    defValue: _thc.selectedDebtFrom.value,
                    label: "",
                    menuItems: _thc.debtFromDropdown,
                    code: "debt-from")),
            Jarak(tinggi: 20),
            Obx(() => _thc.debtToLoading.value
                ? TextShimmer(
                    lebar: MediaQuery.of(context).size.width, tinggi: 50)
                : SelectMonthReport(
                    defValue: _thc.selectedDebtTo.value,
                    label: "",
                    menuItems: _thc.debtToDropdown,
                    code: "debt-to")),
            Jarak(tinggi: 20),
            InputText(
                hint: "Nominal",
                textInputType: TextInputType.number,
                textEditingController: _tNominal,
                obsecureText: false,
                code: "nominal-hutang"),
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
                        _thc.onDebtStore(
                            _tName.text,
                            _tNominal.text.toString().isEmpty
                                ? 0
                                : int.parse(_tNominal.text),
                            _tKeterangan.text,
                            _tanggalText.text);
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
