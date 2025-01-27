import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_readonly.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/textarea.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/penyusutan/penyusutan_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';

class Kurangi extends StatefulWidget {
  Map<String, dynamic> dataList;
  Kurangi({Key? key, required this.dataList}) : super(key: key);

  @override
  State<Kurangi> createState() => _KurangiState();
}

class _KurangiState extends State<Kurangi> {
  final PenyusutanController _controller = Get.put(PenyusutanController());
  final TextEditingController _note = TextEditingController();
  final TextEditingController _namaAsset = TextEditingController();
  final TextEditingController _jumlahAsset = TextEditingController();
  final TextEditingController _hargaAsset = TextEditingController();
  final TextEditingController _lostAsset = TextEditingController();
  final TextEditingController _nilaiAsset = TextEditingController();

  String hargatext = "0";
  String assettext = "0";

  @override
  void initState() {
    _namaAsset.text = widget.dataList['name'].toString();
    _jumlahAsset.text = widget.dataList['quantity'].toString();
    _hargaAsset.text = widget.dataList['buying_price'].toString();
    hargatext = Ribuan.formatAngka(widget.dataList['buying_price'].toString());
    super.initState();

    print(widget.dataList);
  }

  _hitung(jumlah) {
    if (jumlah != '' && jumlah != null) {
      var angka = int.parse(jumlah);
      var jumlahHilang =
          angka * int.parse(widget.dataList['buying_price'].toString());
      setState(() {
        _nilaiAsset.text = jumlahHilang.toString();
        assettext = Ribuan.formatAngka(jumlahHilang.toString());
      });
    } else {
      setState(() {
        _nilaiAsset.text = '';
        assettext = "0";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text("Pengurangan Aset"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              InputReadOnly(
                  hint: "Nama Aset",
                  textInputType: TextInputType.text,
                  textEditingController: _namaAsset,
                  code: "nama-asset"),
              Jarak(tinggi: 20),
              InputReadOnly(
                  hint: "Jumlah Aset",
                  textInputType: TextInputType.text,
                  textEditingController: _jumlahAsset,
                  code: "jumlah-asset"),
              Jarak(tinggi: 20),
              InputReadOnly(
                  hint: "Harga per Unit",
                  textInputType: TextInputType.text,
                  textEditingController: _hargaAsset,
                  code: "harga-asset"),
              Jarak(tinggi: 5),
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  hargatext,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
              Jarak(tinggi: 20),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 50,
                        color: Colors.white),
                  ],
                ),
                child: TextField(
                  controller: _lostAsset,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Jumlah Aset Berkurang/Hilang",
                    hintStyle: TextStyle(
                        fontFamily: 'Rubik', fontSize: 15, color: Colors.grey),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _hitung(value);
                  },
                ),
              ),
              Jarak(tinggi: 20),
              InputReadOnly(
                  hint: "Nilai Aset Berkurang/Hilang",
                  textInputType: TextInputType.text,
                  textEditingController: _nilaiAsset,
                  code: "nilai-asset"),
              Jarak(tinggi: 5),
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  assettext,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
              Jarak(tinggi: 20),
              TextArea(
                  hint: "Keterangan", textEditingController: _note, maxline: 6),
              Jarak(tinggi: 30),
              Obx(
                () => _controller.kurangiLoading.value
                    ? const SizedBox(
                        child: Center(child: CircularProgressIndicator()))
                    : ElevatedButton(
                        onPressed: () {
                          _controller.lostAssetStore(
                              widget.dataList['id'].toString(),
                              _namaAsset.text,
                              _nilaiAsset.text,
                              _lostAsset.text,
                              _note.text);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.mainColor),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text("Submit"))),
              ),
              Jarak(tinggi: 30)
            ],
          ),
        ));
  }
}
