import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_mont_report.dart';
import 'package:randu_mobile/components/textarea.dart';
import 'package:randu_mobile/css/app_color.dart';
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
  final TextEditingController _tKeterangan = TextEditingController();

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
                textInputType: TextInputType.text,
                textEditingController: _tName,
                obsecureText: false,
                code: "nominal-hutang"),
            Jarak(tinggi: 20),
            TextArea(
                hint: "Keterangan",
                textEditingController: _tKeterangan,
                maxline: 10),
            Jarak(tinggi: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: AppColor.mainColor),
                onPressed: () {},
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: const Text("SUBMIT"))),
            Jarak(tinggi: 20)
          ],
        ),
      ),
    );
  }
}
