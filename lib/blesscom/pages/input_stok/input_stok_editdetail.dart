import 'dart:developer';

import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';

class InputStokEditDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic data;

  const InputStokEditDetail({
    required this.infoLog,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _InputStokEditDetailState createState() => _InputStokEditDetailState();
}

class _InputStokEditDetailState extends State<InputStokEditDetail> {
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
      // {
      //   "nm": "idM7",
      //   "jns": "hidden",
      //   "value": "",
      // },
      {
        "nm": "nama",
        "jns": "text",
        "label": "Barang",
        "required": "Y",
        "value": widget.data["barang"],
        "readonly": "Y",
      },
      {
        "nm": "qty",
        "jns": "number",
        "label": "Quantity",
        "required": "Y",
        "value": widget.data["qty"],
      },
      {
        "nm": "harga",
        "jns": "number",
        "label": "Harga",
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
        title: const Text("Edit Stok Detail"),
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: InputBuilder(
                ieMaster: _ieMaster,
                submitLabel: "Simpan",
                actionUrl: urlInputStokDetailAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
