import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final List<String> _id = ["0"];
  final List<String> _deleted = [""];
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
              _id.add(_kodeRekening.kodeList[i]['id'].toString());
              _deleted
                  .add(_kodeRekening.kodeList[i]['can_be_deleted'].toString());
            }
            _loading = false;
          })
        });
    super.initState();
  }

  _addItem() {
    setState(() {
      _akuns.add(TextEditingController());
      _id.add("0");
      _deleted.add("3");
    });
  }

  _itemDelete(int index) {
    setState(() {
      _akuns[index].clear();
      _akuns.removeAt(index);
      _id.removeAt(index);
      _deleted.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(widget.judul),
        actions: [
          GestureDetector(
            onTap: () {
              _addItem();
            },
            child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.add)),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => _kodeRekening.saveLoading.value
            ? Container(
                margin: const EdgeInsets.only(bottom: 70),
                child: const CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: FloatingActionButton(
                    backgroundColor: AppColor.mainColor,
                    child: const Icon(Icons.save),
                    onPressed: () {
                      List<String> inputAkuns = [];
                      for (var i = 0; i < _akuns.length; i++) {
                        inputAkuns.add(_akuns[i].text);
                        // ids.add(_id[i]);
                      }

                      _kodeRekening.save(
                          widget.akun, inputAkuns, _id, widget.akun);
                    }),
              ),
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
                          Stack(
                            children: [
                              InputText(
                                  hint: "",
                                  textInputType: TextInputType.text,
                                  textEditingController: _akuns[index],
                                  obsecureText: false,
                                  code: ""),
                              _deleted[index] == '3'
                                  ? Positioned(
                                      right: 10,
                                      top: 15,
                                      child: GestureDetector(
                                        onTap: () {
                                          _showAlertDialog(
                                              context,
                                              _id[index].toString(),
                                              _akuns[index].text,
                                              widget.akun.toString());
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.red),
                                          child: const Icon(Icons.delete,
                                              color: Colors.white, size: 15),
                                        ),
                                      ))
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ));
                }),
      ),
    );
  }

  void _showAlertDialog(
      BuildContext context, String id, String name, String widgetAkun) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Kode Rekening'),
          content: Text(
              "Apakah anda yakin ingin menghapus Kode Rekening [ $name ] ?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                KodeRekeningController _controller =
                    Get.put(KodeRekeningController());
                _controller.kodeRekeningDelete(id, widgetAkun);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
