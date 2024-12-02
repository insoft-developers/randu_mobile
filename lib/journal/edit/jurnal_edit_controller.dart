import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:randu_mobile/api/network.dart';
import 'package:randu_mobile/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JournalEditController extends GetxController {
  var loading = false.obs;
  var accountSelect = List.empty().obs;
  var saveLoading = false.obs;
  var journal = <String, dynamic>{}.obs;
  var journalList = List.empty().obs;
  var journalLoading = false.obs;
  var journalDate = "".obs;

  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;
  String? _imagePath;
  String? get imagePath => _imagePath;
  final _picker = ImagePicker();

  Future<void> pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    update();
  }

  Future<void> resetPicker() async {
    _pickedFile = null;
    update();
  }

  Future<bool> upload(String ids) async {
    update();
    bool success = false;
    http.StreamedResponse response = await updateImage(_pickedFile, ids);

    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      success = true;
      _imagePath = message;
      print(message);
    } else {}
    update();
    Get.back();
    return success;
  }

  Future<http.StreamedResponse> updateImage(
      PickedFile? data, String ids) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse(Constant.UPLOAD_IMAGE_URL + '/journal/journal-upload'));

    if (GetPlatform.isMobile && data != null) {
      File _file = File(data.path);
      request.files.add(http.MultipartFile(
          'image', _file.readAsBytes().asStream(), _file.lengthSync(),
          filename: _file.path.split('/').last));
    }

    Map<String, String> _fields = {};
    _fields.addAll(<String, String>{'ids': ids});
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future getDataJournal(String id) async {
    journalLoading(true);
    var data = {"id": id};
    var res = await Network().post(data, '/journal/journal-edit');
    var body = jsonDecode(res.body);
    if (body['success']) {
      journalLoading(false);
      journal.value = body['data']['jurnal'];
      journalList.value = body['data']['list'];
      journalDate.value = body['data']['tanggal'];
      print(body);
    }
  }

  Future getAccountSelect() async {
    loading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {"userid": userId};
      var res = await Network().post(data, '/journal/get-account-select');
      var body = jsonDecode(res.body);
      if (body['success']) {
        accountSelect.value = body['data'];
        loading(false);
      }
    }
  }

  List<String> get accountDropdown {
    List<String> items = [];
    for (var i = 0; i < accountSelect.length; i++) {
      items.add(accountSelect[i]['name'].toString() +
          ' ( ' +
          accountSelect[i]['group'].toString() +
          ' )');
      // items.add(accountSelect[i]['name'].toString());
    }

    return items;
  }

  void updateMultipleJournal(
      int transactionId,
      String transactionDate,
      String transactionName,
      List<String> akuns,
      List<String> debet,
      List<String> credit,
      List<String> catatans,
      String description) async {
    saveLoading(true);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    if (user != null) {
      var userId = user['id'];
      var data = {
        "transaction_id": transactionId,
        "userid": userId,
        "transaction_date": transactionDate,
        "transaction_name": transactionName,
        "akun": akuns,
        "debit": debet,
        "kredit": credit,
        "catatan": catatans,
        "description": description
      };

      var res = await Network().post(data, '/journal/update-multiple-journal');
      var body = jsonDecode(res.body);
      if (body['success']) {
        saveLoading(false);
        if (_pickedFile != null) {
          upload(transactionId.toString());
        } else {
          Get.back();
        }
      } else {
        showError(body['message'].toString());
        saveLoading(false);
      }
    }
  }

  void showError(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Html(
        data: n,
        // defaultTextStyle: const TextStyle(
        //     color: Colors.white, fontFamily: 'Rubik', fontSize: 14),
      ),
    ));
  }

  void showSuccess(String n) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: Colors.green[900],
      content: Html(
        data: n,
        // defaultTextStyle: const TextStyle(
        //     color: Colors.white, fontFamily: 'Rubik', fontSize: 14),
      ),
    ));
  }
}
