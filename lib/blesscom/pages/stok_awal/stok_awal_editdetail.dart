import 'dart:developer';

import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';

class StokAwalEditDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic data;

  const StokAwalEditDetail({
    required this.infoLog,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _StokAwalEditDetailState createState() => _StokAwalEditDetailState();
}

class _StokAwalEditDetailState extends State<StokAwalEditDetail> {
  List<Map<String, String>> _ieMaster = [];
  bool _loading = false;

  void _initForm() async {
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
        "nm": "temp_id",
        "jns": "hidden",
        "value": widget.data["temp_id"],
      },
      {
        "nm": "action",
        "jns": "hidden",
        "value": "edit",
      },
      {
        "nm": "idbarang",
        "jns": "hidden",
        "value": widget.data["idbarang"],
      },
      {
        "nm": "idM7",
        "jns": "hidden",
        "value": widget.data["idM7"],
      },
      {
        "nm": "nama",
        "jns": "text",
        "label": "Produk",
        "required": "Y",
        "value": widget.data["produk"],
        "readonly": "Y",
      },
      {
        "nm": "stokawal",
        "jns": "number",
        "label": "Stok Awal",
        "required": "Y",
        "value": widget.data["stokawal"],
      },
      {
        "nm": "harga",
        "jns": "number",
        "label": "@Harga",
        "required": "Y",
        "value": widget.data["stokawal"],
      },
      // {
      //   "nm": "idremark",
      //   "jns": "selcustomqueryAjax",
      //   "label": "Remark",
      //   "ajaxurl": urlGetSelectAjax,
      //   "required": "Y",
      //   "customquery": widget.infoLog["infoLog"]["query_remark"],
      //   "value": widget.data["idremark"] ?? "",
      //   "valuetext": widget.data["remark"] ?? "",
      // },
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

  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Stok Awal Detail"),
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: InputBuilder(
                ieMaster: _ieMaster,
                submitLabel: "Simpan",
                actionUrl: urlStokAwalDetailAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
