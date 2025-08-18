import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/pages/ganti_password_new.dart';
import 'package:kalbemd/blesscom/pages/login_new.dart';
import 'package:kalbemd/blesscom/widgets/profil_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Map<String, String> _profilData = {};
  bool _loading = false;

  void _logout() async {
    // Clear sharedpref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys();

    // Clear all except username and password
    for (var key in keys) {
      if (key != "username" && key != "password") {
        await prefs.remove(key);
      }
    }

    // Go to login page
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginNew()),
        (route) => false);
  }

  void _getUserData() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    var namadepan = await Helper.getPrefs("namadepan");
    var namabelakang = await Helper.getPrefs("namabelakang");
    var nama = "$namadepan $namabelakang";

    _profilData = {
      "Nama": nama,
      "Jabatan": await Helper.getPrefs("jabatan"),
      "Team Leader": await Helper.getPrefs("teamleader"),
      "Area": await Helper.getPrefs("area"),
      "Regional": await Helper.getPrefs("regional"),
    };

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  width: deviceWidth(context),
                  height: 400 - statusBarHeight(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          "Profil",
                          style: textStyleBigBold,
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: deviceWidth(context),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 90,
                                  ),
                                  ..._profilData.entries.map(
                                    (e) => ProfilItem(
                                      title: e.key,
                                      description: e.value,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Positioned(
                            top: -50,
                            left: 20,
                            right: 20,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Color(0xffFDCF09),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage("assets/images/avatar.png"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text("Log Out"),
                            onPressed: _logout,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GantiPasswordNew(),
                          ),
                        ),
                        child: const Text("Ganti Password"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ));
  }
}
