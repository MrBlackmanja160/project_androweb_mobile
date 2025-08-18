import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';
import 'package:kalbemd/blesscom/pages/saldoakhirbackdate/saldo_akhir_explore_backdate.dart';

class SaldoAkhirAddBackdate extends StatefulWidget {
  // final dynamic master;
  final dynamic infoLog;
  final String queryKunjunganLalu;

  const SaldoAkhirAddBackdate({
    // required this.master,
    required this.infoLog,
    required this.queryKunjunganLalu,
    Key? key,
  }) : super(key: key);

  @override
  _SaldoAkhirAddBackdateState createState() => _SaldoAkhirAddBackdateState();
}

class _SaldoAkhirAddBackdateState extends State<SaldoAkhirAddBackdate> {
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
        // Helper.showAlert(
        //   context: context,
        //   message: pesan,
        //   type: AlertType.success,
        //   onClose: () => Navigator.of(context).pop(),
        // );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SaldoAkhirExploreBackdate(
              infoLog: widget.infoLog,
              master: {
                "nobukti": response["Nobukti"],
                "tanggal": response["tanggal"],
                "pelanggan": response["pelanggan"],
                "id": response["idmaster"],
                "temp_id": response["temp_id"],
                "temp_idcheckin": response["temp_idcheckin"],
                "status": response["Status"],
                "grandtotal": response["data"]["grandtotal"],
              },
            ),
          ),
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
                actionUrl: urlSaldoAkhirBackdateAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
