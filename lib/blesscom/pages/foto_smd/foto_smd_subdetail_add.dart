import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/model_foto_smd_item.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/model_jenis_foto_smd.dart';
import 'package:flutter/material.dart';

class FotoSMDSubdetailAdd extends StatefulWidget {
  final ModelJenisFotoSMD masterSub;
  final ModelJenisFotoSMDItem? item;
  final String queryLokasiDisplay;
  final String queryBrandProduk;
  final String queryProduk;
  final String queryKeterangan;
  final String queryKelompokNds;
  final String queryJenisNds;

  const FotoSMDSubdetailAdd({
    required this.masterSub,
    required this.queryLokasiDisplay,
    required this.queryBrandProduk,
    required this.queryProduk,
    required this.queryKeterangan,
    required this.queryKelompokNds,
    required this.queryJenisNds,
    this.item,
    Key? key,
  }) : super(key: key);

  @override
  _FotoSMDSubdetailAddState createState() => _FotoSMDSubdetailAddState();
}

class _FotoSMDSubdetailAddState extends State<FotoSMDSubdetailAdd> {
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
        "value": widget.item != null ? "edit" : "add",
      },
      {
        "nm": "idjenisphoto",
        "jns": "hidden",
        "value": widget.masterSub.idjenisfoto ?? "",
      },
      {
        "nm": "foto",
        "jns": "croppiesave",
        "label": "Foto",
        "required": "Y",
        "temp_id" : widget.masterSub.tempid ?? "",
        "value": widget.item != null
            ? baseURL + "assets/images/lampiran/${widget.item!.foto}"
            : "",
      },
       {
        "nm": "idlokasi",
        "jns": "selcustomqueryAjax",
        "label": "Lokasi Display",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryLokasiDisplay,
        "value": widget.item != null ? widget.item!.idlokasi : "",
        "valuetext": widget.item != null ? widget.item!.lokasidisplay : "",
      },

     {
        "nm": "idkelompoknds",
        "jns": "selcustomqueryAjax",
        "label": "Jenis NDS",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryKelompokNds,
        "value": widget.item != null ? widget.item!.idkelompoknds : "",
        "valuetext": widget.item != null ? widget.item!.kelompoknds : "",
        "idchild" : "idjenisnds"
      },

      {
        "nm": "idjenisnds",
        "idparent" : "idkelompoknds",
        "jns": "selcustomqueryAjax",
        "label": "Rak",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryJenisNds,
        "value": widget.item != null ? widget.item!.idjenisnds : "",
        "valuetext": widget.item != null ? widget.item!.jenisnds : "",
      },

      {
        "nm": "idbrand",
        "jns": "selcustomqueryAjax",
        "label": "Brand",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryBrandProduk,
        "value": widget.item != null ? widget.item!.idbrand : "",
        "valuetext": widget.item != null ? widget.item!.brand : "",
        "idchild" : "idproduk"
      },

     {
        "nm": "idproduk",
        "idparent" : "idbrand",
        "jns": "selcustomqueryAjax",
        "label": "SKU",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryProduk,
        "value": widget.item != null ? widget.item!.idproduk : "",
        "valuetext": widget.item != null ? widget.item!.produk : "",
      },
       {
        "nm": "qty",
        "jns": "number",
        "label": "Stok",
         "required": "Y",
         "value": widget.item != null ?  widget.item!.qty : "",
      },

      {
        "nm": "idketerangan",
        "jns": "selcustomqueryAjax",
        "label": "Keterangan",
        "ajaxurl": urlGetSelectAjax,
        "required": "T",
         "source_kolom": "a.nama",
        "customquery": widget.queryKeterangan,
        "value": widget.item != null ? widget.item!.idketerangan : "",
        "valuetext": widget.item != null ? widget.item!.keterangan : "",
      },


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
        title: const Text("Tambah Activity"),
      ),
      resizeToAvoidBottomInset: true, // Tambahkan ini untuk menghindari overflow saat keyboard muncul  
      body: _loading
          ? const LinearProgressIndicator()
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: InputBuilder(
                  ieMaster: _ieMaster,
                  submitLabel: "Simpan",
                  actionUrl: urlFotoActivitySMDDetailSubAddV2,
                  onSubmit: _onSubmit,
                ),
              ),
          ),
    );
  }
}
