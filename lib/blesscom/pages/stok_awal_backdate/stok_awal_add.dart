import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';

class StokAwalAdd extends StatefulWidget {
  // final dynamic master;
  final String queryKunjunganLalu;

  const StokAwalAdd({
    // required this.master,
    required this.queryKunjunganLalu,
    Key? key,
  }) : super(key: key);

  @override
  _StokAwalAddState createState() => _StokAwalAddState();
}

class _StokAwalAddState extends State<StokAwalAdd> {
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
        "nm": "mode",
        "jns": "hidden",
        "value": "simpan",
      },
      {
        "nm": "action",
        "jns": "hidden",
        "value": "add",
      },
      {
        "nm": "temp_idcheckin",
        "jns": "selcustomqueryAjax",
        "label": "Pilih Kunjungan Lalu",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "customquery": widget.queryKunjunganLalu,
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
                actionUrl: urlStokAwalBackdateAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
