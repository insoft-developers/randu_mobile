import 'package:flutter/material.dart';
import 'package:randu_mobile/components/jarak.dart';
import 'package:randu_mobile/components/textview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: Row(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.all(20),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Jarak(tinggi: 40),
                      Text("LOGIN",
                          style: TextStyle(
                              fontFamily: "RubikBold",
                              fontSize: 30,
                              color: Colors.blue[900])),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: TextView(
                              hint: "Email",
                              textInputType: TextInputType.emailAddress,
                              iconData: Icons.email,
                              textEditingController: _emailText,
                              obsecureText: false),
                        ),
                      ),
                      Jarak(tinggi: 10),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: TextView(
                            hint: "Password",
                            textInputType: TextInputType.text,
                            iconData: Icons.lock,
                            textEditingController: _passText,
                            obsecureText: true),
                      ),
                      Jarak(tinggi: 20),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 50, right: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[900]),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white)),
                      Jarak(tinggi: 20),
                      Text("Lupa Password ?",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Rubik',
                              fontSize: 16,
                              color: Colors.blue[900])),
                      Jarak(tinggi: 15),
                      Text("Perlu Bantuan Login/Aktivasi ?",
                          style: TextStyle(
                              fontFamily: 'Rubik',
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: Colors.blue[900])),
                      Jarak(tinggi: 30)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height,
                color: Colors.blue[900],
                child: Image.asset(
                  "images/login.png",
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
