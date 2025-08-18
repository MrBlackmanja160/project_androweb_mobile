import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:location/location.dart';

class Lokasi extends StatefulWidget {
  const Lokasi({Key? key}) : super(key: key);

  @override
  State<Lokasi> createState() => _LokasiState();
}

class _LokasiState extends State<Lokasi> {
  LocationData? _currentPosition;
  String _address = "";
  Location location = new Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Location"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Text("Josss"),
          if (_currentPosition != null)
            // ignore: prefer_const_constructors
            Text(
              "Latitude: ＄{_currentPosition.latitude}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          if (_currentPosition != null)
            // ignore: prefer_const_constructors
            Text(
              "Longitude: ＄{_currentPosition.longitude}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          if (_address != "")
            // ignore: prefer_const_constructors
            Text(
              "Address: ＄_address",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
        ],
      )),
    );
  }

  fetchLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      log("how!!");
      setState(() {
        _currentPosition = currentLocation;
      });
    });
  }
}
