import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';

class InputPKMAddDetail extends StatefulWidget {
  final dynamic master;
  final String queryAddInputPkm;

  const InputPKMAddDetail({
    required this.master,
    required this.queryAddInputPkm,
    Key? key,
  }) : super(key: key);

  @override
  _InputPKMAddDetailState createState() => _InputPKMAddDetailState();
}

class _InputPKMAddDetailState extends State<InputPKMAddDetail> {
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
        "value": widget.master["temp_id"].toString(),
      },
      {
        "nm": "action",
        "jns": "hidden",
        "value": "add",
      },
      // {
      //   "nm": "idM7",
      //   "jns": "hidden",
      //   "value": "",
      // },
      {
        "nm": "idbarang",
        "jns": "selcustomqueryAjax",
        "label": "Barang",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "customquery": widget.queryAddInputPkm,
      },
      {
        "nm": "qty",
        "jns": "number",
        "label": "Quantity",
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
        title: const Text("Tambah Detail"),
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: InputBuilder(
                ieMaster: _ieMaster,
                submitLabel: "Simpan",
                actionUrl: urlInputPkmDetailAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
