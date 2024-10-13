import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:randu_mobile/css/app_color.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/spasi.dart';
import 'package:randu_mobile/components/textview.dart';
import 'package:randu_mobile/css/font_setting.dart';
import 'package:randu_mobile/login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = Get.put(LoginController());
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.mainColor,
        body: Container(
          decoration: const BoxDecoration(color: AppColor.mainColor),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            shrinkWrap: true,
            children: [
              Jarak(tinggi: 10),
              const Text("LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontSetting.bold,
                    fontSize: 25,
                  )),
              Jarak(tinggi: MediaQuery.of(context).size.height - 620),
              Image.asset(
                "images/randu_acc.png",
                width: 100,
                height: 100,
              ),
              // Jarak(tinggi: MediaQuery.of(context).size.height - 620),
              Jarak(tinggi: 50),
              SizedBox(
                child: TextView(
                    hint: "Email",
                    textInputType: TextInputType.emailAddress,
                    iconData: Icons.email,
                    textEditingController: _emailText,
                    obsecureText: false),
              ),
              Jarak(tinggi: 10),
              SizedBox(
                child: TextView(
                    hint: "Password",
                    textInputType: TextInputType.text,
                    iconData: Icons.lock,
                    textEditingController: _passText,
                    obsecureText: true),
              ),
              Jarak(tinggi: 30),
              Obx(
                () => _loginController.loading.value
                    ? const SizedBox(
                        width: 30,
                        height: 40,
                        child: Center(child: CircularProgressIndicator()))
                    : InkWell(
                        onTap: () {
                          _loginController.login(
                              _emailText.text, _passText.text);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Submit",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: FontSetting.bold,
                                        color: AppColor.mainColor)),
                                Spasi(lebar: 10),
                                const Icon(Icons.arrow_forward,
                                    color: AppColor.mainColor),
                              ],
                            )),
                      ),
              ),
              Jarak(tinggi: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 3 / 4 - 40,
                    child: const Text("Belum Daftar? atau Lupa Password ?",
                        style: TextStyle(
                            fontFamily: FontSetting.reg,
                            fontSize: 14,
                            color: Colors.white)),
                  ),
                  GestureDetector(
                    onTap: () {
                      _loginController.launchURL();
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1 / 4 - 20,
                      child: const Text("Klik di Sini",
                          style: TextStyle(
                              fontFamily: FontSetting.reg,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),

              Jarak(tinggi: 30)
            ],
          ),
        ));
  }
}
