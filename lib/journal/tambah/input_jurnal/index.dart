import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/color/app_color.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';

class InputJurnal extends StatefulWidget {
  const InputJurnal({Key? key}) : super(key: key);

  @override
  State<InputJurnal> createState() => _InputJurnalState();
}

class _InputJurnalState extends State<InputJurnal> {
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _transName = TextEditingController();
  final List<TextEditingController> _akuns = [TextEditingController()];
  final List<TextEditingController> _debits = [TextEditingController()];
  final List<TextEditingController> _credits = [TextEditingController()];

  _addItem() {
    setState(() {
     
      _akuns.add(TextEditingController());
      _debits.add(TextEditingController());
      _credits.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          actions: [
            GestureDetector(
              onTap: () {
                _addItem();
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
          ],
          title: const Text("Input Jurnal"),
        ),
        body: Column(
          children: [
             Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top:10, left: 10, right:10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border:Border.all(color: Colors.orange),
                color: Colors.amber[100]),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width:MediaQuery.of(context).size.width * 1/3 - 10,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(4)),
                        height: 50,
                                  child: TextField(
                          controller: _tanggal,
                          decoration: const InputDecoration(
                                  hintText: "Tanggal",
                                  border: InputBorder.none,
                                  filled: false,
                                  
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
                                _tanggal.text =
                                    formattedDate; 
                                  
                              });
                            } else {
                              print("Date is not selected");
                            }
                        },
                      ),
                    ),
                    SizedBox(
                        width:MediaQuery.of(context).size.width * 2/3 - 40,
                      child: InputText(hint: "Nama Transaksi", textInputType: TextInputType.text, textEditingController: _transName, obsecureText: false, code: "")),
                      
                  ],
                ),
             ),
            Jarak(tinggi: 2),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: _debits.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: AppColor.mainColor, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: InputText(
                                    hint: "Pilih akun",
                                    textInputType: TextInputType.text,
                                    textEditingController: _akuns[index],
                                    obsecureText: false,
                                    code: "")),
                            Jarak(tinggi: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 1 / 2 -
                                        25,
                                    child: InputText(
                                        hint: "Debit",
                                        textInputType: TextInputType.number,
                                        textEditingController: _debits[index],
                                        obsecureText: false,
                                        code: "")),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 1 / 2 -
                                        25,
                                    child: InputText(
                                        hint: "Kredit",
                                        textInputType: TextInputType.number,
                                        textEditingController: _credits[index],
                                        obsecureText: false,
                                        code: "")),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
