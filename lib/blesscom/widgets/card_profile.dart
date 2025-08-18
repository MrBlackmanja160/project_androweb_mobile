import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';

class CardProfile extends StatefulWidget {
  const CardProfile({Key? key}) : super(key: key);

  @override
  _CardProfileState createState() => _CardProfileState();
}

class _CardProfileState extends State<CardProfile> {
  String nama = "";
  String jabatan = "";
  String teamLeader = "";
  String area = "";
  String regional = "";

  void _getUserData() async {
    var namadepan = await Helper.getPrefs("namadepan");
    var namabelakang = await Helper.getPrefs("namabelakang");
    nama = "$namadepan $namabelakang";
    jabatan = await Helper.getPrefs("jabatan");
    teamLeader = await Helper.getPrefs("teamleader");
    area = await Helper.getPrefs("area");
    regional = await Helper.getPrefs("regional");

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo,",
                    style: textStyleRegularInvert,
                  ),
                  Text(
                    nama,
                    style: textStyleMediumBoldInvert,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      TableRow(children: [
                        const Text(
                          "Team Leader",
                          style: textStyleRegularInvert,
                        ),
                        const Text(" : ", style: textStyleRegularInvert),
                        Text(
                          teamLeader,
                          style: textStyleRegularInvert,
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "Area",
                          style: textStyleRegularInvert,
                        ),
                        const Text(" : ", style: textStyleRegularInvert),
                        Text(
                          area,
                          style: textStyleRegularInvert,
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "Regional",
                          style: textStyleRegularInvert,
                        ),
                        const Text(" : ", style: textStyleRegularInvert),
                        Text(
                          regional,
                          style: textStyleRegularInvert,
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    "assets/images/avatar.png",
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Card(
                  shadowColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(jabatan),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
