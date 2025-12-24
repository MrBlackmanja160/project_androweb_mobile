import 'dart:typed_data';

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

  // =========================
  // SAFE / FORMATTERS
  // =========================

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

  bool _isOpenStatus(Map<String, dynamic> d) =>
      _safeString(d["status"], fallback: "") == "O";

  String _idTransaksi() => _safeString(widget.data["idtransaksi"], fallback: "");
  String _idLegacy() => _safeString(widget.data["id"], fallback: "");

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // =========================
  // ACTIONS
  // =========================

  void _editItem() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => PembelianSuplyerAdd(
          master: widget.master,
          data: widget.data,
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
        content: Text("Hapus transaksi ${_safeString(widget.data["kode"])}?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // tutup dialog
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

    final String idtransaksi = _idTransaksi();
    final String idLegacy = _idLegacy();

    final HttpPostResponse response = await Helper.sendHttpPost(
      urlPembelianSuplyerDelete,
      postData: {
        "iduser": iduser,
        "token": token,
        "id": idLegacy,
        "idtransaksi": idtransaksi,
      },
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final data = response.data;
    final sukses = (data is Map && data["Sukses"] != null)
        ? data["Sukses"].toString()
        : "T";
    final pesan = (data is Map && data["Pesan"] != null)
        ? data["Pesan"].toString()
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

    final bool confirm = (result == true);
    if (!confirm) return;

    setState(() => _isLoading = true);

    final iduser = await Helper.getPrefs("iduser");
    final token = await Helper.getPrefs("token");

    final String idtransaksi = _idTransaksi();
    final String idLegacy = _idLegacy();

    final HttpPostResponse response = await Helper.sendHttpPost(
      urlPembelianSuplyerAdd,
      postData: {
        "iduser": iduser,
        "token": token,
        "id": idLegacy,
        "idtransaksi": idtransaksi,
        "mode": "posting",
      },
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final data = response.data;
    final sukses = (data is Map && data["Sukses"] != null)
        ? data["Sukses"].toString()
        : "T";
    final pesan = (data is Map && data["Pesan"] != null)
        ? data["Pesan"].toString()
        : (response.error ?? "Terjadi kesalahan");

    if (response.success && sukses == "Y") {
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

  void _openThermalPreview() {
    final idtransaksi = _idTransaksi();
    if (idtransaksi.isEmpty) {
      _showSnack("idtransaksi kosong. Tidak bisa cetak nota.");
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ThermalNotaPembelianSuplyerPreviewPage(
          data: widget.data,
        ),
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

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    final isOpen = _isOpenStatus(d);
    final statusColor = isOpen ? Colors.red : Colors.green;
    final statusText = isOpen ? "Status : Open" : "Status : Closed";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pembelian"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _isLoading ? null : _openThermalPreview,
            tooltip: "Cetak Nota",
          ),
          if (isOpen)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _deleteItem,
              tooltip: "Hapus",
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingSmall())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // HEADER CARD
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
                                _safeString(d["kode"]),
                                _safeString(d["created"]),
                              ),
                              const SizedBox(height: 15),
                              _buildLabel("SUPLYER"),
                              _buildValue(_safeString(d["nama_supplier"])),
                              const SizedBox(height: 10),
                              _buildLabel("KODE SUPPLIER"),
                              _buildValue(_safeString(d["kode_supplier"])),
                              const SizedBox(height: 10),
                              _buildLabel("ALAMAT"),
                              _buildValue(_safeString(d["alamat"])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DETAIL PRODUK CARD
                  Card(
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
                              const Text(
                                "Detail Produk",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isOpen)
                                InkWell(
                                  onTap: _editItem,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _buildLabel("Nama Produk"),
                          _buildValue(_safeString(d["nama_produk"])),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Qty"),
                                    _buildValue(
                                      _safeString(d["qty"], fallback: "0"),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("Harga"),
                                    _buildValue(_formatRupiah(d["harga"])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
                                  _formatRupiah(d["total"]),
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
                ],
              ),
            ),

      // POSTING BUTTON
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
// PREVIEW + PRINT PAGE (IN-APP)
// Revisi:
// - TOTAL -> HARGA (harga satuan)
// - TOTAL QTY dihapus
// - NO dihapus
// - SALES ditampilkan di bawah STATUS (ambil dari data["nama_sales"] / data["sales_name"] / fallback data["useri"])
// ============================================================================

class ThermalNotaPembelianSuplyerPreviewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ThermalNotaPembelianSuplyerPreviewPage({
    required this.data,
    Key? key,
  }) : super(key: key);

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

  String _rupiah(dynamic value) {
    final amount = _safeDouble(value);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _tanggal() {
    final tgl = _safeString(data["tanggal_pembelian"], fallback: "");
    if (tgl.isNotEmpty && tgl != "-") return tgl;

    final created = _safeString(data["created"], fallback: "");
    if (created.length >= 10) return created.substring(0, 10);

    return "-";
  }

  String _salesName() {
    final s1 = _safeString(data["nama_sales"], fallback: "");
    if (s1.isNotEmpty && s1 != "-") return s1;

    final s2 = _safeString(data["sales_name"], fallback: "");
    if (s2.isNotEmpty && s2 != "-") return s2;

    final s3 = _safeString(data["useri"], fallback: "");
    if (s3.isNotEmpty && s3 != "-") return s3;

    return "-";
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final doc = pw.Document();

    final courier = pw.Font.courier();
    final bool isOpen = _safeString(data["status"], fallback: "") == "O";

    // Thermal 80mm
    final pageFormat = PdfPageFormat.roll80.copyWith(
      marginLeft: 6 * PdfPageFormat.mm,
      marginRight: 6 * PdfPageFormat.mm,
      marginTop: 6 * PdfPageFormat.mm,
      marginBottom: 6 * PdfPageFormat.mm,
    );

    pw.Widget hr({double thickness = 0.7}) {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(vertical: 6),
        child: pw.Divider(thickness: thickness),
      );
    }

    pw.Widget kv(String k, String v) {
      const double labelW = 58;
      final style = pw.TextStyle(font: courier, fontSize: 10);

      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: labelW, child: pw.Text(k, style: style)),
          pw.Text(': ', style: style),
          pw.Expanded(child: pw.Text(v, style: style, softWrap: true)),
        ],
      );
    }

    // =========================
    // ITEMS (support single & multi)
    // =========================
    final rawItems = data["items"];
    final List<Map<String, dynamic>> items = [];

    if (rawItems is List) {
      for (final it in rawItems) {
        if (it is Map<String, dynamic>) items.add(it);
        if (it is Map) items.add(Map<String, dynamic>.from(it));
      }
    }

    if (items.isEmpty) {
      items.add({
        "nama_produk": data["nama_produk"],
        "qty": data["qty"],
        "harga": data["harga"], // harga satuan
        "total": data["total"], // subtotal (qty * harga)
      });
    }

    double grandTotal = 0;
    for (final it in items) {
      final q = _safeInt(it["qty"]);
      final h = _safeDouble(it["harga"]);
      final lineTotal = _safeDouble(it["total"], fallback: q * h);
      grandTotal += lineTotal;
    }

    final namaSupplier = _safeString(data["nama_supplier"]);
    final kodeSupplier = _safeString(data["kode_supplier"]);
    final statusText = isOpen ? "OPEN" : "CLOSED";

    final salesName = _salesName();
    final showSales = (salesName != "-" && salesName.trim().isNotEmpty);

    // =========================
    // TABLE (ITEM | QTY | HARGA)
    // =========================
    pw.Widget tableHeader() {
      final st = pw.TextStyle(
        font: courier,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      );

      return pw.Row(
        children: [
          pw.Expanded(flex: 6, child: pw.Text("ITEM", style: st)),
          pw.Expanded(
            flex: 2,
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("QTY", style: st),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("HARGA", style: st),
            ),
          ),
        ],
      );
    }

    pw.Widget tableRow({
      required String namaProduk,
      required int qty,
      required String hargaSatuan,
    }) {
      final st = pw.TextStyle(font: courier, fontSize: 10);
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(flex: 6, child: pw.Text(namaProduk, style: st, softWrap: true)),
            pw.Expanded(
              flex: 2,
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(qty.toString(), style: st),
              ),
            ),
            pw.Expanded(
              flex: 4,
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(hargaSatuan, style: st),
              ),
            ),
          ],
        ),
      );
    }

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (ctx) {
          final content = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Center(
                child: pw.Text(
                  'NOTA PEMBELIAN SUPLYER',
                  style: pw.TextStyle(
                    font: courier,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  _tanggal(),
                  style: pw.TextStyle(font: courier, fontSize: 10),
                ),
              ),

              hr(),

              kv('SUPLYER', namaSupplier),
              kv('KODE', kodeSupplier),
              kv('STATUS', statusText),
              if (showSales) kv('SALES', salesName),

              hr(),

              tableHeader(),
              pw.Divider(thickness: 0.7),

              ...items.map((it) {
                final nama = _safeString(it["nama_produk"]);
                final q = _safeInt(it["qty"]);
                final hargaSatuan = _rupiah(it["harga"]);
                return tableRow(
                  namaProduk: nama,
                  qty: q,
                  hargaSatuan: hargaSatuan,
                );
              }).toList(),

              hr(),

              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'GRAND TOTAL',
                      style: pw.TextStyle(
                        font: courier,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    _rupiah(grandTotal),
                    style: pw.TextStyle(
                      font: courier,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              hr(),

              pw.SizedBox(height: 6),
              pw.Center(
                child: pw.Text(
                  'Terima kasih',
                  style: pw.TextStyle(font: courier, fontSize: 10),
                ),
              ),
            ],
          );

          // Watermark PREVIEW saat status OPEN
          if (!isOpen) return content;

          return pw.Stack(
            children: [
              content,
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.12,
                    child: pw.Transform.rotate(
                      angle: -0.35,
                      child: pw.Text(
                        'PREVIEW',
                        style: pw.TextStyle(
                          font: courier,
                          fontSize: 48,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nota Pembelian Suplyer"),
      ),
      body: Container(
        color: const Color(0xFFEEEEEE),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.all(16),
              child: PdfPreview(
                canChangeOrientation: false,
                canChangePageFormat: false,
                allowSharing: true,
                allowPrinting: true,
                pdfFileName: "nota_pembelian_suplyer.pdf",
                initialPageFormat: PdfPageFormat.roll80,
                build: _buildPdf,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
