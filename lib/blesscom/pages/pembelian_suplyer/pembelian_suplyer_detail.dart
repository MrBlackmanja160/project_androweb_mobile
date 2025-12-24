import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/widgets/loading_small.dart';
import 'package:kalbemd/blesscom/pages/pembelian_suplyer/pembelian_suplyer_add.dart';



class PembelianSuplyerDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  final dynamic master;

  const PembelianSuplyerDetail({
    required this.data,
    required this.master,
    Key? key,
  }) : super(key: key);

  @override
  State<PembelianSuplyerDetail> createState() => _PembelianSuplyerDetailState();
}

class _PembelianSuplyerDetailState extends State<PembelianSuplyerDetail> {
  bool _isLoading = false;

  // data yang dipakai render (akan di-merge dari detail endpoint)
  late Map<String, dynamic> _d;

  bool _isLoadingDetail = false;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _d = Map<String, dynamic>.from(widget.data);

    // NOTE: jangan pakai fallback agregat kalau item_count > 1
    _items = _extractItems(_d);
    _loadDetailIfNeeded();
  }

  String _safeString(dynamic v, {String fallback = "-"}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  double _safeDouble(dynamic v, {double fallback = 0}) {
    if (v == null) return fallback;
    return double.tryParse(v.toString()) ?? fallback;
  }

  int _safeInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    return int.tryParse(v.toString()) ?? fallback;
  }

  String _formatRupiah(dynamic value) {
    final amount = _safeDouble(value);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _statusCode(Map<String, dynamic> d) =>
      _safeString(d["status"], fallback: "").toUpperCase();

  bool _isOpenStatus(Map<String, dynamic> d) => _statusCode(d) == "O";
  bool _isClosedStatus(Map<String, dynamic> d) => _statusCode(d) == "C";

  String _idTransaksi() => _safeString(_d["idtransaksi"], fallback: "");
  String _idLegacy() => _safeString(_d["id"], fallback: "");

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _fotoBuktiUrl() {
    dynamic v = _d["foto_bukti_url"] ??
        _d["foto_bukti"] ??
        _d["fotobukti"] ??
        _d["foto"] ??
        _d["foto_url"] ??
        _d["foto_path"];

    final s = _safeString(v, fallback: "");
    if (s.isEmpty) return "";

    if (s.toLowerCase().startsWith("http://") ||
        s.toLowerCase().startsWith("https://")) {
      return s;
    }

    // Asumsi backend simpan filename relatif di assets/images/lampiran/
    final clean = s.startsWith("/") ? s.substring(1) : s;
    return "${baseURL}assets/images/lampiran/$clean";
  }

  void _openImageViewer(String url) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text(
                        "Gagal memuat gambar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    loadingBuilder: (c, w, p) {
                      if (p == null) return w;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),

              // TOP-LEFT: PREVIEW label
              Positioned(
                top: 8,
                left: 8,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "PREVIEW",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),

              // TOP-RIGHT: Close button
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: "Tutup",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFotoBuktiIfAny() {
    final url = _fotoBuktiUrl();
    if (url.isEmpty) {
      _showSnack("Foto bukti tidak tersedia.");
      return;
    }
    _openImageViewer(url);
  }

  void _handleEditTap() {
    final isOpen = _isOpenStatus(_d);
    if (!isOpen) return;
    if (_isLoading) return;
    _editItem();
  }

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> d) {
    final raw = d["items"];
    final List<Map<String, dynamic>> out = [];

    if (raw is List) {
      for (final it in raw) {
        if (it is Map<String, dynamic>) {
          out.add(it);
        } else if (it is Map) {
          out.add(Map<String, dynamic>.from(it));
        }
      }
    }

    // IMPORTANT:
    // Kalau item_count > 1, JANGAN bikin fallback agregat
    final itemCount = _safeInt(d["item_count"], fallback: 0);
    if (out.isEmpty && itemCount <= 1) {
      out.add({
        "nama_produk": d["nama_produk"],
        "qty": d["qty"],
        "harga": d["harga"], // unit price (kalau ada)
        "total": d["total"], // subtotal item (kalau ada)
      });
    }

    return out;
  }

  double _unitHargaFromItem(Map<String, dynamic> it) {
    var harga = _safeDouble(it["harga"]);
    if (harga > 0) return harga;

    // fallback hitung total/qty hanya aman untuk single item
    final itemCount = _safeInt(_d["item_count"], fallback: _items.length);
    if (itemCount <= 1) {
      final qty = _safeInt(it["qty"]);
      final total = _safeDouble(it["total"]);
      if (qty > 0 && total > 0) return total / qty;
    }

    return 0;
  }

  double _totalFromItem(Map<String, dynamic> it) {
    var total = _safeDouble(it["total"]);
    if (total > 0) return total;

    final qty = _safeInt(it["qty"]);
    final harga = _unitHargaFromItem(it);
    if (qty > 0 && harga > 0) return qty * harga;

    return 0;
  }

  double _grandTotalFromData(Map<String, dynamic> d) {
    final gtc = _safeDouble(d["grand_total_calc"]);
    if (gtc > 0) return gtc;

    final gt = _safeDouble(d["grand_total"]);
    if (gt > 0) return gt;

    double sum = 0;
    for (final it in _items) {
      sum += _totalFromItem(it);
    }

    if (sum <= 0) {
      final single = _safeDouble(d["total"]);
      if (single > 0) return single;
    }

    return sum;
  }

  Future<void> _loadDetailIfNeeded() async {
    // kalau sudah punya items dari detail, skip
    if (_d["items"] is List) {
      final List raw = _d["items"] as List;
      if (raw.isNotEmpty && _items.length > 1) return;
    }

    final itemCount = _safeInt(_d["item_count"], fallback: 1);
    if (itemCount <= 1) return; // single item: cukup dari list

    final idtransaksi = _idTransaksi();
    final idLegacy = _idLegacy();
    if (idtransaksi.isEmpty && idLegacy.isEmpty) return;

    setState(() => _isLoadingDetail = true);

    final iduser = await Helper.getPrefs("iduser");
    final token = await Helper.getPrefs("token");

    final HttpPostResponse response = await Helper.sendHttpPost(
      urlPembelianSuplyerDetail,
      postData: {
        "iduser": iduser,
        "token": token,
        "idtransaksi": idtransaksi,
        "id": idLegacy,
      },
    );

    if (!mounted) return;

    if (!(response.success && response.data is Map)) {
      setState(() => _isLoadingDetail = false);
      _showSnack(response.error ?? "Gagal ambil detail dari server.");
      return;
    }

    final Map resp = response.data as Map;

    if (resp["Sukses"]?.toString() != "Y") {
      setState(() => _isLoadingDetail = false);
      _showSnack(resp["Pesan"]?.toString() ?? "Gagal ambil detail dari server.");
      return;
    }

    // Backend kirim "header" dan "items"
    final Map headerRaw =
        (resp["header"] is Map) ? (resp["header"] as Map) : {};
    final List itemsRaw = (resp["items"] is List) ? (resp["items"] as List) : [];

    final header = Map<String, dynamic>.from(headerRaw);
    final items = itemsRaw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    final merged = <String, dynamic>{
      ..._d,
      ...header,
      "items": items,
      "item_count": items.isNotEmpty
          ? items.length
          : _safeInt(header["item_count"], fallback: itemCount),
    };

    // hitung ulang grand_total_calc dari items kalau tidak ada
    if (_safeDouble(merged["grand_total_calc"]) <= 0 && items.isNotEmpty) {
      double sum = 0;
      for (final it in items) {
        sum += _safeDouble(it["total"]);
      }
      merged["grand_total_calc"] = sum;
    }

    setState(() {
      _d = merged;
      _items = _extractItems(merged);
      _isLoadingDetail = false;
    });
  }

  // SALES NAME 
  Future<String> _salesNameFromPrefs() async {
    String s(String? v) => (v ?? '').toString().trim();

    final namadepan = s(await Helper.getPrefs("namadepan"));
    final namabelakang = s(await Helper.getPrefs("namabelakang"));
    final user = s(await Helper.getPrefs("user"));
    final username = s(await Helper.getPrefs("username"));
    final nama = s(await Helper.getPrefs("nama"));

    final full = "$namadepan $namabelakang".trim();
    if (full.isNotEmpty && full != "-") return full;
    if (user.isNotEmpty && user != "-") return user;
    if (nama.isNotEmpty && nama != "-") return nama;
    if (username.isNotEmpty && username != "-") return username;

    return "-";
  }

  // ACTIONS
  void _editItem() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => PembelianSuplyerAdd(
          master: widget.master,
          data: _d,
          initialDate: DateTime.now(),
        ),
      ),
    )
        .then((value) {
      if (value == true) {
        Navigator.pop(context, true);
      }
    });
  }

  void _deleteItem() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Hapus transaksi ${_safeString(_d["kode"])}?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processDelete();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text("Ya"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  Future<void> _processDelete() async {
    setState(() => _isLoading = true);

    final iduser = await Helper.getPrefs("iduser");
    final token = await Helper.getPrefs("token");

    final HttpPostResponse response = await Helper.sendHttpPost(
      urlPembelianSuplyerDelete,
      postData: {
        "iduser": iduser,
        "token": token,
        "id": _idLegacy(),
        "idtransaksi": _idTransaksi(),
      },
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final resp = response.data;
    final sukses = (resp is Map && resp["Sukses"] != null)
        ? resp["Sukses"].toString()
        : "T";
    final pesan = (resp is Map && resp["Pesan"] != null)
        ? resp["Pesan"].toString()
        : (response.error ?? "Terjadi kesalahan");

    if (response.success && sukses == "Y") {
      _showSnack(pesan);
      Navigator.of(context).pop(true);
      return;
    }

    Helper.showAlert(
      context: context,
      message: pesan,
      type: AlertType.error,
    );
  }

  Future<void> _postingItem() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Posting"),
        content: const Text(
          "Data yang sudah diposting tidak dapat diubah atau dihapus. Lanjutkan?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Posting"),
          ),
        ],
      ),
    );

    final bool confirm = result ?? false;
    if (!confirm) return;

    setState(() => _isLoading = true);

    final iduser = await Helper.getPrefs("iduser");
    final token = await Helper.getPrefs("token");

    final HttpPostResponse response = await Helper.sendHttpPost(
      urlPembelianSuplyerAdd,
      postData: {
        "iduser": iduser,
        "token": token,
        "id": _idLegacy(),
        "idtransaksi": _idTransaksi(),
        "mode": "posting",
      },
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final resp = response.data;
    final sukses = (resp is Map && resp["Sukses"] != null)
        ? resp["Sukses"].toString()
        : "T";
    final pesan = (resp is Map && resp["Pesan"] != null)
        ? resp["Pesan"].toString()
        : (response.error ?? "Terjadi kesalahan");

    if (response.success && sukses == "Y") {
      setState(() {
        _d = {..._d, "status": "C"};
      });

      _showSnack(pesan);
      Navigator.pop(context, true);
      return;
    }

    Helper.showAlert(
      context: context,
      message: pesan,
      type: AlertType.error,
    );
  }

  Future<void> _openThermalPreview() async {
    final idtransaksi = _idTransaksi();
    if (idtransaksi.isEmpty) {
      _showSnack("idtransaksi kosong. Tidak bisa cetak nota.");
      return;
    }

    // pastikan detail sudah ke-load agar PDF rinci
    if (_safeInt(_d["item_count"], fallback: _items.length) > 1 &&
        (!(_d["items"] is List) || _items.length <= 1)) {
      await _loadDetailIfNeeded();
    }

    final Map<String, dynamic> payload = Map<String, dynamic>.from(_d);
    payload["items"] = _items;
    payload["grand_total"] = _grandTotalFromData(payload);

    final s1 = _safeString(payload["nama_sales"], fallback: "");
    final s2 = _safeString(payload["sales_name"], fallback: "");
    final s3 = _safeString(payload["useri"], fallback: "");
    final already =
        [s1, s2, s3].any((x) => x.trim().isNotEmpty && x.trim() != "-");

    if (!already) {
      final fallbackSales = await _salesNameFromPrefs();
      payload["sales_name"] = fallbackSales;
    }

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotaPembelianSuplyerPreviewPage(data: payload),
      ),
    );
  }

  // =========================
  // UI helper
  // =========================
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildValue(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHeaderRow(String label1, String label2) {
    return Row(
      children: [
        Expanded(child: _buildLabel(label1)),
        Expanded(child: _buildLabel(label2)),
      ],
    );
  }

  Widget _buildValueRow(String val1, String val2) {
    return Row(
      children: [
        Expanded(child: _buildValue(val1)),
        Expanded(child: _buildValue(val2)),
      ],
    );
  }

  Widget _itemCardRow(Map<String, dynamic> it, {int? index}) {
    final nama = _safeString(it["nama_produk"]);
    final qty = _safeInt(it["qty"]);
    final harga = _unitHargaFromItem(it); // unit price
    final total = _totalFromItem(it); // subtotal

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(index != null ? "Nama Produk (item $index)" : "Nama Produk"),
          _buildValue(nama),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(index != null ? "Qty (item $index)" : "Qty"),
                    _buildValue(qty.toString()),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(index != null ? "Harga (item $index)" : "Harga"),
                    _buildValue(_formatRupiah(harga)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child:
                    _buildLabel(index != null ? "Subtotal (item $index)" : "Subtotal"),
              ),
              _buildValue(_formatRupiah(total)),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(color: Colors.white24, thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = _isOpenStatus(_d);
    final isClosed = _isClosedStatus(_d);

    final statusColor = isOpen ? Colors.red : Colors.green;
    final statusText = isOpen
        ? "Status : Open"
        : (isClosed ? "Status : Closed" : "Status : Closed");

    final grandTotal = _grandTotalFromData(_d);
    final fotoUrl = _fotoBuktiUrl();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: const Text(
          "Detail Pembelian",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: "Cetak Nota",
            onPressed: _isLoading ? null : _openThermalPreview,
            icon: const Icon(Icons.print),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          if (isOpen)
            IconButton(
              tooltip: "Hapus",
              onPressed: _isLoading ? null : _deleteItem,
              icon: const Icon(Icons.delete),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingSmall())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            statusText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderRow("NO PEMBELIAN", "TANGGAL"),
                              _buildValueRow(
                                _safeString(_d["kode"]),
                                _safeString(
                                  _d["tanggal_pembelian"],
                                  fallback: _safeString(_d["created"]),
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildLabel("SUPLYER"),
                              _buildValue(_safeString(_d["nama_supplier"])),
                              const SizedBox(height: 10),
                              _buildLabel("KODE SUPPLIER"),
                              _buildValue(_safeString(_d["kode_supplier"])),
                              const SizedBox(height: 10),
                              _buildLabel("ALAMAT"),
                              _buildValue(_safeString(_d["alamat"])),

                              // Foto bukti tidak ditampilkan di halaman detail.
                              // Preview foto bukti ada di tombol pada card "Detail Produk" saat CLOSED.
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  InkWell(
                    onTap: (isOpen && !_isLoading) ? _handleEditTap : null,
                    borderRadius: BorderRadius.circular(10),
                    child: Card(
                      color: const Color(0xFF333333),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _items.length > 1
                                      ? "Detail Produk (${_items.length} item)"
                                      : "Detail Produk",
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // OPEN: pensil edit
                                if (isOpen)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: InkResponse(
                                      onTap: _handleEditTap,
                                      radius: 20,
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                // CLOSED: tombol preview foto bukti
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: InkResponse(
                                      onTap: (fotoUrl.isNotEmpty && !_isLoading)
                                          ? _openFotoBuktiIfAny
                                          : null,
                                      radius: 20,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.photo,
                                          color: fotoUrl.isNotEmpty
                                              ? Colors.orange
                                              : Colors.white24,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (_isLoadingDetail)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(child: LoadingSmall()),
                              )
                            else ...[
                              const SizedBox(height: 5),
                              if (_items.isEmpty)
                                const Text("-",
                                    style: TextStyle(color: Colors.white70))
                              else if (_items.length == 1)
                                _itemCardRow(_items.first)
                              else
                                ..._items.asMap().entries.map(
                                      (e) => _itemCardRow(
                                        e.value,
                                        index: e.key + 1,
                                      ),
                                    ),
                            ],
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _formatRupiah(grandTotal),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: isOpen && !_isLoading
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red,
              child: InkWell(
                onTap: _postingItem,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "POSTING",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

// ============================================================================
// PREVIEW + PRINT PAGE (IN-APP) - TANPA PdfPreview TOOLBAR (HANYA 2 TOMBOL)
// ============================================================================

class NotaPembelianSuplyerPreviewPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const NotaPembelianSuplyerPreviewPage({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<NotaPembelianSuplyerPreviewPage> createState() =>
      _NotaPembelianSuplyerPreviewPageState();
}

class _NotaPembelianSuplyerPreviewPageState
    extends State<NotaPembelianSuplyerPreviewPage> {
  late Future<Uint8List> _pdfBytesFuture;
  late Future<List<PdfRaster>> _rastersFuture;

  @override
  void initState() {
    super.initState();
    _pdfBytesFuture = _buildPdf(PdfPageFormat.roll80);
    _rastersFuture =
        _pdfBytesFuture.then((bytes) => Printing.raster(bytes, dpi: 200).toList());
  }

  String _safeString(dynamic v, {String fallback = "-"}) {
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  double _safeDouble(dynamic v, {double fallback = 0}) {
    if (v == null) return fallback;
    return double.tryParse(v.toString()) ?? fallback;
  }

  int _safeInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    return int.tryParse(v.toString()) ?? fallback;
  }

  String _rupiah(dynamic v) {
    final amount = _safeDouble(v);
    return NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    ).format(amount);
  }

  String _tanggal() {
    final d = widget.data;

    final tgl = _safeString(d["tanggal_pembelian"], fallback: "");
    if (tgl.isNotEmpty && tgl != "-") return tgl;

    final created = _safeString(d["created"], fallback: "");
    if (created.length >= 10) return created.substring(0, 10);

    return "-";
  }

  String _fileName() {
    final no = _safeString(
      widget.data["idtransaksi"],
      fallback: _safeString(widget.data["kode"], fallback: "nota"),
    );
    return "nota_pembelian_suplyer_$no.pdf";
  }

  String _salesName() {
    final d = widget.data;

    final s1 = _safeString(d["nama_sales"], fallback: "");
    if (s1.isNotEmpty && s1 != "-") return s1;

    final s2 = _safeString(d["sales_name"], fallback: "");
    if (s2.isNotEmpty && s2 != "-") return s2;

    final s3 = _safeString(d["useri"], fallback: "");
    if (s3.isNotEmpty && s3 != "-") return s3;

    return "-";
  }

  Future<Uint8List> _pngWithWhiteBackground(PdfRaster page) async {
    final png = await page.toPng();

    final codec = await ui.instantiateImageCodec(png);
    final frame = await codec.getNextFrame();
    final img = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final bgPaint = ui.Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      bgPaint,
    );
    canvas.drawImage(img, ui.Offset.zero, ui.Paint());

    final picture = recorder.endRecording();
    final out = await picture.toImage(img.width, img.height);
    final outBytes = await out.toByteData(format: ui.ImageByteFormat.png);

    return outBytes!.buffer.asUint8List();
  }

  double _calcThermalHeightMm(int itemCount) {
    final base = 160.0;
    final perItem = 22.0;

    var h = base + (itemCount * perItem);

    if (h < 230.0) h = 230.0;
    if (h > 2000.0) h = 2000.0;

    return h;
  }

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> d) {
    final raw = d["items"];
    final List<Map<String, dynamic>> out = [];

    if (raw is List) {
      for (final it in raw) {
        if (it is Map<String, dynamic>) {
          out.add(it);
        } else if (it is Map) {
          out.add(Map<String, dynamic>.from(it));
        }
      }
    }

    final itemCount = _safeInt(d["item_count"], fallback: 0);
    if (out.isEmpty && itemCount <= 1) {
      out.add({
        "nama_produk": d["nama_produk"],
        "qty": d["qty"],
        "harga": d["harga"], // unit price
        "total": d["total"], // subtotal
      });
    }

    return out;
  }

  double _unitHarga(Map<String, dynamic> it) {
    var harga = _safeDouble(it["harga"]);
    if (harga > 0) return harga;

    // fallback hanya untuk single item
    final qty = _safeInt(it["qty"]);
    final total = _safeDouble(it["total"]);
    final itemCount = _safeInt(widget.data["item_count"], fallback: 1);

    if (itemCount <= 1 && qty > 0 && total > 0) return total / qty;
    return 0;
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final d = widget.data;

    final doc = pw.Document();
    final font = pw.Font.courier();

    final items = _extractItems(d);

    final heightMm = _calcThermalHeightMm(items.length);
    final pageFormat = PdfPageFormat(
      80 * PdfPageFormat.mm,
      heightMm * PdfPageFormat.mm,
      marginLeft: 5 * PdfPageFormat.mm,
      marginRight: 5 * PdfPageFormat.mm,
      marginTop: 5 * PdfPageFormat.mm,
      marginBottom: 6 * PdfPageFormat.mm,
    );

    pw.TextStyle ts(double size, {bool bold = false}) => pw.TextStyle(
          font: font,
          fontSize: size,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        );

    pw.Widget sep({double v = 6}) => pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: v),
          child: pw.Divider(thickness: 1),
        );

    pw.Widget kv(String k, String v) {
      final w = pageFormat.availableWidth;
      final labelW = w * 0.33;
      const colonW = 8.0;

      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: labelW, child: pw.Text(k, style: ts(9))),
          pw.SizedBox(width: colonW, child: pw.Text(":", style: ts(9))),
          pw.Expanded(child: pw.Text(v, style: ts(9), softWrap: true)),
        ],
      );
    }

    final namaSupplier = _safeString(d["nama_supplier"]);
    final kodeSupplier = _safeString(d["kode_supplier"]);
    final alamat = _safeString(d["alamat"]);
    final status = _safeString(d["status"], fallback: "").toUpperCase();
    final statusText = status == "O" ? "OPEN" : "CLOSED";
    final salesName = _salesName();

    // GRAND TOTAL: prioritas grand_total_calc -> grand_total -> hitung dari subtotal item
    double grandTotal = _safeDouble(d["grand_total_calc"]);
    if (grandTotal <= 0) grandTotal = _safeDouble(d["grand_total"]);

    if (grandTotal <= 0) {
      grandTotal = 0;
      for (final it in items) {
        final qty = _safeInt(it["qty"]);
        final harga = _unitHarga(it);
        final subtotal = _safeDouble(it["total"], fallback: qty * harga);
        grandTotal += subtotal;
      }
    }

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (_) {
          return pw.SizedBox.expand(
            child: pw.Container(
              color: PdfColors.white,
              child: pw.DefaultTextStyle(
                style: ts(9),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text("NOTA PEMBELIAN", style: ts(12, bold: true)),
                          pw.Text("SUPLYER", style: ts(12, bold: true)),
                          pw.SizedBox(height: 2),
                          pw.Text(_tanggal(), style: ts(9)),
                        ],
                      ),
                    ),
                    sep(),
                    kv("SUPLYER", namaSupplier),
                    kv("KODE", kodeSupplier),
                    if (alamat != "-" && alamat.isNotEmpty) kv("ALAMAT", alamat),
                    kv("STATUS", statusText),
                    kv("SALES", salesName),
                    sep(),

                    // HEADER TABEL:
                    // - kolom HARGA = harga satuan
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text("ITEM", style: ts(9, bold: true)),
                        ),
                        pw.SizedBox(
                          width: 36,
                          child: pw.Text(
                            "QTY",
                            style: ts(9, bold: true),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.SizedBox(
                          width: 76,
                          child: pw.Text(
                            "HARGA",
                            style: ts(9, bold: true),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Divider(thickness: 1),

                    ...items.map((it) {
                      final nama = _safeString(it["nama_produk"]);
                      final qty = _safeInt(it["qty"]);
                      final hargaSatuan = _rupiah(_unitHarga(it));

                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                nama,
                                style: ts(10, bold: true),
                                softWrap: true,
                              ),
                            ),
                            pw.SizedBox(
                              width: 36,
                              child: pw.Text(
                                "$qty",
                                style: ts(9),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                            pw.SizedBox(
                              width: 76,
                              child: pw.Text(
                                hargaSatuan,
                                style: ts(9),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    sep(),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text("GRAND TOTAL", style: ts(11, bold: true)),
                        ),
                        pw.Text(_rupiah(grandTotal), style: ts(11, bold: true)),
                      ],
                    ),
                    pw.Spacer(),
                    pw.Center(child: pw.Text("Terima kasih", style: ts(10))),
                    pw.SizedBox(height: 4),
                    pw.Center(
                      child: pw.Text(
                        "Dicetak: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}",
                        style: ts(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  Future<void> _doPrint() async {
    await Printing.layoutPdf(
      name: _fileName(),
      onLayout: (format) => _buildPdf(format),
    );
  }

  Future<void> _doShare() async {
    final bytes = await _pdfBytesFuture;
    await Printing.sharePdf(bytes: bytes, filename: _fileName());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: const Text(
          "Nota Pembelian Suplyer",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Container(
        color: const Color(0xFFEEEEEE),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                color: Colors.white,
                child: FutureBuilder<List<PdfRaster>>(
                  future: _rastersFuture,
                  builder: (context, ras) {
                    if (ras.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 280,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (!ras.hasData || ras.data == null || ras.data!.isEmpty) {
                      return const SizedBox(
                        height: 280,
                        child: Center(child: Text("Gagal render preview")),
                      );
                    }

                    final pages = ras.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: pages.length,
                      itemBuilder: (context, i) {
                        final page = pages[i];
                        return FutureBuilder<Uint8List>(
                          future: _pngWithWhiteBackground(page),
                          builder: (context, imgSnap) {
                            if (!imgSnap.hasData) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                color: Colors.white,
                                child: InteractiveViewer(
                                  minScale: 1,
                                  maxScale: 4,
                                  child: Image.memory(imgSnap.data!),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                tooltip: "Print",
                onPressed: _doPrint,
                icon: const Icon(Icons.print, color: Colors.black),
              ),
              const Spacer(),
              IconButton(
                tooltip: "Share",
                onPressed: _doShare,
                icon: const Icon(Icons.share, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
