import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Plugin/Table/data_table_header.dart';
import 'package:kalbemd/Plugin/table_plugin.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:kalbemd/blesscom/widgets/loading_small.dart';
import 'package:kalbemd/blesscom/pages/pembelian_suplyer/pembelian_suplyer_add.dart';
import 'package:kalbemd/blesscom/pages/pembelian_suplyer/pembelian_suplyer_detail.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PembelianSuplyer extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;

  const PembelianSuplyer({
    required this.infoLog,
    required this.master,
    Key? key,
  }) : super(key: key);

  @override
  _PembelianSuplyerState createState() => _PembelianSuplyerState();
}

class _PembelianSuplyerState extends State<PembelianSuplyer> {
  // --- HEADER TABEL ---
  final List<DatatableHeader> _headers = [
    DatatableHeader(
      text: "#",
      value: "view_no", // Menggunakan key khusus tampilan (Widget)
      show: true,
      flex: 2,
      sortable: false,
      listAlign: TextAlign.center,
      textAlign: TextAlign.center,
    ),
    DatatableHeader(
      text: "Tanggal",
      value: "created",
      show: true,
      flex: 4,
      sortable: true,
      editable: false,
      listAlign: TextAlign.center,
      textAlign: TextAlign.center,
    ),
    DatatableHeader(
      text: "Suplyer",
      value: "view_nama_supplier", // Menggunakan key khusus tampilan (Widget)
      show: true,
      flex: 6,
      sortable: true,
      editable: false,
      listAlign: TextAlign.left,
      textAlign: TextAlign.center, // Header di tengah
    ),
  ];

  final List<int> _perPages = [5, 10, 20, 50];
  int _total = 0;
  int _currentPerPage = 10;
  List<bool>? _expanded;
  String _searchKey = "nama_supplier"; 
  final FocusNode _focusSearch = FocusNode();

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _sourceFiltered = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _source = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _selecteds = <Map<String, dynamic>>[];
  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _loadingDelete = false;

  final TextEditingController _contgl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic> _master = {};

  // ------------ LOAD DATA ------------

  Future<Iterable<Map<String, dynamic>>> _generateData() async {
    final String iduser = await Helper.getPrefs("iduser");
    final String token = await Helper.getPrefs("token");

    HttpPostResponse res = await Helper.sendHttpPost(
      urlPembelianSuplyer,
      postData: {
        "iduser": iduser,
        "token": token,
        "bulan": _selectedDate.month.toString(),
        "tahun": _selectedDate.year.toString(),
      },
    );

    if (res.success) {
      bool sukses = res.data["Sukses"] == "Y";
      String pesan = res.data["Pesan"] ?? "";

      List<Map<String, dynamic>> rows =
          List<Map<String, dynamic>>.from(res.data["rows"] ?? []);

      int no = 1;
      for (var r in rows) {
        // --- 1. DATA MENTAH (Tetap String untuk Logic/Detail) ---
        String rawSupplier = r["nama_supplier"] ?? r["suplyer"] ?? "-";
        // Pastikan key 'nama_supplier' berisi string murni
        r["nama_supplier"] = rawSupplier; 
        
        if (r["nama_produk"] == null) r["nama_produk"] = r["nama"] ?? "-";

        // --- 2. DATA TAMPILAN (Widget untuk Tabel) ---
        
        // A. Kolom Nomor (Badge/Pill) -> Simpan di key 'view_no'
        bool isPosted = r["status"] == "C";
        Color badgeColor = isPosted ? Colors.green : Colors.red;
        
        r["view_no"] = Container(
          // Padding vertical dikurangi jadi 2 agar tidak terlalu tinggi
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${no++}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );

        // B. Kolom Supplier (Text Custom) -> Simpan di key 'view_nama_supplier'
        r["view_nama_supplier"] = Container(
          // Padding kiri 15 agar bergeser ke kanan
          padding: const EdgeInsets.only(left: 15), 
          alignment: Alignment.centerLeft,
          child: Text(
            rawSupplier,
            maxLines: 2, // Maksimal 2 baris
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 13),
          ),
        );
      }

      if (sukses) {
        final dynamic masterFromApi = res.data["master"];
        if (masterFromApi is Map) {
          final Map<String, dynamic> m =
              Map<String, dynamic>.from(masterFromApi);
          if (m.isNotEmpty) _master = m;
        }
        if (_master.isEmpty && widget.master is Map<String, dynamic>) {
          _master =
              Map<String, dynamic>.from(widget.master as Map<String, dynamic>);
        }
        return rows;
      } else {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.error,
          );
        }
      }
    } else {
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: res.error,
          details: res.responseBody,
          type: AlertType.error,
        );
      }
    }

    return [];
  }

  void _mockPullData() async {
    _expanded = List.generate(_currentPerPage, (index) => false);
    if (mounted) setState(() => _isLoading = true);

    _sourceOriginal.clear();
    _sourceOriginal.addAll(await _generateData());
    _sourceFiltered = _sourceOriginal;
    _total = _sourceFiltered.length;
    _source = _sourceFiltered
        .getRange(0, _currentPerPage > _total ? _total : _currentPerPage)
        .toList();

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var expandedLen =
        _total - start < _currentPerPage ? _total - start : _currentPerPage;
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      _expanded = List.generate(expandedLen.toInt(), (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  void _filterData(value) {
    setState(() => _isLoading = true);
    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        // Filter menggunakan data ASLI (String), bukan Widget
        _sourceFiltered = _sourceOriginal.where((data) {
          String s = data["nama_supplier"]?.toString().toLowerCase() ?? "";
          return s.contains(value.toString().toLowerCase());
        }).toList();
      }
      _total = _sourceFiltered.length;
      var rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
      _expanded = List.generate(rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      // Helper.showSnackBar(context, e.toString());
    }
    setState(() => _isLoading = false);
  }

  Future<void> _onTapDate() async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: _selectedDate,
    ).then((date) {
      if (date != null) {
        _selectDate(date);
      }
    });
  }

  void _selectDate(DateTime? date) {
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _contgl.text = DateFormat("MMMM y").format(_selectedDate);
      });
    }
    _mockPullData();
  }

  void _addItem() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PembelianSuplyerAdd(
              master: _master,
              initialDate: _selectedDate,
            ),
          ),
        )
        .then((value) => _mockPullData());
  }

  void _onTabRow(dynamic data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PembelianSuplyerDetail(
          data: data, // Aman karena data["nama_supplier"] masih String
          master: _master,
        ),
      ),
    ).then((value) {
      if (value == true) {
        _mockPullData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.master is Map<String, dynamic>) {
      _master =
          Map<String, dynamic>.from(widget.master as Map<String, dynamic>);
    }
    _contgl.text = DateFormat("MMMM y").format(_selectedDate);
    _selectDate(_selectedDate);
  }

  @override
  void dispose() {
    _focusSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fixwidthlayar = width - (width * 6 / 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembelian Suplyer"),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () => _mockPullData(),
            icon: const Icon(FontAwesomeIcons.sync, size: 18),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InputText(
                    controller: _contgl,
                    label: "Tanggal",
                    readOnly: true,
                    showCursor: false,
                    suffixIcon:
                        const Icon(FontAwesomeIcons.calendar, size: 18),
                    onTap: _onTapDate,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(
                      right: 15, left: 5, top: 5, bottom: 5),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loadingDelete ? null : _addItem,
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: OkeTable(
              title: null,
              widthtable: fixwidthlayar,
              actions: [
                if (_isSearch)
                  Expanded(
                    child: TextField(
                      focusNode: _focusSearch,
                      decoration: InputDecoration(
                        hintText:
                            'Cari Supplier',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              _isSearch = false;
                              _filterData("");
                            });
                          },
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) => _filterData(value),
                    ),
                  ),
                if (!_isSearch)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearch = true;
                        _focusSearch.requestFocus();
                      });
                    },
                  ),
              ],
              headers: _headers,
              source: _source,
              autoHeight: false,
              dropContainer: (data) => Container(),
              onTabRow: _loadingDelete ? null : _onTabRow,
              onSort: (value) {
                setState(() {
                  _sortColumn = value;
                  _sortAscending = !_sortAscending;
                  if (_sortAscending) {
                    _sourceFiltered.sort((a, b) =>
                        b["created"].toString().compareTo(a["created"].toString()));
                  } else {
                    _sourceFiltered.sort((a, b) =>
                        a["created"].toString().compareTo(b["created"].toString()));
                  }
                  _source = _sourceFiltered
                      .getRange(
                          0,
                          math.min(
                              _currentPerPage, _sourceFiltered.length))
                      .toList();
                  _searchKey = value;
                });
              },
              expanded: _expanded,
              sortAscending: _sortAscending,
              sortColumn: _sortColumn,
              isLoading: _isLoading,
              onSelect: (value, item) {
                setState(() {
                  if (value) {
                    _selecteds.add(item);
                  } else {
                    _selecteds.removeAt(_selecteds.indexOf(item));
                  }
                });
              },
              onSelectAll: (value) {
                setState(() {
                  if (value) {
                    _selecteds =
                        _source.map((entry) => entry).toList().cast();
                  } else {
                    _selecteds.clear();
                  }
                });
              },
              footers: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text("Show"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton(
                    value: _currentPerPage,
                    items: _perPages
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text("$e")))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _currentPerPage = int.parse(value.toString());
                        _resetData();
                      });
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      "$_currentPage - ${math.min(_currentPage + _currentPerPage - 1, _total)} dari $_total"),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  onPressed: _currentPage == 1
                      ? null
                      : () {
                          var nextSet = _currentPage - _currentPerPage;
                          setState(() {
                            _currentPage = nextSet > 1 ? nextSet : 1;
                            _resetData(start: _currentPage - 1);
                          });
                        },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: _currentPage + _currentPerPage - 1 > _total
                      ? null
                      : () {
                          var nextSet = _currentPerPage + _currentPage;
                          setState(() {
                            _currentPage = nextSet < _total
                                ? nextSet
                                : _total - _currentPerPage;
                            _resetData(start: nextSet - 1);
                          });
                        },
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
      bottomNavigationBar: _loadingDelete
          ? Material(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 56,
                child: const Center(child: LoadingSmall()),
              ),
            )
          : null,
    );
  }
}