import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:kalbemd/blesscom/forms/input_builderDua.dart';
import 'package:kalbemd/blesscom/widgets/labeled_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kalbemd/blesscom/widgets/loading_small.dart';

class InputPromoDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;
  final String queryPromo;
  final String queryYTMekanisme;

  const InputPromoDetail({
    required this.infoLog,
    required this.master,
    required this.queryPromo,
    required this.queryYTMekanisme,
    Key? key,
  }) : super(key: key);

  @override
  _InputPromoDetailState createState() => _InputPromoDetailState();
}

class _InputPromoDetailState extends State<InputPromoDetail> {
  bool _editable = false;
  bool _loadingPosting = false;
  List<Map<String, String>> _iePromo = [];
  bool _loading = false;

  void _initForm() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    _iePromo = [
      {
        "nm": "iduser",
        "jns": "hidden",
        "value": await Helper.getPrefs("iduser"),
      },
      {
        "nm": "token",
        "jns": "hidden",
        "value": await Helper.getPrefs("token"),
      },
      {
        "nm": "temp_idcheckin",
        "jns": "hidden",
        "value": widget.infoLog["temp_idcheckin"].toString(),
      },
      {
        "nm": "temp_id",
        "jns": "hidden",
        "value": widget.master["temp_id"].toString(),
      },

      {
        "nm": "idpromo",
        "jns": "selcustomqueryAjax",
        "label": "Nama Promo",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryPromo,
        "value": widget.master["idpromo"] ?? "",
        "valuetext": widget.master["namapromo"] ?? "",
      },

      // {
      //   "nm": "idkelompokbarang",
      //   "jns": "selcustomqueryAjax",
      //   "label": "Kelompok Ukuran",
      //   "ajaxurl": urlGetSelectAjax,
      //   "required": "Y",
      //   "source_kolom": "concat(a.jenis,' - ',a.kelompokbarang)",
      //   "customquery":
      //       "select a.id,concat(a.jenis,' - ',a.kelompokbarang) as text from m_kelompokbarang a where a.isdeleted=0",
      //   "value": widget.master["idkelompokbarang"] ?? "",
      //   "valuetext": widget.master["kelompokbarang"] ?? "",
      // },

      {
        "nm": "harganormal",
        "jns": "number",
        "label": "Harga Normal",
        "required": "Y",
        "value": widget.master["harganormal"] ?? "",
      },
      {
        "nm": "hargapromo",
        "jns": "number",
        "label": "Harga Promo",
        "required": "Y",
        "value": widget.master["hargapromo"] ?? "",
      },

      {
        "nm": "ytperiode",
        "jns": "selcustomqueryAjax",
        "label": "Apakah Periode Berjalan Sesuai ?",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.yt",
        "customquery": widget.queryYTMekanisme,
        "value": widget.master["ytperiode"] ?? "",
        "valuetext": widget.master["namaytperiode"] ?? "",
      },

      {
        "nm": "ytmekanisme",
        "jns": "selcustomqueryAjax",
        "label": "Apakah Sesuai dgn Mekanisme ?",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.yt",
        "customquery": widget.queryYTMekanisme,
        "value": widget.master["ytmekanisme"] ?? "",
        "valuetext": widget.master["namayt"] ?? "",
      },

      {
        "nm": "posmyt",
        "jns": "selcustomqueryAjax",
        "label": "Apakah POSM Terpasang ?",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.yt",
        "customquery": widget.queryYTMekanisme,
        "value": widget.master["posmyt"] ?? "",
        "valuetext": widget.master["namaposmyt"] ?? "",
      },

      {
        "nm": "ytprodukterpasang",
        "jns": "selcustomqueryAjax",
        "label": "Apakah Produk Terpasang ?",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.yt",
        "customquery": widget.queryYTMekanisme,
        "value": widget.master["ytprodukterpasang"] ?? "",
        "valuetext": widget.master["namaytprodukterpasang"] ?? "",
      },

      {
        "nm": "ket",
        "jns": "text",
        "label": "Keterangan",
        "value": widget.master["ket"] ?? "",
      },

      {
        "nm": "pricelist",
        "jns": "radiodua",
        "label": "Foto 1",
        "value": widget.master["pricelist"] != null
            ? "${baseURL}assets/images/lampiran/${widget.master["pricelist"]}"
            : "",
      },
      {
        "nm": "mailer",
        "jns": "radiodua",
        "label": "Foto 2",
        "value": widget.master["mailer"] != null
            ? "${baseURL}assets/images/lampiran/${widget.master["mailer"]}"
            : "",
      },

      {
        "nm": "posm",
        "jns": "radiodua",
        "label": "Foto 3",
        "value": widget.master["posm"] != null
            ? "${baseURL}assets/images/lampiran/${widget.master["posm"]}"
            : "",
      },
      {
        "nm": "display",
        "jns": "radiodua",
        "label": "Foto 4",
        "value": widget.master["display"] != null
            ? "${baseURL}assets/images/lampiran/${widget.master["display"]}"
            : "",
      },

      // {
      //   "nm": "oos",
      //   "jns": "radiodua",
      //   "label": "YT OOS",
      //   "value": widget.master["oos"] != null
      //       ? baseURL + "assets/images/lampiran/${widget.master["oos"]}"
      //       : "",
      // },
      {
        "nm": "dokumentasi",
        "jns": "radiodua",
        "label": "Foto 5",
        "value": widget.master["dokumentasi"] != null
            ? "${baseURL}assets/images/lampiran/${widget.master["dokumentasi"]}"
            : "",
      },
      // {
      //   "nm": "mailer",
      //   "jns": "croppiedua",
      //   "label": "Foto Mailer",
      //   "value": widget.master["mailer"] != null
      //       ? baseURL + "assets/images/lampiran/${widget.master["mailer"]}"
      //       : "",
      // },
      // {
      //   "nm": "digitalmailer",
      //   "jns": "croppiedua",
      //   "label": "Foto Digital Mailer",
      //   "value": widget.master["digitalmailer"] != null
      //       ? baseURL + "assets/images/lampiran/${widget.master["digitalmailer"]}"
      //       : "",
      // },
      // {
      //   "nm": "ovo",
      //   "jns": "croppiedua",
      //   "label": "Foto OVO",
      //   "value": widget.master["ovo"] != null
      //       ? baseURL + "assets/images/lampiran/${widget.master["ovo"]}"
      //       : "",
      // },
    ];
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  // ignore: avoid_unnecessary_containers
  // var bodyProgress = Container(
  //   child: Stack(
  //     children: <Widget>[
  //       Container(
  //         alignment: AlignmentDirectional.center,
  //         decoration: const BoxDecoration(
  //           color: Colors.white70,
  //         ),
  //         child: Container(
  //           decoration: BoxDecoration(
  //               color: warnautama, //,Colors.orange[200],
  //               borderRadius: BorderRadius.circular(10.0)),
  //           width: 300.0,
  //           height: 200.0,
  //           alignment: AlignmentDirectional.center,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               const Center(
  //                 child: SizedBox(
  //                   height: 50.0,
  //                   width: 50.0,
  //                   child: CircularProgressIndicator(
  //                     value: null,
  //                     strokeWidth: 7.0,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.only(top: 25.0),
  //                 child: const Center(
  //                   child: Text(
  //                     "Loading.. tunggu...",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );

  void _deleteMaster() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.master["nobukti"]),
        content: const Text("Yakin Hapus Bukti Input Keterjadian Promo?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _deleteMasterConfirm();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red)),
            child: const Text("Ya"),
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
      urlInputPromoDelete,
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
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red)),
            child: const Text("Ya"),
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
      urlInputPromoPosting,
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

  void _mockPullData() async {
    _editable = widget.infoLog["status_check_in"] == "Y" &&
        widget.infoLog["typeToko"] == "TOKO" &&
        widget.master["status"] == "O";

    // if (mounted) {
    //   setState(() => _isLoading = true);
    // }
  }

  void _onSubmit(dynamic response) {
    bool sukses = response["Sukses"] == "Y";
    String pesan = response["Pesan"];

    if (sukses) {
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: pesan,
          type: AlertType.success,
          onClose: () {
            setState(() {});
          },
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
  }
  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _initForm();
    _mockPullData();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

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
          "Input Keterjadian Promo",
        ),
        actions: [
          IconButton(
            onPressed: _editable && !_loadingPosting ? _deleteMaster : null,
            icon: const Icon(
              FontAwesomeIcons.trash,
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
                            SizedBox(
                            height: 8,
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
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InputBuilderDua(
                        ieMaster: _iePromo,
                        actionUrl: urlInputPromoDetailSubAdd,
                        onSubmit: _onSubmit,
                        submitLabel: "Simpan Promo",
                      )),
                )),
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
