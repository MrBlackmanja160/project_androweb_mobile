import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/pages/check_in/check_in.dart';
import 'package:kalbemd/blesscom/widgets/card_checkin.dart';
import 'package:kalbemd/blesscom/widgets/menu_list.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '-',
    packageName: '-',
    version: '-',
    buildNumber: '-',
  );
  bool _loading = false;

  Map<dynamic, dynamic> _infoLog = {};

  void _getInfoLog() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Get info log
    _infoLog = await Helper.getInfoLog(context);

    // Get version info
    _packageInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _goToCheckIn() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => CheckIn(
          infoLog: _infoLog,
        ),
      ),
    )
        .then((value) {
      _getInfoLog();
    });
  }

  @override
  void initState() {
    super.initState();
    _getInfoLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${appName.toUpperCase()} ",
                          style: textStyleBigBold.copyWith(
                              color: Theme.of(context).primaryColor),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            appNameSub,
                            style: textStyleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Text(
                    "Jml Kunjungan Hari Ini : " +
                        (_infoLog["kunjungantokoke"] ?? ""),
                    style: textStyleMediumBold,
                  ),
                ),
                // const CardProfile(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Text(
                    "Check In",
                    style: textStyleMediumBold,
                  ),
                ),

                CardCheckin(
                  infoLog: _infoLog,
                  loading: _loading,
                  onTap: _goToCheckIn,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Text(
                    "Menu",
                    style: textStyleMediumBold,
                  ),
                ),

                if (!_loading)
                  MenuList(
                    infoLog: _infoLog,
                    loading: _loading,
                    onPop: _getInfoLog,
                  ),

                if (!_loading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "v${_packageInfo.version}+${_packageInfo.buildNumber}",
                        style: textStyleSmall.copyWith(
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
