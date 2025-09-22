import 'dart:developer';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:kalbemd/blesscom/widgets/loading_small.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputIjinExplore extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;

  const InputIjinExplore({
    required this.infoLog,
    required this.master,
    Key? key,
  }) : super(key: key);

  @override
  _InputIjinExploreState createState() => _InputIjinExploreState();
}

class _InputIjinExploreState extends State<InputIjinExplore> {
  List<Map<String, String>> _ieMaster = [];
  bool _loading = false;
  final bool _editable = false;
  bool _loadingPosting = false;

  void _initForm() async {
    log("masukinit");
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    _ieMaster = [
      {
        "nm": "token",
        "jns": "hidden",
        "value": await Helper.getPrefs("token"),
      },
      {
        "nm": "iduser",
        "jns": "hidden",
        "value": await Helper.getPrefs("iduser"),
      },
      {
        "nm": "nobukti",
        "jns": "hidden",
        "value": widget.master["nobukti"].toString(),
      },
      {
        "nm": "tglinvoice",
        "jns": "hidden",
        "value": widget.master["tglinvoice"].toString(),
      },
      {
        "nm": "temp_id",
        "jns": "hidden",
        "value": widget.master["temp_id"].toString(),
      },
      {
        "nm": "idijin",
        "jns": "selcustomqueryAjax",
        "label": "Jenis Ijin",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        // "customquery": widget.infoLog["infoLog"]["query_toko_checkin"]
        "customquery":
            "select a.id, a.nama as text from m_ijin a where a.isdeleted = 0",
      },
      {
        "nm": "foto",
        "jns": "croppie",
        "label": "Foto",
        "required": "Y",
      },
      {
        "nm": "ket",
        "jns": "text",
        "label": "Keterangan Ijin",
        "required": "Y",
      },
    ];

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
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
      urlInputPenjualanSalesAdd,
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
        content: const Text("Yakin Hapus Bukti Input Ijin?"),
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
      urlInputPenjualanSalesDelete,
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

  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double fixwidthlayar = width - (width * 6 / 100);

    // String status = "";
    // Color statusColor = Colors.red;
    // switch (widget.master["status"]) {
    //   case "O":
    //     statusColor = Colors.red;
    //     status = "Status : Open";
    //     break;
    //   case "C":
    //     statusColor = Colors.green;
    //     status = "Status : Close";
    //     break;
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Input Ijin",
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
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: InputBuilder(
                ieMaster: _ieMaster,
                submitLabel: "SIMPAN",
                actionUrl: urlStokAwalDetailAdd,
                onSubmit: _onSubmit,
              ),
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
