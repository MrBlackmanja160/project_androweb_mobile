import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_builder_sup.dart';

class PembelianSuplyerAdd extends StatefulWidget {
  final dynamic master;
  final DateTime? initialDate;
  final Map<String, dynamic>? data;

  const PembelianSuplyerAdd({
    required this.master,
    this.initialDate,
    this.data,
    Key? key,
  }) : super(key: key);

  @override
  _PembelianSuplyerAddState createState() => _PembelianSuplyerAddState();
}

class _PembelianSuplyerAddState extends State<PembelianSuplyerAdd> {
  bool _loading = false;
  List<Map<String, dynamic>> _ieMaster = [];

  // Multi item (repeatable)
  int _itemCount = 1; // minimal 1 item
  static const int _maxItem = 20;

  // master queries (diambil dari widget.master)
  String _customQuerySuplyer = "";
  String _customQueryProduk = "";

  // temp_id untuk foto
  String _tempIdPembelian = "";

  // cache edit data
  late final bool _isEdit;
  late final Map<String, dynamic> _d;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.data != null;
    _d = widget.data ?? <String, dynamic>{};
    _initForm();
  }

  String _s(dynamic v, {String fallback = ""}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  Future<void> _initForm() async {
    if (mounted) setState(() => _loading = true);

    final Map<String, dynamic> master = (widget.master is Map<String, dynamic>)
        ? widget.master as Map<String, dynamic>
        : <String, dynamic>{};

    _customQuerySuplyer = master["queryAddPembelianSuplyer"]?.toString() ?? "";
    _customQueryProduk =
        master["queryAddPembelianSuplyerProduk"]?.toString() ?? "";

    _tempIdPembelian = _s(_d["temp_id"]);
    if (_tempIdPembelian.isEmpty) {
      _tempIdPembelian = "pembelian_${DateTime.now().millisecondsSinceEpoch}";
    }

    final rawItems = _d["items"];
    if (_isEdit && rawItems is List && rawItems.isNotEmpty) {
      _itemCount = rawItems.length.clamp(1, _maxItem);
    } else {
      _itemCount = 1;
    }

    await _rebuildIeMaster();

    if (mounted) setState(() => _loading = false);
  }

  /// Build ulang ieMaster untuk multi-item.
  /// Strategi penamaan field:
  /// - item 1: idbarang, nama_produk, qty, harga
  /// - item 2..n: idbarang_2, nama_produk_2, qty_2, harga_2, dst
  Future<void> _rebuildIeMaster() async {
    final String token = await Helper.getPrefs("token");
    final String iduser = await Helper.getPrefs("iduser");

    // tanggal pembelian (edit / initialDate / today)
    String tanggalPembelian;
    if (_isEdit && _d["tanggal_pembelian"] != null) {
      tanggalPembelian = _d["tanggal_pembelian"].toString();
    } else if (widget.initialDate != null) {
      tanggalPembelian = DateFormat("yyyy-MM-dd").format(widget.initialDate!);
    } else {
      tanggalPembelian = DateFormat("yyyy-MM-dd").format(DateTime.now());
    }

    // Supplier (snapshot)
    final String editIdSuplyer =
        (_isEdit && _s(_d["kode_supplier"]).isNotEmpty)
            ? _d["kode_supplier"].toString()
            : (_isEdit ? _s(_d["idsuplyer"]) : "");

    final String editNamaSupplier = _isEdit ? _s(_d["nama_supplier"]) : "";

    // Foto bukti (snapshot)
    final String fotoUrl = (_isEdit && _s(_d["foto_bukti"]).isNotEmpty)
        ? "${baseURL}assets/images/lampiran/${_d["foto_bukti"]}"
        : "";

    // Items untuk edit (jika tersedia)
    final List<Map<String, dynamic>> editItems = [];
    if (_isEdit && _d["items"] is List) {
      for (final it in (_d["items"] as List)) {
        if (it is Map<String, dynamic>) {
          editItems.add(it);
        } else if (it is Map) {
          editItems.add(Map<String, dynamic>.from(it));
        }
      }
    }

    Map<String, dynamic> _getEditItem(int idx1Based) {
      if (editItems.isEmpty) {
        if (idx1Based == 1) return _d;
        return <String, dynamic>{};
      }
      final i0 = idx1Based - 1;
      if (i0 >= 0 && i0 < editItems.length) return editItems[i0];
      return <String, dynamic>{};
    }

    final List<Map<String, dynamic>> m = [];

    m.addAll([
      {"nm": "token", "jns": "hidden", "value": token},
      {"nm": "iduser", "jns": "hidden", "value": iduser},
      {"nm": "action", "jns": "hidden", "value": _isEdit ? "edit" : "add"},
      if (_isEdit && _d["id"] != null)
        {"nm": "id", "jns": "hidden", "value": _d["id"].toString()},
      {"nm": "tanggal_pembelian", "jns": "hidden", "value": tanggalPembelian},
      {"nm": "temp_id", "jns": "hidden", "value": _tempIdPembelian},
      {"nm": "item_count", "jns": "hidden", "value": _itemCount.toString()},
    ]);
    m.addAll([
      {
        "nm": "idsuplyer",
        "jns": "selcustomqueryAjax",
        "label": "Nama Supplier",
        "ajaxurl": urlGetSelectAjax,
        "required": "Y",
        "source_kolom": "a.nama_supplier",
        "sourcekolom": "a.nama_supplier",
        "customquery": _customQuerySuplyer,
        "query": _customQuerySuplyer,
        "value": editIdSuplyer,
        "valuetext": editNamaSupplier,
        "copyTextTo": "nama_supplier",
      },
      {"nm": "nama_supplier", "jns": "hidden", "value": editNamaSupplier},
    ]);
    for (int idx = 1; idx <= _itemCount; idx++) {
      final it = _getEditItem(idx);

      final String nmIdBarang = (idx == 1) ? "idbarang" : "idbarang_$idx";
      final String nmNamaProduk =
          (idx == 1) ? "nama_produk" : "nama_produk_$idx";
      final String nmQty = (idx == 1) ? "qty" : "qty_$idx";
      final String nmHarga = (idx == 1) ? "harga" : "harga_$idx";

      final String editIdBarang = _s(it["idbarang"]).isNotEmpty
          ? it["idbarang"].toString()
          : _s(it["id"]); // fallback lama

      final String editNamaProduk = _s(it["nama_produk"]).isNotEmpty
          ? it["nama_produk"].toString()
          : _s(it["nama"]); // fallback lama

      m.addAll([
        {
          "nm": nmIdBarang,
          "jns": "selcustomqueryAjax",
          "label": (idx == 1) ? "Nama Produk" : "Nama Produk (Item $idx)",
          "ajaxurl": urlGetSelectAjax,
          "required": "Y",
          "source_kolom": "a.nama",
          "sourcekolom": "a.nama",
          "customquery": _customQueryProduk,
          "query": _customQueryProduk,
          "value": editIdBarang,
          "valuetext": editNamaProduk,
          "copyTextTo": nmNamaProduk,
        },
        {"nm": nmNamaProduk, "jns": "hidden", "value": editNamaProduk},
        {
          "nm": nmQty,
          "jns": "number",
          "label": (idx == 1) ? "Qty" : "Qty (Item $idx)",
          "required": "Y",
          "value": _isEdit ? _s(it["qty"]) : "",
        },
        {
          "nm": nmHarga,
          "jns": "number",
          "label": (idx == 1) ? "Harga Satuan" : "Harga Satuan (Item $idx)",
          "required": "T",
          "value": _isEdit ? _s(it["harga"]) : "",
        },
      ]);
    }
    m.add({
      "nm": "foto_bukti",
      "jns": "croppiesave_chooser",
      "label": "Foto Bukti Pembelian",
      "required": "T",
      "temp_id": _tempIdPembelian,
      "value": fotoUrl,
      "gallery": "Y", // izinkan galeri (kamera tetap tersedia via chooser)
    });

    if (mounted) {
      setState(() {
        _ieMaster = m;
      });
    } else {
      _ieMaster = m;
    }
  }
  Future<void> _addItem() async {
    if (_itemCount >= _maxItem) {
      _showSnack("Maksimal $_maxItem item per transaksi.");
      return;
    }
    setState(() => _loading = true);
    _itemCount += 1;
    await _rebuildIeMaster();
    if (mounted) setState(() => _loading = false);
    _showSnack("Item ditambahkan (total: $_itemCount).");
  }

  Future<void> _removeLastItem() async {
    if (_itemCount <= 1) {
      _showSnack("Minimal 1 item.");
      return;
    }
    setState(() => _loading = true);
    _itemCount -= 1;
    await _rebuildIeMaster();
    if (mounted) setState(() => _loading = false);
    _showSnack("Item terakhir dihapus (total: $_itemCount).");
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  void _onSubmit(dynamic response) {
    final bool sukses = response["Sukses"] == "Y";
    final String pesan = response["Pesan"] ?? "Proses selesai";

    if (sukses) {
      if (!mounted) return;
      Helper.showAlert(
        context: context,
        message: pesan,
        type: AlertType.success,
        onClose: () => Navigator.of(context).pop(true),
      );
    } else {
      if (!mounted) return;
      Helper.showAlert(
        context: context,
        message: pesan,
        type: AlertType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEdit ? "Edit Pembelian" : "Tambah Pembelian";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: "Menu",
            onSelected: (val) {
              if (_loading) return;
              if (val == "add") _addItem();
              if (val == "remove") _removeLastItem();
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: "add",
                enabled: !_loading,
                child: const Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 10),
                    Text("Tambah item"),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: "remove",
                enabled: !_loading,
                child: const Row(
                  children: [
                    Icon(Icons.remove),
                    SizedBox(width: 10),
                    Text("Hapus item terakhir"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _loading
          ? const LinearProgressIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Info ringkas jumlah item
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Jumlah item: $_itemCount",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Form builder
                  InputBuilder(
                    ieMaster: _ieMaster,
                    submitLabel: "Simpan",
                    actionUrl: urlPembelianSuplyerAdd,
                    onSubmit: _onSubmit,
                  ),
                ],
              ),
            ),
    );
  }
}
