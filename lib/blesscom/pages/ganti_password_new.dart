import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Home/home_panel.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GantiPasswordNew extends StatefulWidget {
  const GantiPasswordNew({Key? key}) : super(key: key);

  @override
  _GantiPasswordNewState createState() => _GantiPasswordNewState();
}

class _GantiPasswordNewState extends State<GantiPasswordNew> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _conPassNew = TextEditingController();
  final TextEditingController _conPassConfirm = TextEditingController();

  final List<bool> _passwordVisible = [false, false];
  bool _loading = false;

  void _togglePasswordVisible(int index) {
    setState(() {
      _passwordVisible[index] = !_passwordVisible[index];
    });
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Get token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String iduser = prefs.getString("iduser") ?? "";
    String token = prefs.getString("token") ?? "";

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Request
    HttpPostResponse response = await Helper.sendHttpPost(
      urlGantiPassword,
      postData: {
        "iduser": iduser.toString(),
        "token": token.toString(),
        "newpassword": _conPassNew.text.toString(),
        "newpasswordconfirm": _conPassConfirm.text.toString(),
      },
    );

    // Success
    if (response.success) {
      _saveLoginInfo(response.data);
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
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Ganti Password",
                    style: textStyleBiggestBold,
                  ),
                  const Text(
                    "$appName $appNameSub",
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Icon(
                      FontAwesomeIcons.unlockAlt,
                      size: 64,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InputText(
                              label: "Password Baru",
                              controller: _conPassNew,
                              prefixIcon: const Icon(
                                FontAwesomeIcons.lock,
                                size: 18,
                              ),
                              validator: _validatorRequired,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible[0]
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 18,
                                ),
                                onPressed: () => _togglePasswordVisible(0),
                              ),
                              obscureText: !_passwordVisible[0],
                              toolbarOptions: const ToolbarOptions(),
                            ),
                            InputText(
                              label: "Ulang Password",
                              controller: _conPassConfirm,
                              prefixIcon: const Icon(
                                FontAwesomeIcons.lock,
                                size: 18,
                              ),
                              validator: _validatorRequired,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible[1]
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 18,
                                ),
                                onPressed: () => _togglePasswordVisible(1),
                              ),
                              obscureText: !_passwordVisible[1],
                              toolbarOptions: const ToolbarOptions(),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _changePassword,
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text(
                                        "UBAH PASSWORD",
                                        style: textStyleBold,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
