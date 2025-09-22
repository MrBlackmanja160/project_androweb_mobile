import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Home/home_panel.dart';
import 'package:kalbemd/Login/background.dart';
import 'package:kalbemd/Login/ganti_password.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController conusername = TextEditingController();
  TextEditingController conpassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scafoldstate = GlobalKey<ScaffoldState>();

  bool _passwordVisible = false;

  @override
  // ignore: must_call_super
  void initState() {
    _passwordVisible = false;
  }

  void _togglePasswordVisible() {
    setState(() {
      _passwordVisible = !_passwordVisible;
      // ignore: avoid_print
      print("Password visible : $_passwordVisible");
    });
  }

  void _login() async {
    // Request
    Helper.sendHttpPostOld(
      urlLogin,
      postData: {
        "tokenaplikasi": tokenAplikasi,
        "username": conusername.text,
        "password": conpassword.text,
      },
      onFinish: (response) {
        _saveLoginInfo(response);
      },
    );
  }

  Future<void> _saveLoginInfo(dynamic response) async {
    String success = response["Sukses"];
    String message = response["Pesan"];

    if (success == "Y") {
      // Save session data
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var session = response["session"];
      await prefs.setString(
        "iddivisi",
        session["iddivisi"] ?? "",
      );
      await prefs.setString(
        "level",
        session["level"] ?? "",
      );
      await prefs.setString(
        "idlevel",
        session["idlevel"] ?? "",
      );
      await prefs.setString(
        "scope",
        session["scope"] ?? "",
      );
      await prefs.setString(
        "iduser",
        session["iduser"] ?? "",
      );
      await prefs.setString(
        "statuslogin",
        session["statuslogin"] ?? "",
      );
      await prefs.setString(
        "username",
        session["username"] ?? "",
      );
      await prefs.setString(
        "namadepan",
        session["namadepan"] ?? "",
      );
      await prefs.setString(
        "namabelakang",
        session["namabelakang"] ?? "",
      );
      await prefs.setString(
        "newpassword",
        session["newpassword"] ?? "",
      );
      await prefs.setString(
        "idjabatan",
        session["idjabatan"] ?? "",
      );
      await prefs.setString(
        "jabatan",
        session["jabatan"] ?? "",
      );
      await prefs.setString(
        "idteamleader",
        session["idteamleader"] ?? "",
      );
      await prefs.setString(
        "teamleader",
        session["teamleader"] ?? "",
      );
      await prefs.setString(
        "idarea",
        session["idarea"] ?? "",
      );
      await prefs.setString(
        "area",
        session["area"] ?? "",
      );
      await prefs.setString(
        "areasalesmanager",
        session["areasalesmanager"] ?? "",
      );
      await prefs.setString(
        "idregional",
        session["idregional"] ?? "",
      );
      await prefs.setString(
        "regional",
        session["regional"] ?? "",
      );
      await prefs.setString(
        "regionalsalesmanager",
        session["regionalsalesmanager"] ?? "",
      );
      await prefs.setString(
        "token",
        session["token"] ?? "",
      );

      // await prefs.setString("token", "840ce14f-5574-11ec-9e4f-001c4211794e");
      // await prefs.setString("iduser", "8f5177f2-5593-11ec-9e4f-001c4211794e");

      Helper.dumpPrefs();

      if (session["newpassword"] == "Y") {
        // Go to change password
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => const GantiPasswordPage(),
            transitionDuration: const Duration(milliseconds: 750),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
      } else {
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
      }
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
                "LOGIN",
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
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Helper.createTextField(
                        conusername, "Username", FontAwesomeIcons.userAlt),
                    const SizedBox(
                      height: 20,
                    ),
                    Helper.createTextField(
                        conpassword, "Password", FontAwesomeIcons.lock,
                        obscureText: !_passwordVisible,
                        obscureIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 18,
                              color: warnautama,
                            ),
                            onPressed: _togglePasswordVisible)),
                    const SizedBox(
                      height: 30,
                    ),
                    Helper.createButton("Masuk", _login,
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
