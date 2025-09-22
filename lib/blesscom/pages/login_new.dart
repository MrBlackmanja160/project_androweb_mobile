import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Home/home_panel.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/pages/ganti_password_new.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:kalbemd/blesscom/widgets/circle_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNew extends StatefulWidget {
  const LoginNew({Key? key}) : super(key: key);

  @override
  _LoginNewState createState() => _LoginNewState();
}

class _LoginNewState extends State<LoginNew> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _conUsername = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  bool _passwordVisible = false;
  bool _loading = false;
  String _version = "";

  @override
  // ignore: must_call_super
  void initState() {
    _passwordVisible = false;
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Get version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = "v${packageInfo.version}-${packageInfo.buildNumber}";

    // Get last input username / password
    _conUsername.text = await Helper.getPrefs("username");
    _conPassword.text = await Helper.getPrefs("password");

    String iduser = await Helper.getPrefs("iduser");

    // Goto home if already logged in
    if (iduser.isNotEmpty) {
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

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _togglePasswordVisible() {
    setState(() {
      _passwordVisible = !_passwordVisible;
      // ignore: avoid_print
      print("Password visible : $_passwordVisible");
    });
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Request
    HttpPostResponse response = await Helper.sendHttpPost(
      urlLogin,
      postData: {
        "tokenaplikasi": tokenAplikasi.toString(),
        "username": _conUsername.text.toString(),
        "password": _conPassword.text.toString(),
      },
    );

    // Success
    if (response.success) {
      _saveLoginInfo(response.data);
      setState(() {
        _loading = false;
      });
    } else {
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: response.error,
          details: response.responseBody,
          type: AlertType.error,
        );
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveLoginInfo(dynamic response) async {
    String success = response["Sukses"];
    String message = response["Pesan"];

    if (success == "Y") {
      // Save session data
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> session = response["session"];
      await prefs.setString(
        "iddivisi",
        session["iddivisi"] ?? "",
      );
      await prefs.setString( "level",session["level"] ?? "",);
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
      await prefs.setString(
        "ytaktifnoo",
        session["ytaktifnoo"] ?? "",
      );

      // Save last input username password
      await prefs.setString(
        "username",
        _conUsername.text,
      );
      await prefs.setString(
        "password",
        _conPassword.text,
      );

      // await prefs.setString("token", "840ce14f-5574-11ec-9e4f-001c4211794e");
      // await prefs.setString("iduser", "8f5177f2-5593-11ec-9e4f-001c4211794e");

      Helper.dumpPrefs();

      if (session["newpassword"] == "Y") {
        // Go to change password
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => const GantiPasswordNew(),
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
      if (mounted) {
        Helper.showSnackBar(context, message);
      }
    }
  }

  String? _validatorRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harap diisi';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Helper.getScreenHeight(context),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: Helper.getScreenWidth(context),
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: -100,
                right: -100,
                child: CircleShape(
                  size: 250,
                ),
              ),
              const Positioned(
                top: 190,
                left: -30,
                child: CircleShape(
                  size: 60,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: Helper.getScreenWidth(context) / 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: textStyleBiggestBold,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$appName ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: appNameSub,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Image.asset("assets/images/indonesia.png"),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                InputText(
                                  label: "Username",
                                  controller: _conUsername,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.user,
                                    size: 18,
                                  ),
                                  validator: _validatorRequired,
                                  toolbarOptions: const ToolbarOptions(),
                                ),
                                InputText(
                                  label: "Password",
                                  controller: _conPassword,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.lock,
                                    size: 18,
                                  ),
                                  validator: _validatorRequired,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 18,
                                    ),
                                    onPressed: _togglePasswordVisible,
                                  ),
                                  obscureText: !_passwordVisible,
                                  toolbarOptions: const ToolbarOptions(),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _login,
                                    child: _loading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Text(
                                            "MASUK",
                                            style: textStyleBold,
                                          ),
                                  ),
                                ),
                                //  SizedBox(
                                //   height: 16,
                                //   child: _loading ? const  Text("Ini Sedang Loading") : const Text("Ini Selesai Loading"),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: (Helper.getScreenHeight(context) - 64) / 10,
                      ),
                      Center(
                        child: Text(
                          _version,
                          style: textStyleSmall,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
