import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_readonly.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/pengaturan/kode_rekening/kode_rekening_controller.dart';

// ignore: must_be_immutable
class KodeRekeningDetail extends StatefulWidget {
  int akun;
  String judul;
  KodeRekeningDetail({Key? key, required this.akun, required this.judul})
      : super(key: key);

  @override
  State<KodeRekeningDetail> createState() => _KodeRekeningDetailState();
}

class _KodeRekeningDetailState extends State<KodeRekeningDetail> {
  final KodeRekeningController _kodeRekening =
      Get.put(KodeRekeningController());

  final List<TextEditingController> _akuns = [TextEditingController()];
  bool _loading = false;

  @override
  void initState() {
    _loading = true;
    _kodeRekening.getDetail(widget.akun).then((value) => {
          setState(() {
            _itemDelete(0);
            for (var i = 0; i < _kodeRekening.kodeList.length; i++) {
              _akuns.add(TextEditingController());
              _akuns[i].text = _kodeRekening.kodeList[i]['name'].toString();
            }
            _loading = false;
          })
        });
    super.initState();
  }

  _itemDelete(int index) {
    setState(() {
      _akuns.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(widget.judul),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: _loading
            ? InputJurnalShimmer(tinggi: 60, jumlah: 10, pad: 0)
            : ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: _akuns.length,
                itemBuilder: (coantext, index) {
                  return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //     _kodeRekening.kodeList[index]['name'].toString()),
                          _kodeRekening.kodeList[index]['can_be_deleted'] <= 1
                              ? InputReadOnly(
                                  hint: "",
                                  textInputType: TextInputType.text,
                                  textEditingController: _akuns[index],
                                  code: "")
                              : InputText(
                                  hint: "",
                                  textInputType: TextInputType.text,
                                  textEditingController: _akuns[index],
                                  obsecureText: false,
                                  code: ""),
                        ],
                      ));
                }),
      ),
    );
  }
}
