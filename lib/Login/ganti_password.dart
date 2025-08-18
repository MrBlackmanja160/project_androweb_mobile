import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Home/home_panel.dart';
import 'package:kalbemd/Login/background.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GantiPasswordPage extends StatefulWidget {
  const GantiPasswordPage({Key? key}) : super(key: key);

  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  TextEditingController conPassNew = TextEditingController();
  TextEditingController conPassConfirm = TextEditingController();
  final GlobalKey<ScaffoldState> _scafoldstate = GlobalKey<ScaffoldState>();

  final List<bool> _passwordVisible = [false, false];

  void _togglePasswordVisible(int index) {
    setState(() {
      _passwordVisible[index] = !_passwordVisible[index];
    });
  }

  void _changePassword() async {
    // Get token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String iduser = prefs.getString("iduser") ?? "";
    String token = prefs.getString("token") ?? "";

    // Request
    Helper.sendHttpPostOld(
      urlGantiPassword,
      postData: {
        "iduser": iduser,
        "token": token,
        "newpassword": conPassNew.text,
        "newpasswordconfirm": conPassConfirm.text,
      },
      onFinish: (response) {
        _saveLoginInfo(response);
      },
    );
  }

  _saveLoginInfo(dynamic response) async {
    String success = response["Sukses"];
    String message = response["Pesan"];

    if (success == "Y") {
      // Go to home
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePanel(),
          transitionDuration: const Duration(milliseconds: 750),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          }));
    } else {
      Helper.showSnackBar(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldstate,
      body: Background(
        child: Container(
          padding:
              const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 120),
          child: ListView(
            children: <Widget>[
              const Center(
                  child: Text(
                "GANTI PASSWORD",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Poppins-Bold",
                    color: Colors.black54),
              )),
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 300,
                  height: 200,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Silahkan ganti password anda dahulu",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Helper.createTextField(
                        conPassNew, "Password Baru", FontAwesomeIcons.lock,
                        obscureText: !_passwordVisible[0],
                        obscureIcon: IconButton(
                            icon: Icon(
                              _passwordVisible[0]
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 18,
                              color: warnautama,
                            ),
                            onPressed: () => _togglePasswordVisible(0))),
                    const SizedBox(
                      height: 32,
                    ),
                    Helper.createTextField(
                        conPassConfirm, "Ulang Password", FontAwesomeIcons.lock,
                        obscureText: !_passwordVisible[1],
                        obscureIcon: IconButton(
                            icon: Icon(
                              _passwordVisible[1]
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 18,
                              color: warnautama,
                            ),
                            onPressed: () => _togglePasswordVisible(1))),
                    const SizedBox(
                      height: 16,
                    ),
                    Helper.createButton("Simpan", _changePassword,
                        minWidth: double.infinity),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
