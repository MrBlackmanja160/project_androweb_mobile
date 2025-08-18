import 'dart:developer';

import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';

class UpdateHargaEditDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic data;

  const UpdateHargaEditDetail({
    required this.infoLog,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _UpdateHargaEditDetailState createState() => _UpdateHargaEditDetailState();
}

class _UpdateHargaEditDetailState extends State<UpdateHargaEditDetail> {
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
        "nm": "idM7",
        "jns": "hidden",
        "value": widget.data["id"],
      },
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
        "nm": "namabarang",
        "jns": "text",
        "label": "Nama Barang",
        "required": "Y",
        "value": widget.data["namabarang"],
        "readonly": "Y",
      },
      {
        "nm": "hargarbp",
        "jns": "number",
        "label": "Harga RBP",
        "required": "Y",
        "value": widget.data["hargarbp"],
      },
      {
        "nm": "hargacbp",
        "jns": "number",
        "label": "Harga CBP",
        "required": "Y",
        "value": widget.data["hargacbp"],
      },
      {
        "nm": "competitor1",
        "jns": "text",
        "label": "Competitor 1",
        "required": "Y",
        "value": widget.data["competitor1"],
        "readonly": "Y",
      },
      {
        "nm": "hargacbp_competitor1",
        "jns": "number",
        "label": "Harga Competitor 1",
        "required": "Y",
        "value": widget.data["hargacbp_competitor1"],
      },
      {
        "nm": "competitor2",
        "jns": "text",
        "label": "Competitor 2",
        "required": "Y",
        "value": widget.data["competitor2"],
        "readonly": "Y",
      },
      {
        "nm": "hargacbp_competitor2",
        "jns": "number",
        "label": "Harga Competitor 2",
        "required": "Y",
        "value": widget.data["hargacbp_competitor2"],
      },
      {
        "nm": "competitor3",
        "jns": "text",
        "label": "Competitor 3",
        "required": "Y",
        "value": widget.data["competitor3"],
        "readonly": "Y",
      },
      {
        "nm": "hargacbp_competitor3",
        "jns": "number",
        "label": "Harga Competitor 3",
        "required": "Y",
        "value": widget.data["hargacbp_competitor3"],
      },
      {
        "nm": "competitor4",
        "jns": "text",
        "label": "Competitor 4",
        "required": "Y",
        "value": widget.data["competitor4"],
        "readonly": "Y",
      },
      {
        "nm": "hargacbp_competitor4",
        "jns": "number",
        "label": "Harga Competitor 4",
        "required": "Y",
        "value": widget.data["hargacbp_competitor4"],
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
        title: const Text("Edit Update Harga Detail"),
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: InputBuilder(
                  ieMaster: _ieMaster,
                  submitLabel: "Simpan",
                  actionUrl: urlUpdateHargaDetailAdd,
                  onSubmit: _onSubmit,
                ),
              ),
            ),
    );
  }
}
