import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/homepage/shimmer/input_jurnal_shimmer.dart';
import 'package:randu_mobile/journal/edit/jurnal_edit_controller.dart';
import 'package:randu_mobile/utils/ribuan.dart';

// ignore: must_be_immutable
class JournalEdit extends StatefulWidget {
  int id;
  JournalEdit({Key? key, required this.id}) : super(key: key);

  @override
  State<JournalEdit> createState() => _JournalEditState();
}

class _JournalEditState extends State<JournalEdit> {
  final JournalEditController _journalEditController =
      Get.put(JournalEditController());
  final TextEditingController _tanggal = TextEditingController();
  final TextEditingController _transName = TextEditingController();
  final List<TextEditingController> _debits = [TextEditingController()];
  final List<TextEditingController> _credits = [TextEditingController()];
  final List<String> _akuns = [""];
  final List<String> _selectedAkuns = [""];
  final List<String> _debitRibuan = [""];
  final List<String> _creditRibuan = [""];
  final List<bool> _debitReadonly = [false];
  final List<bool> _creditReadonly = [false];
  String totalDebit = "0";
  String totalCredit = "0";

  @override
  void initState() {
    
    String formattedDate = "";
    _itemDelete(0);
    _journalEditController.getDataJournal(widget.id.toString()).then((value) {
      
      setState(() {
        formattedDate = _journalEditController.journalDate.value;
         _tanggal.text = formattedDate;
         _transName.text = _journalEditController.journal['transaction_name'];

         for(var i=0; i < _journalEditController.journalList.length; i++) {
            _journalEditController.getAccountSelect().then((value){
                 _initItem(i);
            });
           
         }
        
        
      });
      
    }); 
   
    
    super.initState();
  }

  _onSubmit() {
    List<String> _debetText = [];
    List<String> _creditText = [];

    for (var i = 0; i < _debits.length; i++) {

      _debetText.add(_debits[i].text.isEmpty ? "0" : _debits[i].text);
      _creditText.add(_credits[i].text.isEmpty ? "0" : _credits[i].text);
    }

    _journalEditController.updateMultipleJournal(widget.id, _tanggal.text, _transName.text,
        _selectedAkuns, _debetText, _creditText);
  }

  _initItem(int k) {
    setState(() {
      _debitReadonly.add(false);
      _creditReadonly.add(false);
      _akuns.add(_journalEditController.journalList[k]['asset_data_name'].toString()+" ( "+_journalEditController.journalList[k]['group'].toString()+" )");
      _debitRibuan.add(Ribuan.convertToIdr( _journalEditController.journalList[k]['debet'], 0));
      _creditRibuan.add(Ribuan.convertToIdr( _journalEditController.journalList[k]['credit'], 0));
      _debits.add(TextEditingController(text: _journalEditController.journalList[k]['debet'].toString()));
      _credits.add(TextEditingController(text: _journalEditController.journalList[k]['credit'].toString()));
      _selectedAkuns.add(_journalEditController.journalList[k]['asset_data_id'].toString()+'_'+_journalEditController.journalList[k]['account_code_id'].toString());
    });
     _countTotal();
  }
  
  _addItem() {
    setState(() {
      _debitReadonly.add(false);
      _creditReadonly.add(false);
      _akuns.add("");
      _debitRibuan.add("");
      _creditRibuan.add("");
      _debits.add(TextEditingController());
      _credits.add(TextEditingController());
      _selectedAkuns.add("");
    });
  }

  _onDateChange() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), 
        firstDate: DateTime(2022)
        lastDate: DateTime(2101));
      if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);   
          setState(() {
            _tanggal.text =
                formattedDate; 
          });
      } 
  }

  _countTotal() {
     int tDebit = 0;
     int tCredit = 0;

     for(var i=0; i< _debits.length ; i++) {
      int itemDebit = _debits[i].text.isEmpty ? 0 : int.parse(_debits[i].text);
      tDebit = tDebit + itemDebit;

      int itemCredit = _credits[i].text.isEmpty ? 0 : int.parse(_credits[i].text);
      tCredit = tCredit + itemCredit;

      totalDebit = Ribuan.convertToIdr(tDebit, 0);
      totalCredit = Ribuan.convertToIdr(tCredit, 0);

     }
  }

  _itemDelete(int index) {
    setState(() {
      _akuns.removeAt(index);
      _debitRibuan.removeAt(index);
      _creditRibuan.removeAt(index);
      _selectedAkuns.removeAt(index);
      _debits[index].clear();
      _debits.removeAt(index);
      _credits[index].clear();
      _credits.removeAt(index);
      _debitReadonly.removeAt(index);
      _creditReadonly.removeAt(index);
      _countTotal();
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
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
          ],
          title: const Text("Edit Jurnal"),
        ),
        floatingActionButton: Obx(
          () => _journalEditController.saveLoading.value
              ? Container(
                  margin: const EdgeInsets.only(bottom: 70),
                  child: const CircularProgressIndicator())
              : Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: FloatingActionButton(
                      backgroundColor: AppColor.mainColor,
                      child: const Icon(Icons.save),
                      onPressed: () {
                        _onSubmit();
                      }),
                ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange),
                  color: Colors.amber[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1 / 3 - 10,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      onTap: ()  {
                        _onDateChange();
                      },
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3 - 40,
                      child: InputText(
                          hint: "Nama Transaksi",
                          textInputType: TextInputType.text,
                          textEditingController: _transName,
                          obsecureText: false,
                          code: "")),
                ],
              ),
             
            ),
            Jarak(tinggi: 5),
             Container(

               margin: const EdgeInsets.symmetric(horizontal: 10),
               padding: const EdgeInsets.all(10),
               decoration:BoxDecoration(
                color:AppColor.mainColor,
                borderRadius:BorderRadius.circular(4),
               ),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text("(D) : ${totalDebit}", style:const TextStyle(fontFamily:FontSetting.bold, color:Colors.white)),
                     Text("(K) : ${totalCredit}", style:const TextStyle(fontFamily:FontSetting.bold, color:Colors.white))
                  ]
                ),
             ),
            Jarak(tinggi: 2),
            Obx(
              () => _journalEditController.loading.value
                  ? Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: InputJurnalShimmer(tinggi: 150, jumlah: 2, pad:10))
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10,5,10,10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: _debits.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.display,
                                      border: Border.all(
                                          color: AppColor.displayLine,width: 1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: DropdownSearch<String>(
                                            showSearchBox: true,
                                            mode: Mode.DIALOG,
                                            showSelectedItems: true,
                                            items: _journalEditController
                                                .accountDropdown,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
                                                    border: InputBorder.none,
                                                    label: Text("Pilih akun")),
                                            onChanged: (value) {
                                              setState(() {
                                                _akuns[index] =
                                                    value.toString();
                                                int indexSelected =
                                                    _journalEditController
                                                        .accountDropdown
                                                        .indexOf(value!);
                                                Map<String, dynamic>
                                                    _selectedAccount =
                                                    _journalEditController
                                                            .accountSelect[
                                                        indexSelected];
                                                String _accountId =
                                                    "${_selectedAccount['id']}_${_selectedAccount['account_code_id']}";
                                                _selectedAkuns[index] =
                                                    _accountId;
                                              });
                                            },
                                            selectedItem: _akuns[index],
                                          ),
                                        ),
                                        Jarak(tinggi: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                1/2 - 25,
                                                    child: Container(
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
                                                          BoxShadow(offset: Offset(0, 1), blurRadius: 50, color: Colors.white),
                                                        ],
                                                      ),
                                                      child: TextField(
                                                        readOnly: _debitReadonly[index],
                                                        controller: _debits[index],
                                                        keyboardType: TextInputType.number,
                                                        textInputAction: TextInputAction.next,
                                                        decoration: const InputDecoration(
                                                          hintText: "Debet",
                                                          hintStyle:  TextStyle(
                                                              fontFamily: FontSetting.reg, fontSize: 15, color: Colors.grey),
                                                          enabledBorder: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                        ),
                                                        onChanged:(value) {
                                                            setState(() {
                                                              _debitRibuan[index] = value.isEmpty ? "" : Ribuan.convertToIdr(int.parse(value),0);
                                                              _creditReadonly[index] = value.isEmpty ? false : true;
                                                              _countTotal();
                                                            });
                                                        }
                                                      ),
                                                    )),
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5, top: 5),
                                                    child:  Text(_debitRibuan[index],
                                                        style:  const TextStyle(
                                                            fontFamily: FontSetting.reg,
                                                            color: Colors.red)))
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment :CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1 /
                                                            2 -
                                                        25,
                                                    child: Container(
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
                                                          BoxShadow(offset: Offset(0, 1), blurRadius: 50, color: Colors.white),
                                                        ],
                                                      ),
                                                      child: TextField(
                                                        controller: _credits[index],
                                                        readOnly: _creditReadonly[index],
                                                        keyboardType: TextInputType.number,
                                                        textInputAction: TextInputAction.next,
                                                        decoration: const InputDecoration(
                                                          hintText: "Kredit",
                                                          hintStyle:  TextStyle(
                                                              fontFamily: FontSetting.reg, fontSize: 15, color: Colors.grey),
                                                          enabledBorder: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                        ),
                                                        onChanged:(value) {
                                                            setState(() {
                                                              _creditRibuan[index] = value.isEmpty ? "" : Ribuan.convertToIdr(int.parse(value),0);
                                                              _debitReadonly[index] = value.isEmpty ? false : true;
                                                               _countTotal();
                                                            });
                                                        }
                                                      ),
                                                    )),
                                                         Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5, top: 5),
                                                    child:  Text(_creditRibuan[index],
                                                        style:  const TextStyle(
                                                            fontFamily: FontSetting.reg,
                                                            color: Colors.red)))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  index != 0
                                      ? Positioned(
                                          right: 5,
                                          top: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _itemDelete(index);
                                              });
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 3),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 20)),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              );
                            }),
                      ),
                    ),
            ),
          ],
        ));
  }
}
