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
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PembelianSuplyer extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master; // master global dari menu

  const PembelianSuplyer({
    required this.infoLog,
    required this.master,
    Key? key,
  }) : super(key: key);

  @override
  _PembelianSuplyerState createState() => _PembelianSuplyerState();
}

class _PembelianSuplyerState extends State<PembelianSuplyer> {
  // Update Header agar label lebih jelas
  final List<DatatableHeader> _headers = [
    DatatableHeader(
      text: "#",
      value: "no",
      show: true,
      flex: 1,
      sortable: true,
      listAlign: TextAlign.center,
      textAlign: TextAlign.center,
    ),
    DatatableHeader(
      text: "Kode",
      value: "kode",
      show: true,
      flex: 2,
      sortable: true,
      editable: false,
      listAlign: TextAlign.left,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: "Nama Supplier", // Update Label
      value: "nama_supplier", // Sesuaikan dengan key JSON dari backend (jika ada), atau tetap 'suplyer'
      show: true,
      flex: 3,
      sortable: true,
      editable: false,
      listAlign: TextAlign.left,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: "Nama Produk", // Tambahan kolom Produk agar jelas
      value: "nama_produk", // Sesuaikan dengan key JSON
      show: true,
      flex: 3,
      sortable: true,
      editable: false,
      listAlign: TextAlign.left,
      textAlign: TextAlign.left,
    ),
    DatatableHeader(
      text: "Qty",
      value: "qty",
      show: true,
      flex: 1,
      sortable: true,
      editable: false,
      listAlign: TextAlign.right,
      textAlign: TextAlign.right,
    ),
    DatatableHeader(
      text: "Harga",
      value: "harga",
      show: true,
      flex: 2,
      sortable: true,
      editable: false,
      listAlign: TextAlign.right,
      textAlign: TextAlign.right,
    ),
    DatatableHeader(
      text: "Total",
      value: "total",
      show: true,
      flex: 2,
      sortable: true,
      editable: false,
      listAlign: TextAlign.right,
      textAlign: TextAlign.right,
    ),
  ];

  final List<int> _perPages = [5, 10, 20, 50];
  int _total = 0;
  int _currentPerPage = 10;
  List<bool>? _expanded;
  String _searchKey = "nama_supplier"; // Default search key
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

  var random = math.Random();

  final TextEditingController _contgl = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // master dipakai untuk form Add/Edit (dropdown Suplyer)
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
        // opsional: start/length/search kalau backend butuh
      },
    );

    if (res.success) {
      bool sukses = res.data["Sukses"] == "Y";
      String pesan = res.data["Pesan"] ?? "";

      List<Map<String, dynamic>> rows =
          List<Map<String, dynamic>>.from(res.data["rows"] ?? []);

      int no = 1;
      for (var r in rows) {
        r["no"] = no++;
        // Pastikan key untuk tampilan tabel ada
        // Jika backend mengirim key 'suplyer', mapping ke 'nama_supplier' juga agar aman
        if (r["nama_supplier"] == null && r["suplyer"] != null) {
          r["nama_supplier"] = r["suplyer"];
        }
        if (r["nama_produk"] == null && r["nama"] != null) {
          r["nama_produk"] = r["nama"]; // Mapping dari field 'nama' produk
        }
      }

      if (sukses) {
        // ========= UPDATE MASTER DARI API JIKA ADA =========
        final dynamic masterFromApi = res.data["master"];

        if (masterFromApi is Map) {
          final Map<String, dynamic> m =
              Map<String, dynamic>.from(masterFromApi);

          // Hanya overwrite kalau tidak kosong
          if (m.isNotEmpty) {
            _master = m;
          }
        }

        // Kalau masih kosong, fallback ke master global dari widget.master
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

    if (mounted) {
      setState(() => _isLoading = true);
    }

    _sourceOriginal.clear();
    _sourceOriginal.addAll(await _generateData());
    _sourceFiltered = _sourceOriginal;
    _total = _sourceFiltered.length;
    _source = _sourceFiltered
        .getRange(0, _currentPerPage > _total ? _total : _currentPerPage)
        .toList();

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
      _expanded = List.generate(rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      Helper.showSnackBar(context, e.toString());
    }
    setState(() => _isLoading = false);
  }

  // ------------ ADD / DELETE ------------

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

    // Update table
    _mockPullData();
  }

  void _addItem() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PembelianSuplyerAdd(
              // PENTING: pakai _master yang berisi queryAddPembelianSuplyer
              master: _master,
              initialDate: _selectedDate,
            ),
          ),
        )
        .then((value) => _mockPullData());
  }

  void _onTabRow(dynamic data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "${data["kode"] ?? ""} - ${data["nama_supplier"] ?? ""}",
        ),
        content: Table(
          children: [
            TableRow(
              children: [
                const Text("Produk"),
                Text(data["nama_produk"].toString()),
              ],
            ),
            TableRow(
              children: [
                const Text("Qty"),
                Text(data["qty"].toString()),
              ],
            ),
            TableRow(
              children: [
                const Text("Harga"),
                Text(data["harga"].toString()),
              ],
            ),
            TableRow(
              children: [
                const Text("Total"),
                Text(data["total"].toString()),
              ],
            ),
            TableRow(
              children: [
                const Text("Tanggal"),
                Text(data["created"].toString()),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteItem(data);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Icon(
              FontAwesomeIcons.trash,
              size: 18,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(dynamic data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "${data["kode"] ?? ""} - ${data["nama_supplier"] ?? ""}",
        ),
        content: const Text("Hapus transaksi pembelian suplyer ini?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _deleteItemConfirm(data);
              Navigator.of(context).pop();
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

  void _deleteItemConfirm(dynamic data) async {
    setState(() => _loadingDelete = true);

    HttpPostResponse response = await Helper.sendHttpPost(
      urlPembelianSuplyerDelete,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "id": data["id"],
      },
    );

    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      if (sukses) {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.success,
          );
        }
        _mockPullData();
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
          message: response.error,
          details: response.responseBody,
          type: AlertType.error,
        );
      }
    }

    if (mounted) {
      setState(() => _loadingDelete = false);
    }
  }

  // ------------ LIFECYCLE ------------

  @override
  void initState() {
    super.initState();

    // Inisialisasi master dari widget.master (master global menu)
    if (widget.master is Map<String, dynamic>) {
      _master = Map<String, dynamic>.from(widget.master as Map<String, dynamic>);
    }

    _selectDate(_selectedDate);
  }

  @override
  void dispose() {
    _focusSearch.dispose();
    super.dispose();
  }

  // ------------ BUILD ------------

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
            icon: const Icon(
              FontAwesomeIcons.sync,
              size: 18,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tanggal & Tombol Tambah
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
                    suffixIcon: const Icon(
                      FontAwesomeIcons.calendar,
                      size: 18,
                    ),
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
                            'Cari Berdasarkan ${_searchKey.replaceAll(RegExp('[\\W_]+'), ' ').toUpperCase()}',
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
                      onChanged: (value) {
                        _filterData(value);
                      },
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
                setState(() => _isLoading = true);

                setState(() {
                  _sortColumn = value;
                  _sortAscending = !_sortAscending;
                  if (_sortAscending) {
                    _sourceFiltered.sort(
                        (a, b) => b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                  } else {
                    _sourceFiltered.sort(
                        (a, b) => a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                  }
                  var rangeTop = _currentPerPage < _sourceFiltered.length
                      ? _currentPerPage
                      : _sourceFiltered.length;
                  _source = _sourceFiltered.getRange(0, rangeTop).toList();
                  _searchKey = value;

                  _isLoading = false;
                });
              },
              expanded: _expanded,
              sortAscending: _sortAscending,
              sortColumn: _sortColumn,
              isLoading: _isLoading,
              onSelect: (value, item) {
                if (value) {
                  setState(() => _selecteds.add(item));
                } else {
                  setState(
                    () => _selecteds.removeAt(_selecteds.indexOf(item)),
                  );
                }
              },
              onSelectAll: (value) {
                if (value) {
                  setState(() =>
                      _selecteds = _source.map((entry) => entry).toList().cast());
                } else {
                  setState(() => _selecteds.clear());
                }
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
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text("$e"),
                          ),
                        )
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
                    "$_currentPage - ${_currentPage + _currentPerPage - 1} dari $_total",
                  ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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