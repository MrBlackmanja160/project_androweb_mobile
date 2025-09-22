import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder_smd.dart';
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
  final String queryFotoRakNdb;
  final String queryKeteranganRakNdb;

  const FotoSMDSubdetailAdd({
    required this.masterSub,
    required this.queryLokasiDisplay,
    required this.queryBrandProduk,
    required this.queryProduk,
    required this.queryKeterangan,
    required this.queryKelompokNds,
    required this.queryJenisNds,
    required this.queryFotoRakNdb,
    required this.queryKeteranganRakNdb,
    this.item,
    Key? key,
  }) : super(key: key);

  @override
  _FotoSMDSubdetailAddState createState() => _FotoSMDSubdetailAddState();
}

class _FotoSMDSubdetailAddState extends State<FotoSMDSubdetailAdd> {
  List<Map<String, dynamic>> _ieMaster = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    if (mounted) setState(() => _loading = true);

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
        "temp_id": widget.masterSub.tempid ?? "",
        "value": (widget.item?.foto?.isNotEmpty ?? false)
            ? "$baseURL/assets/images/lampiran/${widget.item!.foto}"
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
        "value": widget.item?.idlokasi ?? "",
        "valuetext": widget.item?.lokasidisplay ?? "",
      },
      {
        "nm": "idkelompoknds",
        "jns": "selcustomqueryAjax",
        "label": "Jenis NDS",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryKelompokNds,
        "value": widget.item?.idkelompoknds ?? "",
        "valuetext": widget.item?.kelompoknds ?? "",
        "idchild": "idjenisnds"
      },
      {
        "nm": "idjenisnds",
        "idparent": "idkelompoknds",
        "jns": "selcustomqueryAjax",
        "label": "Rak",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryJenisNds,
        "value": widget.item?.idjenisnds ?? "",
        "valuetext": widget.item?.jenisnds ?? "",
        "onChange": (val) {
          setState(() {
            _initForm();
          });
        },
      },
      {
        "nm": "foto_rak_ndb",
        "jns": "croppiesave",
        "label": "Foto Rak NDB",
        "required": "Y", 
        "temp_id": widget.masterSub.tempid ?? "",
        "customquery": widget.queryFotoRakNdb,
        "value": (widget.item?.fotoRakNdb?.isNotEmpty ?? false)
            ? "$baseURL/assets/images/lampiran/${widget.item!.fotoRakNdb!}"
            : "",
        "showif": {
          "idkelompoknds#text": "Rak NDB",
          "idjenisnds#text": "Ada Rak NDB"
        },
        "excludeIfHidden": true,
      },
      {
        "nm": "keterangan_rak_ndb",
        "jns": "text",
        "label": "Keterangan Rak NDB",
        "required": "Y", 
        "customquery": widget.queryKeteranganRakNdb,
        "value": (widget.item?.keteranganRakNdb?.isNotEmpty ?? false) &&
                widget.item!.keteranganRakNdb!.trim() != "-"
            ? widget.item!.keteranganRakNdb!.trim()
            : "",
        "showif": {
          "idkelompoknds#text": "Rak NDB",
          "idjenisnds#text": "Ada Rak NDB"
        },
        "excludeIfHidden": true,
      },
      {
        "nm": "idbrand",
        "jns": "selcustomqueryAjax",
        "label": "Brand",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryBrandProduk,
        "value": widget.item?.idbrand ?? "",
        "valuetext": widget.item?.brand ?? "",
        "idchild": "idproduk"
      },
      {
        "nm": "idproduk",
        "idparent": "idbrand",
        "jns": "selcustomqueryAjax",
        "label": "SKU",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama",
        "customquery": widget.queryProduk,
        "value": widget.item?.idproduk ?? "",
        "valuetext": widget.item?.produk ?? "",
      },
      {
        "nm": "qty",
        "jns": "number",
        "label": "Stok",
        "required": "Y",
        "value": widget.item?.qty ?? "",
      },
      {
        "nm": "idketerangan",
        "jns": "selcustomqueryAjax",
        "label": "Keterangan",
        "ajaxurl": urlGetSelectAjax,
        "required": "T",
        "source_kolom": "a.nama",
        "customquery": widget.queryKeterangan,
        "value": widget.item?.idketerangan ?? "",
        "valuetext": widget.item?.keterangan ?? "",
      },
    ];

    if (mounted) setState(() => _loading = false);
  }

  void _onSubmit(dynamic response) {
    bool sukses = response["Sukses"]?.toString() == "Y";
    String pesan = response["Pesan"]?.toString() ?? "Terjadi kesalahan";

    if (mounted) {
      Helper.showAlert(
        context: context,
        message: pesan,
        type: sukses ? AlertType.success : AlertType.error,
        onClose: sukses ? () => Navigator.of(context).pop() : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Activity")),
      body: _loading
          ? const LinearProgressIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: InputBuilderSMD(
                ieMaster: _ieMaster,
                submitLabel: "Simpan",
                actionUrl: urlFotoActivitySMDDetailSubAddV2,
                onSubmit: _onSubmit,
              ),
            ),
    );
  }
}
