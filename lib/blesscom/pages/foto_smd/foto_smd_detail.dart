// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:math' as math;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Plugin/Table/data_table_header.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/model_jenis_foto_smd.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/foto_smd_add.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/foto_smd_subdetail.dart';
import 'package:kalbemd/blesscom/widgets/labeled_text.dart';
import 'package:kalbemd/blesscom/widgets/loading_small.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FotoSMDDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;

  const FotoSMDDetail({
    required this.infoLog,
    required this.master,
    Key? key,
  }) : super(key: key);

  @override
  _FotoSMDDetailState createState() => _FotoSMDDetailState();
}

class _FotoSMDDetailState extends State<FotoSMDDetail> {
  bool _editable = false;
  bool _loadingPosting = false;
  final List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "#",
        value: "no",
        show: true,
        flex: 1,
        sortable: true,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    // DatatableHeader(
    //     text: "Nobukti",
    //     value: "nobukti",
    //     show: true,
    //     flex: 2,
    //     sortable: true,
    //     editable: false,
    //     listAlign: TextAlign.left,
    //     textAlign: TextAlign.left),
    DatatableHeader(
        text: "Barang",
        value: "barang",
        show: true,
        flex: 3,
        sortable: true,
        editable: false,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Qty",
        value: "qty",
        show: true,
        flex: 1,
        sortable: true,
        editable: false,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "Harga",
        value: "harga",
        show: true,
        flex: 2,
        sortable: true,
        editable: false,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "Total",
        value: "total",
        show: true,
        flex: 2,
        sortable: true,
        editable: false,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
  ];

  final List<int> _perPages = [5, 10, 20, 50];
  int _total = 100;
  int _currentPerPage = 10;
  List<bool>? _expanded;
  String _searchKey = "barang";
  final FocusNode _focusSearch = FocusNode();
  bool _loading = false;
  bool _loadingUploadPhoto = false;
  String _initialPhoto = "";

  int _currentPage = 1;
  bool _isSearch = false;
  // ignore: deprecated_member_use, prefer_final_fields
  List<Map<String, dynamic>> _sourceOriginal = <Map<String, dynamic>>[];
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> _sourceFiltered = <Map<String, dynamic>>[];
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> _source = <Map<String, dynamic>>[];
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> _selecteds = <Map<String, dynamic>>[];
  // ignore: unused_field
  final String? _selectableKey = "namalengkap";
  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  // ignore: unused_field
  final bool _showSelect = true;
  var random = math.Random();

  DateTime selectedDate = DateTime.now();

  double _grandTotal = 0;

  Widget _dropContainer(data) {
    // ignore: unused_local_variable
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          const Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();
    // ignore: avoid_unnecessary_containers
    return Container(
      // height: 100,
      child: Column(
          // children: [
          //   Expanded(
          //       child: Container(
          //     color: Colors.red,
          //     height: 50,
          //   )),

          // ],
          // children: _children,
          ),
    );
  }

  Future<Iterable<Map<String, dynamic>>> _generateData() async {
    // Request data
    HttpPostResponse response = await Helper.sendHttpPost(
      urlPenjualanDetail,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "temp_id": widget.master["temp_id"].toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["rows"]);

      // Add numbering
      int no = 1;
      for (var element in data) {
        element["no"] = no++;
      }

      if (sukses) {
        return data;
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
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

    return [];
  }

  // ignore: avoid_unnecessary_containers
  var bodyProgress = Container(
    child: Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: warnautama, //,Colors.orange[200],
                borderRadius: BorderRadius.circular(10.0)),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: const Center(
                    child: Text(
                      "Loading.. tunggu...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  void _mockPullData() async {
    _editable = widget.infoLog["status_check_in"] == "Y" &&
        widget.infoLog["typeToko"] == "TOKO" &&
        widget.master["status"] == "O";

    _expanded = List.generate(_currentPerPage, (index) => false);

    if (mounted) {
      setState(() => _isLoading = true);
    }

    // _sourceOriginal.clear();
    // _sourceOriginal.addAll(await _generateData());
    // _sourceFiltered = _sourceOriginal;
    // _total = _sourceFiltered.length;
    // _source = _sourceFiltered
    //     .getRange(0, _currentPerPage > _total ? _total : _currentPerPage)
    //     .toList();

    // Calculate grand total
    // _grandTotal = 0;
    // for (var element in _sourceOriginal) {
    //   String total = element["total"];

    //   // Remove dot
    //   total = total.replaceAll('.', '');
    //   _grandTotal += int.parse(total);
    // }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var expandedLen =
        _total - start < _currentPerPage ? _total - start : _currentPerPage;
    Future.delayed(const Duration(seconds: 0)).then((value) {
      _expanded = List.generate(expandedLen.toInt(), (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      Helper.showSnackBar(context, e.toString());
    }
    setState(() => _isLoading = false);
  }

  void _addItem() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FotoSMDAdd(
              master: widget.master,
            ),
          ),
        )
        .then((value) => _mockPullData());
  }

  void _onTabRow(dynamic data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          data["barang"],
        ),
        content: Table(
          children: [
            TableRow(
              children: [
                const Text("Qty"),
                Text(data["qty"]),
              ],
            ),
            TableRow(
              children: [
                const Text("Harga"),
                Text(data["harga"]),
              ],
            ),
            TableRow(
              children: [
                const Text("Total"),
                Text(data["total"]),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteItem(data);
            },
            child: const Icon(
              FontAwesomeIcons.trash,
              size: 18,
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(dynamic data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          data["barang"],
        ),
        content: const Text("Hapus transaksi?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _deleteItemConfirm(data);
              Navigator.of(context).pop();
            },
            child: const Text("Ya"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  void _deleteItemConfirm(dynamic data) async {
    HttpPostResponse response = await Helper.sendHttpPost(
      urlPenjualanDetailDelete,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "temp_id": widget.master["temp_id"].toString(),
        "id": data["id"].toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      if (sukses) {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.success,
          );
        }

        // Refresh
        _mockPullData();
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
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
  }

  void _posting() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Posting Data?"),
        content: const Text(
            "Pastikan Data sudah Betul, setelah Posting data tidak bisa diedit ?!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _postingConfirm();
              Navigator.of(context).pop();
            },
            child: const Text("Ya"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  void _postingConfirm() async {
    setState(() {
      _loadingPosting = true;
    });
    HttpPostResponse response = await Helper.sendHttpPost(
      urlFotoActivitySMDAdd,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "action": "edit",
        "mode": "posting",
        "temp_id": widget.master["temp_id"].toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      if (sukses) {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.success,
          );
        }

        widget.master["status"] = "C";

        // Refresh
        _mockPullData();
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
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
        _loadingPosting = false;
      });
    }
  }

  void _deleteMaster() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.master["nobukti"]),
        content: const Text("Yakin Hapus Bukti Foto Activity?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _deleteMasterConfirm();
              Navigator.of(context).pop();
            },
            child: const Text("Ya"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  void _deleteMasterConfirm() async {
    HttpPostResponse response = await Helper.sendHttpPost(
      urlFotoActivitySMDDelete,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "id": widget.master["id"].toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      if (sukses) {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.success,
            onClose: () => Navigator.of(context).pop(),
          );
        }
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
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
  }

  void _uploadPhotoProduk(String value, String idjenisphoto) async {
    if (value.isEmpty) {
      return;
    }

    String responseBody = "";
    try {
      if (mounted) {
        setState(() {
          _loadingUploadPhoto = true;
        });
      }

      final Uri uri = Uri.parse(urlUploadPhotoSMD);

      // Create request
      var request = http.MultipartRequest("POST", uri);

      // Add POST data
      request.fields["token"] = await Helper.getPrefs("token");
      request.fields["iduser"] = await Helper.getPrefs("iduser");
      request.fields["temp_id"] = widget.master["temp_id"].toString();
      request.fields["idjenisphoto"] = idjenisphoto;
      request.files.add(
        await http.MultipartFile.fromPath("foto", value),
      );

      log("Sending data to $uri: \n " + request.fields.toString());

      // Response
      var response = await http.Response.fromStream(await request.send());
      log("Response from $uri : \n" + response.body);
      responseBody = response.body;

      // Decode
      Map<String, dynamic> decoded = jsonDecode(responseBody);
      bool sukses = decoded["Sukses"] == "Y";
      String pesan = decoded["Pesan"];
      _initialPhoto = baseURL + "assets/images/lampiran/" + decoded["Foto"];

      if (sukses) {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.success,
          );
        }
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
    } on SocketException {
      // log("Tidak ada koneksi internet");
      if (mounted) {
        Helper.showSnackBar(context, "Tidak ada koneksi internet");
      }
    } on HttpException {
      // log("Tidak dapat terhubung ke server");
      if (mounted) {
        Helper.showSnackBar(context, "Tidak dapat terhubung ke server");
      }
    } on FormatException {
      // log("Terjadi kesalahan. Klik detail dan kirim ke admin");
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: "Terjadi kesalahan. Klik detail dan kirim ke admin",
          details: responseBody,
          type: AlertType.error,
        );
      }
    } on http.ClientException {
      // log("Kesalahan Client");
      if (mounted) {
        Helper.showSnackBar(context, "Kesalahan Client");
      }
    }

    if (mounted) {
      setState(() {
        _loadingUploadPhoto = false;
      });
    }
  }

  List<ModelJenisFotoSMD> datafoto = [];
  List<ModelJenisFotoSMD> dataJenisFoto = [];

  Future<void> loadDataJenisFoto(String tempId) async {
    setState(() {
      datafoto.clear();
      dataJenisFoto.clear();
      _loading = true;
    });

    // Request data
    HttpPostResponse response = await Helper.sendHttpPost(
      urlMasterJenisFotoSMD,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "temp_id": tempId.toString()
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      // List<Map<String, dynamic>> data =
      //     List<Map<String, dynamic>>.from(response.data["rows"]);

      List<dynamic> data = response.data['rows'];
      for (var i = 0; i < data.length; i++) {
        datafoto.add(ModelJenisFotoSMD(
            idjenisfoto: data[i]["id"],
            nama: data[i]["nama"],
            tempid: data[i]["temp_id"],
            namafile: data[i]["foto"]));
      }

      if (sukses) {
        setState(() {
          dataJenisFoto = datafoto;
        });

        // return data;
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
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

  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _mockPullData();
    loadDataJenisFoto(widget.master["temp_id"].toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fixwidthlayar = width - (width * 6 / 100);

    String status = "";
    Color statusColor = Colors.red;
    switch (widget.master["status"]) {
      case "O":
        statusColor = Colors.red;
        status = "Status : Open";
        break;
      case "C":
        statusColor = Colors.green;
        status = "Status : Close";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FOTO ACTIVITY",
        ),
        actions: [
          IconButton(
            onPressed: _editable && !_loadingPosting ? _deleteMaster : null,
            icon: const Icon(
              FontAwesomeIcons.trash,
              size: 18,
            ),
          ),
          IconButton(
            onPressed: _isLoading
                ? null
                : () => loadDataJenisFoto(widget.master["temp_id"].toString()),
            icon: const Icon(
              FontAwesomeIcons.sync,
              size: 18,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 36,
                    color: statusColor,
                    child: Center(
                        child: Text(
                      status,
                      style: textStyleBold,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            LabeledText(
                              title: "No Bukti",
                              description: widget.master["nobukti"].toString(),
                            ),
                            LabeledText(
                              title: "Tanggal",
                              description: widget.master["tanggal"].toString(),
                            ),
                          ],
                        ),
                        const TableRow(children: [
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ]),
                        TableRow(
                          children: [
                            LabeledText(
                              title: "Toko",
                              description: widget.master["toko"].toString(),
                            ),
                            const LabeledText(
                              title: "",
                              description: "",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _loading
              ? LinearProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: dataJenisFoto.length,
                    // padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                    itemBuilder: (BuildContext context, int index) {
                      var value = dataJenisFoto[index];
                      // return InputPhotoKeterangan(
                      //   label: value.nama!,
                      //   height: 160,
                      //   initialValue: value.namafile!,
                      //   idjenisphoto: value.idjenisfoto!,
                      //   onChange: _uploadPhotoProduk,
                      //   enabled: _editable,
                      // );

                      return ExpansionTile(
                        title: Text(value.nama ?? ""),
                        children: [
                          FotoSMDSubDetail(
                            infoLog: widget.infoLog,
                            master: widget.master,
                            masterSub: value,
                          ),
                        ],
                      );
                    },
                  ),
                ),
          const Divider(),
        ],
      ),
      bottomNavigationBar: Material(
        child: Ink(
          color: _editable && !_loadingPosting
              ? Colors.red
              : Theme.of(context).disabledColor,
          child: InkWell(
            onTap: _editable && !_loadingPosting ? _posting : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _loadingPosting
                  ? const LoadingSmall()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.save,
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "POSTING",
                          style: textStyleBold,
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
