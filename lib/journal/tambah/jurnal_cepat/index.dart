import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/components/inputdate.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/select/select_transaksi.dart';
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

  @override
  void initState() {
    var now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(
                      now); 
    _tanggalText.text = formattedDate;
    _jurnalCepatController.getTransactionList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onTap: () async {
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
                } else {
                  print("Date is not selected");
                }
              },
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
          )
        ],
      ),
    ));
  }
}
