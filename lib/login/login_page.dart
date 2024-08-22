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
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Jarak(tinggi: 10),
              const Text("LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontSetting.bold,
                    fontSize: 30,
                  )),
              Jarak(tinggi: 60),
              Image.asset(
                "images/login.png",
                width: 160,
                height: 160,
              ),
              Jarak(tinggi: MediaQuery.of(context).size.height - 620),
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
              Jarak(tinggi: 20),
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
                            margin: const EdgeInsets.only(right: 180),
                            padding: const EdgeInsets.only(
                                left: 30, right: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Submit",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: FontSetting.reg,
                                        color: AppColor.mainColor)),
                                Spasi(lebar: 10),
                                const Icon(Icons.arrow_forward,
                                    color: AppColor.mainColor),
                              ],
                            )),
                      ),
              ),
              Jarak(tinggi: 20),
              const Text("Lupa Password ?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: FontSetting.reg,
                      fontSize: 16,
                      color: Colors.white)),
              Jarak(tinggi: 15),
              const Text("Perlu Bantuan Login/Aktivasi ?",
                  style: TextStyle(
                      fontFamily: FontSetting.reg,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      color: Colors.white)),
              Jarak(tinggi: 30)
            ],
          ),
        ));
  }
}
