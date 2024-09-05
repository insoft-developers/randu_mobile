import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/components/input_text.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/login/login_controller.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({Key? key}) : super(key: key);

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final LoginController _loginController = Get.put(LoginController());
  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: const Text("Lupa Password"),
      ),
      body: Center(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(children: [
              InputText(
                  hint: "Masukkan email anda",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _email,
                  obsecureText: false,
                  code: "lupa-password"),
              Jarak(tinggi: 20),
              Obx(
                () => _loginController.lupaLoading.value
                    ? const SizedBox(
                        child: Center(child: CircularProgressIndicator()))
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: AppColor.mainColor),
                            onPressed: () {
                              _loginController.lupaPassword(_email.text);
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: const Text("Submit"))),
                      ),
              )
            ])),
      ),
    );
  }
}
