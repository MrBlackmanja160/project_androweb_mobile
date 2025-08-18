// // ignore_for_file: avoid_unnecessary_containers, unnecessary_new, prefer_collection_literals, avoid_print

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:geolocator/geolocator.dart' as geogeo;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
// import 'package:geocoding/geocoding.dart' as oke;

// class IkiLokasiBok extends StatefulWidget {
//   const IkiLokasiBok({Key? key}) : super(key: key);

//   @override
//   _IkiLokasiBokState createState() => _IkiLokasiBokState();
// }

// class _IkiLokasiBokState extends State<IkiLokasiBok> {
//   bool loadingscreen = false;
//   double totaljarak = 0.0;
//   double totaljarakdua = 0.0;
//   String? totaljarakfix;
//   String? totaljarakfixdua;

//   GoogleMapController? controller;

//   Location location = Location();
//   bool _loading = false;

//   LocationData? locationku;
//   double? lattitudesaya = 0;
//   double? longitudesaya = 0;
//   String? error;

//   Completer<GoogleMapController> controllersku = Completer();

//   Map<MarkerId, Marker> markersku = {};

//   Set<Marker>? markers;

//   int? jaraksayadengankantor = 0;

//   Widget? maploading;

//   @override
//   void initState() {
//     _getLocation();
//     maploading = const SpinKitRipple(
//       color: Colors.blue,
//       size: 100,
//     );
//     markers = Set.from([]);
//     super.initState();
//   }

//   _addMarker(
//       LatLng position, String id, BitmapDescriptor descriptor, String infoini) {
//     MarkerId markerId = MarkerId(id);
//     Marker marker = Marker(
//         markerId: markerId,
//         icon: descriptor,
//         position: position,
//         infoWindow: InfoWindow(title: infoini));
//     markersku[markerId] = marker;
//   }

//   String statusfakegps = "";

//   Future<geogeo.Position> _determinePosition() async {
//     bool serviceEnabled;
//     geogeo.LocationPermission permission;

//     serviceEnabled = await geogeo.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await geogeo.Geolocator.checkPermission();
//     if (permission == geogeo.LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     if (permission == geogeo.LocationPermission.denied) {
//       permission = await geogeo.Geolocator.requestPermission();
//       if (permission != geogeo.LocationPermission.whileInUse &&
//           permission != geogeo.LocationPermission.always) {
//         return Future.error(
//             'Location permissions are denied (actual value: $permission).');
//       }
//     }
//     return await geogeo.Geolocator.getCurrentPosition(
//         desiredAccuracy: geogeo.LocationAccuracy.high);
//   }

//   Future<void> getAlamat() async {
//     FocusScope.of(context).requestFocus(new FocusNode());
//     List<oke.Placemark> placemarks = await oke.placemarkFromCoordinates(
//         locationku!.latitude!, locationku!.longitude!);

//     oke.Placemark placeMark = placemarks[0];
//     String street = placeMark.street!;
//     String name = placeMark.name!;
//     String subAdministrativeArea = placeMark.subAdministrativeArea!;
//     String administrativeArea = placeMark.administrativeArea!;
//     String subLocality = placeMark.subLocality!;
//     String locality = placeMark.locality!;
//     String subThoroughfare = placeMark.subThoroughfare!;
//     String thoroughfare = placeMark.thoroughfare!;
//     String country = placeMark.country!;
//     String isoCountryCode = placeMark.isoCountryCode!;
//     String postalCode = placeMark.postalCode!;

//     String address =
//         "${street}, ${name}, ${subAdministrativeArea}, ${administrativeArea}, ${subLocality}, ${locality}, ${subThoroughfare}, ${thoroughfare}, ${country}, ${isoCountryCode}, ${postalCode}";
//   }

//   Future<void> _getLocation() async {
//     setState(() {
//       print("Hallo Bosku");
//       error = null;
//       _loading = true;
//     });
//     try {
//       _determinePosition().then((position) {
//         if (position.isMocked) {
//           // fakenotice();
//           return;
//         }
//       });
//       final LocationData locationResult = await location.getLocation();
//       double lattkantor = -7.548455184955856;
//       double lnggkantor = 110.60483593944599;
//       setState(() {
//         locationku = locationResult;
//         getAlamat();
//         _loading = false;
//         _addMarker(LatLng(locationku!.latitude!, locationku!.longitude!),
//             "Lokasi Anda", BitmapDescriptor.defaultMarker, "Lokasi Anda");

//         _addMarker(LatLng(lattkantor, lnggkantor), "Lokasi kantor",
//             BitmapDescriptor.defaultMarkerWithHue(90), "Lokasi Kantor");

//         final lokasisaya =
//             toolkit.LatLng(locationku!.latitude!, locationku!.longitude!);
//         final lokasikantor = toolkit.LatLng(lattkantor, lnggkantor);

//         final distance = toolkit.SphericalUtil.computeDistanceBetween(
//                 lokasisaya, lokasikantor) /
//             1000;
//         final distancemeter = toolkit.SphericalUtil.computeDistanceBetween(
//             lokasisaya, lokasikantor);

//         double distancefix = distance.ceilToDouble();
//         double distancemeterfix = distancemeter.ceilToDouble();

//         jaraksayadengankantor = distancemeterfix.toInt();
//         print('Jarak dari Lokasi Saya dan Kantor Adalah $distancefix km.');
//         print(
//             'Jarak dari Lokasi Saya dan Kantor Adalah $jaraksayadengankantor m.');
//       });
//       // }
//       // });
//     } on PlatformException catch (err) {
//       setState(() {
//         error = err.code;
//         _loading = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.black87),
//           title: const Text('Absen WFO Masuk',
//               style: TextStyle(
//                 color: Color(0xFF3F3F3F),
//                 fontSize: 20,
//                 fontFamily: 'GOTHICB',
//               )),
//           centerTitle: true,
//           backgroundColor: Colors.white,
//         ),
//         body: _loading
//             ? const SpinKitRipple(
//                 color: Colors.blue,
//                 size: 100,
//               )
//             : Container(
//                 child: Form(
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Stack(
//                             children: [
//                               Center(
//                                 child: Align(
//                                   alignment: Alignment.topCenter,
//                                   child: Container(
//                                     decoration: const BoxDecoration(
//                                         border: Border(
//                                             bottom: BorderSide(
//                                                 color: Colors.black87))),
//                                     height: 300,
//                                     child: GoogleMap(
//                                       initialCameraPosition: CameraPosition(
//                                           zoom: 15,
//                                           target: LatLng(locationku!.latitude!,
//                                               locationku!.longitude!)),
//                                       markers: Set<Marker>.of(markersku.values),
//                                       mapType: MapType.normal,
//                                       tiltGesturesEnabled: true,
//                                       compassEnabled: true,
//                                       scrollGesturesEnabled: true,
//                                       zoomGesturesEnabled: true,
//                                       onMapCreated:
//                                           (GoogleMapController controller) {
//                                         // controllersku.complete(controller);
//                                         controller = controller;
//                                         // controllersku = controller;
//                                       },
//                                       // myLocationEnabled: true,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // bottomNavigationBar: BottomNavBarHandphone(),
//               ));
//   }
// }
