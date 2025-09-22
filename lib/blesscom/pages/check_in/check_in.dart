import 'dart:developer';

import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';

class CheckIn extends StatefulWidget {
  final Map<dynamic, dynamic> infoLog;

  const CheckIn({
    required this.infoLog,
    Key? key,
  }) : super(key: key);

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool _checkedIn = false;

  // final List<bool> _toggleTokoBaru = [true, false];
  // bool _tokoBaru = false;

  LocationData? currentLocation;
  LocationData? locationOfGeo;

  Location location = Location();
  Map<MarkerId, Marker> markers = {};
  Map<CircleId, Circle> circles = {};
  String? error;
  bool _loading = false;

  List<Map<String, String>> _iePilihToko = [];
  List<Map<String, String>> _ieBuatToko = [];
  List<Map<String, String>> _ieCheckout = [];
  String _addressData = "";
  String iduser = "";
  String token = "";
  String querycheckin = "";
  String ytaktifnoo = "T";

  void _initForm() {
    _iePilihToko = [
      {
        "nm": "iduser",
        "jns": "hidden",
        "value": iduser,
      },
      {
        "nm": "token",
        "jns": "hidden",
        "value": token,
      },
      {
        "nm": "temp_idcheckin",
        "jns": "hidden",
        "value": widget.infoLog["temp_idcheckin"].toString(),
      },
      {
        "nm": "lat",
        "jns": "hidden",
        "value":
            currentLocation != null ? currentLocation!.latitude.toString() : "",
      },
      {
        "nm": "lng",
        "jns": "hidden",
        "value": currentLocation != null
            ? currentLocation!.longitude.toString()
            : "",
      },
      {
        "nm": "address_data",
        "jns": "hidden",
        "value": _addressData,
      },
      {
        "nm": "ytTokoBaru",
        "jns": "hidden",
        "value": "T",
      },
      {
        "nm": "idtoko",
        "jns": "selcustomqueryAjax",
        "label": "Toko",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
         "source_kolom": "concat(a.kode,' - ',a.nama)",
        // "customquery": widget.infoLog["infoLog"]["query_toko_checkin"]
        "customquery":
            "queryTokoCheckin#${currentLocation!.latitude}#${currentLocation!.longitude}"
      },
      {
        "nm": "foto_check_in",
        "jns": "croppie",
        "label": "Foto Check In",
      },
    ];

    _ieBuatToko = [
      {
        "nm": "iduser",
        "jns": "hidden",
        "value": iduser,
      },
      {
        "nm": "token",
        "jns": "hidden",
        "value": token,
      },
      {
        "nm": "temp_idcheckin",
        "jns": "hidden",
        "value": widget.infoLog["temp_idcheckin"].toString(),
      },
      {
        "nm": "lat",
        "jns": "hidden",
        "value":
            currentLocation != null ? currentLocation!.latitude.toString() : "",
      },
      {
        "nm": "lng",
        "jns": "hidden",
        "value": currentLocation != null
            ? currentLocation!.longitude.toString()
            : "",
      },
      {
        "nm": "address_data",
        "jns": "hidden",
        "value": _addressData,
      },
      {
        "nm": "ytTokoBaru",
        "jns": "hidden",
        "value": "Y",
      },
      {
        "nm": "idtoko",
        "jns": "hidden",
        "value": "",
      },
      // {
      //   "nm": "kode",
      //   "jns": "text",
      //   "label": "Kode Toko",
      //   "required": "Y",
      // },

       {
        "nm": "kode",
        "jns": "text",
        "label": "Kode Toko",
        "required": "Y",
      },
      {
        "nm": "nama",
        "jns": "text",
        "label": "Nama Toko",
        "required": "Y",
      },
     
      {
        "nm": "idgrouptoko",
        "jns": "selcustomqueryAjax",
        "label": "Group Toko",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery":
            "select a.id,a.nama as text from m_grouptoko a where a.isdeleted=0",
      },
      {
        "nm": "idtypetoko",
        "jns": "selcustomqueryAjax",
        "label": "Type Toko",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
         "source_kolom": "a.nama",
        "customquery":
            "select a.id,a.nama as text from m_typetoko a where a.isdeleted=0",
      },
      {
        "nm": "iddctoko",
        "jns": "selcustomqueryAjax",
        "label": "DC Toko",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
         "source_kolom": "a.nama",
        "customquery":
            "select id,nama as text from m_dctoko a where a.isdeleted=0",
      },
      {
        "nm": "idkelurahan",
        "jns": "selcustomqueryAjax",
        "label": "Kelurahan",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
         "source_kolom": "CONCAT(a.nama,', ',b.nama,', ',c.nama,', ',d.nama)",
        "customquery":
            "SELECT a.id,CONCAT(a.nama,', ',b.nama,', ',c.nama,', ',d.nama) AS text FROM m_kelurahan a INNER JOIN m_kecamatan b ON a.idkecamatan=b.id INNER JOIN m_kabupaten c ON b.idkabupaten=c.id INNER JOIN m_provinsi d ON c.idprovinsi=d.id AND a.isdeleted=0",
      },
      // {
      //   "nm": "alamat",
      //   "jns": "text",
      //   "label": "Alamat",
      //   "required": "Y",
      // },
      {
        "nm": "idtypelokasi",
        "jns": "selcustomqueryAjax",
        "label": "Type Lokasi",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
         "source_kolom": "a.nama",
        "customquery":
            "select a.id,a.nama as text from m_typelokasi a where a.isdeleted=0",
      },
      {
        "nm": "foto",
        "jns": "croppie",
        "label": "Foto Check In",
      },
    ];

    _ieCheckout = [
      {
        "nm": "iduser",
        "jns": "hidden",
        "value": iduser,
      },
      {
        "nm": "token",
        "jns": "hidden",
        "value": token,
      },
      {
        "nm": "temp_idcheckin",
        "jns": "hidden",
        "value": widget.infoLog["temp_idcheckin"].toString(),
      },
      {
        "nm": "lat",
        "jns": "hidden",
        "value":
            currentLocation != null ? currentLocation!.latitude.toString() : "",
      },
      {
        "nm": "lng",
        "jns": "hidden",
        "value": currentLocation != null
            ? currentLocation!.longitude.toString()
            : "",
      },
      {
        "nm": "address_data",
        "jns": "hidden",
        "value": _addressData,
      },
      {
        "nm": "foto_check_out",
        "jns": "croppie",
        "label": "Foto Check Out",
      },
    ];
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      String title, double accuracy) {
    MarkerId markerId = MarkerId(id);
    CircleId circleId = CircleId(id);

    // Location marker
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(
        title: title,
      ),
    );

    // Location accuracy (circle)
    Circle circle = Circle(
      circleId: circleId,
      center: position,
      radius: accuracy,
      fillColor: Colors.orange.withOpacity(.5),
      strokeWidth: 0,
    );
    markers[markerId] = marker;
    circles[circleId] = circle;
  }

  Future<geolocator.Position> _determinePosition() async {
    log("masuk _determine");

    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("service unnable");
      return Future.error('Location services are disabled.');
    } else {
      log("service avaible");
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.deniedForever) {
      log("location denied forever");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      log("location not denied");
    }

    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission != geolocator.LocationPermission.whileInUse &&
          permission != geolocator.LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    } else {
      log("location not denied 2");
    }

    return await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
  }

  Future<void> _getLocation() async {
    setState(() {
      log("Getting location");
      _loading = true;
    });

    try {
      _determinePosition().then((position) {
        if (position.isMocked) {
          return false;
        }
      });

      log("hati hati dijalan");
      final LocationData locationResult = await location.getLocation();
      log("here! we Go");
      log(locationResult.toString());

      // Final current location result
      currentLocation = locationResult;

      log("iam here !!");

      _addMarker(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          "Lokasi Anda",
          BitmapDescriptor.defaultMarker,
          "Lokasi Anda",
          currentLocation!.accuracy!); //! memastikan tidak Null

      // Get address data
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );

      if (placemarks.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var placemark = placemarks[0];
        _addressData =
          // "${placemark.street}, ${placemark.name}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subThoroughfare}, ${placemark.thoroughfare}, ${placemark.country}, ${placemark.isoCountryCode}, ${placemark.postalCode}";
           "${placemark.street}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.country}, ${placemark.isoCountryCode}, ${placemark.postalCode}";
        prefs.setString("_addressData", _addressData);
        prefs.setString("lat", currentLocation!.latitude!.toString());
        prefs.setString("lng", currentLocation!.longitude!.toString());
      }

      // Get iduser and token
      iduser = await Helper.getPrefs("iduser");
      token = await Helper.getPrefs("token");

      // Initialize forms
      _initForm();
    } on PlatformException catch (err) {
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: err.message,
          details: err.details,
          type: AlertType.error,
        );
        setState(() {
          error = err.code;
        });
      }
    }
    if (mounted) {
      log("ini mounted");
      setState(() {
        _loading = false;
      });
    }
  }

  void _onSubmit(dynamic response) {
    bool sukses = response["Sukses"] == "Y";
    String pesan = response["Pesan"];

    if (mounted) {
      //memastikan widget sdh terload semua
      Helper.showAlert(
        context: context,
        message: pesan,
        type: sukses ? AlertType.success : AlertType.error,
        onClose: sukses ? () => Navigator.of(context).pop() : null,
      );
    }

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: Icon(
    //             icon,
    //             color: Colors.orange,
    //             size: 64,
    //           ),
    //         ),
    //         Text(pesan),
    //       ],
    //     ),
    //     actions: [
    //       ElevatedButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: const Text("OK"),
    //       )
    //     ],
    //   ),
    // ).then((value) {
    //   if (sukses) {
    //     Navigator.of(context).pop();
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();

    _checkedIn = widget.infoLog["status_check_in"] == "Y"; //boolean true
    ytaktifnoo = widget.infoLog["infoLog"]["ytaktifnoo"];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(!_checkedIn ? "Check In" : "Check Out"),
          actions: [
            IconButton(
              onPressed: !_loading ? _getLocation : null,
              icon: const Icon(
                FontAwesomeIcons.sync,
                size: 18,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.grey[900],
              height: 200,
              child: Center(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                            zoom: 18,
                            target: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!)),
                        markers: Set<Marker>.of(markers.values),
                        circles: Set<Circle>.of(circles.values),
                        mapType: MapType.normal,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          // controllersku.complete(controller);
                          controller = controller;
                          // controllersku = controller;
                        },
                        // myLocationEnabled: true,
                      ),
              ),
            ),
            if (!_checkedIn)
              TabBar(
                tabs: [
                  const Text("Daftar Toko"),
                  (ytaktifnoo == "Y") ? const Text("NOO") : const Text("X NOO"),
                ],
              ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _checkedIn
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: InputBuilder(
                              ieMaster: _ieCheckout,
                              actionUrl: urlCheckOut,
                              onSubmit: _onSubmit,
                              submitLabel: "Check Out",
                            ),
                          ),
                        )
                      : TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: InputBuilder(
                                  ieMaster: _iePilihToko,
                                  actionUrl: urlCheckIn,
                                  onSubmit: _onSubmit,
                                  submitLabel: "Check In",
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: (ytaktifnoo == "Y")
                                    ? InputBuilder(
                                        ieMaster: _ieBuatToko,
                                        actionUrl: urlCheckIn,
                                        onSubmit: _onSubmit,
                                        submitLabel: "Simpan & Check In",
                                      )
                                    : const SizedBox(
                                        height: 50,
                                        child: Text(
                                            "Konfirm Admin untuk Menambah NOO"),
                                      ),
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
