import 'package:kalbemd/Blesscom/Pages/home_page.dart';
import 'package:kalbemd/blesscom/pages/archievment/archievment.dart';
import 'package:kalbemd/blesscom/pages/backdate_page.dart';
import 'package:kalbemd/blesscom/pages/log_activity/log_activity.dart';
import 'package:kalbemd/blesscom/pages/profil/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePanel extends StatefulWidget {
  const HomePanel({Key? key}) : super(key: key);

  @override
  _HomePanelState createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  int currentIndex = 0;

  List namamenu = [
    const HomePage(),
    const Backdate(),
    const Archievment(),
    // const LogUang(),
    const LogActivity(),
    // const Lokasi(),
    const ProfilPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluar'),
            content: const Text('Anda ingin keluar aplikasi?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Ya'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: namamenu[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabTapped,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).disabledColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home),
              label: 'Home',
              // backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.history),
              label: 'Backdate',
              // backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartLine),
              label: 'Archievment',
              // backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(FontAwesomeIcons.wallet),
            //   label: 'Log Uang',
            //   // backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            // ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.running),
              label: 'Log Activity',
              // backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user),
              label: 'Profile',
              // backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
