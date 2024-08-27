import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/textarea.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/utang/hutang/pembayaran/debt_payment_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';

class DebtPayment extends StatefulWidget {
  Map<String, dynamic> dataList;
  DebtPayment({Key? key, required this.dataList}) : super(key: key);

  @override
  State<DebtPayment> createState() => _DebtPaymentState();
}

class _DebtPaymentState extends State<DebtPayment> {
  final DebtPaymentController _dpc = Get.put(DebtPaymentController());
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _nominal = TextEditingController();
  final TextEditingController _keterangan = TextEditingController();

  @override
  void initState() {
    var now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    _tanggal.text = formattedDate;
    super.initState();
    print(widget.dataList);
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
        _tanggal.text =
            formattedDate; 
          
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Bayar Utang "),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: ListView(
            children: [
              Text(widget.dataList['name'].toString(),
                  style: const TextStyle(
                      color: AppColor.merah,
                      fontSize: 14, fontFamily: FontSetting.semi)),
                      const Divider(),
              Text(
                  "Rp. " +
                      Ribuan.formatAngka(widget.dataList['balance'].toString()),
                  style: const TextStyle(
                      color: AppColor.hijau,
                      fontSize: 22,
                      fontFamily: FontSetting.bold)),
              const Divider(),
              Jarak(tinggi: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(4)),
                height: 50,
                child: TextField(
                  controller: _tanggal,
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
            InputText(
                hint: "Nominal",
                textInputType: TextInputType.number,
                textEditingController: _nominal,
                obsecureText: false,
                code: "pembayaran-hutang"),
            Jarak(tinggi: 5),
            Obx(() => Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(_dpc.nominalRibuan.value.toString(),
                    style: const TextStyle(
                        fontFamily: FontSetting.reg, color: Colors.red)))),
            Jarak(tinggi: 20),
            TextArea(hint: "Keterangan", textEditingController: _keterangan, maxline: 6),
            Jarak(tinggi: 30),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(primary: AppColor.mainColor),
              onPressed: () {
                _dpc.savePayment(widget.dataList['id'], widget.dataList['debt_from'].toString(), widget.dataList['save_to'].toString(), _nominal.text.toString().isEmpty ?0 : int.parse(_nominal.text), 0, _keterangan.text);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text("SUBMIT")))
            ],
          ),
        ));
  }
}
