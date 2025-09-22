
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';

class OosEditDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic data;

  const OosEditDetail({
    required this.infoLog,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _OosEditDetailState createState() => _OosEditDetailState();
}

class _OosEditDetailState extends State<OosEditDetail> {
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
        "nm": "stokakhir",
        "jns": "number",
        "label": "Stok Akhir",
        "required": "Y",
        "value": widget.data["stokakhir"],
      },
      {
        "nm": "idissue",
        "jns": "selcustomqueryAjax",
        "label": "Issue",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "customquery": widget.infoLog["infoLog"]["query_issue"],
        "value": widget.data["idisseu"] ?? "",
        "valuetext": widget.data["idissue"] ?? "",
      },
      {
        "nm": "ket",
        "jns": "text",
        "label": "Keterangan",
        "required": "Y",
        "value": widget.data["ket"],
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
        title: const Text("Edit OOS"),
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: InputBuilder(
                ieMaster: _ieMaster,
                submitLabel: "Simpan",
                actionUrl: urlOosDetailAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
