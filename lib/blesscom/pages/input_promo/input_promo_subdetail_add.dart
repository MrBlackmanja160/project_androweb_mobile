import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:flutter/material.dart';
import 'package:kalbemd/blesscom/pages/input_promo/model_input_promo_item.dart';
import 'package:kalbemd/blesscom/pages/input_promo/model_jenis_input_promo.dart';

class InputPromoSubdetailAdd extends StatefulWidget {
  final ModelJenisInputPromo masterSub;
  final ModelJenisInputPromoItem? item;

  const InputPromoSubdetailAdd({
    required this.masterSub,
    this.item,
    Key? key,
  }) : super(key: key);

  @override
  _InputPromoSubdetailAddState createState() => _InputPromoSubdetailAddState();
}

class _InputPromoSubdetailAddState extends State<InputPromoSubdetailAdd> {
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
        "nm": "id",
        "jns": "hidden",
        "value": widget.item?.id ?? "",
      },
      {
        "nm": "temp_id",
        "jns": "hidden",
        "value": widget.masterSub.tempid ?? "",
      },
      {
        "nm": "action",
        "jns": "hidden",
        "value": widget.item != null ? "add" : "edit",
      },
      {
        "nm": "idjenisphoto",
        "jns": "hidden",
        "value": widget.masterSub.idjenisfoto ?? "",
      },
      {
        "nm": "foto",
        "jns": "croppie",
        "label": "Foto",
        "required": "Y",
        "value": widget.item != null
            ? baseURL + "assets/images/lampiran/${widget.item!.foto}"
            : "",
      },
      {
        "nm": "ket",
        "jns": "text",
        "label": "Ket",
        "required": "Y",
        "value": widget.item?.ket ?? "",
      },
      // {
      //   "nm": "remark",
      //   "jns": "text",
      //   "label": "Remark",
      //   "required": "Y",
      //   "value": widget.item?.remark ?? "",
      // },
    ];

    print(_ieMaster);

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
        title: const Text("Tambah Input Promo"),
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: InputBuilder(
                ieMaster: _ieMaster,
                submitLabel: "Simpan",
                actionUrl: urlInputPromoDetailSubAdd,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
