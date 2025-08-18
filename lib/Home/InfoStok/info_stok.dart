// ignore_for_file: avoid_print
import 'dart:math';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Plugin/Table/data_table_header.dart';
import 'package:kalbemd/Plugin/table_plugin.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoStok extends StatefulWidget {
  const InfoStok({Key? key}) : super(key: key);

  @override
  _InfoStokState createState() => _InfoStokState();
}

class _InfoStokState extends State<InfoStok> {
  // ignore: prefer_final_fields
  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "No",
        value: "no",
        show: true,
        flex: 1,
        sortable: true,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Nama Barang",
        value: "barang",
        show: true,
        flex: 3,
        sortable: true,
        editable: false,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Total",
        value: "total",
        show: true,
        flex: 2,
        sortable: true,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
  ];

  Widget _dropContainer(data) {
    // ignore: unused_local_variable
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          const Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();
    // ignore: avoid_unnecessary_containers
    return Container(
      // height: 100,
      child: Column(
          // children: [
          //   Expanded(
          //       child: Container(
          //     color: Colors.red,
          //     height: 50,
          //   )),

          // ],
          // children: _children,
          ),
    );
  }

  final List<int> _perPages = [5, 10, 20, 50];
  int _total = 100;
  final int _currentPerPage = 10;
  List<bool>? _expanded;
  String _searchKey = "nama barang";

  int _currentPage = 1;
  bool _isSearch = false;
  // ignore: deprecated_member_use, prefer_final_fields
  List<Map<String, dynamic>> _sourceOriginal = <Map<String, dynamic>>[];
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> _sourceFiltered = <Map<String, dynamic>>[];
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> _source = <Map<String, dynamic>>[];
  // ignore: deprecated_member_use
  List<Map<String, dynamic>> _selecteds = <Map<String, dynamic>>[];
  // ignore: unused_field
  final String? _selectableKey = "namalengkap";
  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  // ignore: unused_field
  final bool _showSelect = true;
  var random = Random();

  String iddivisi = "";
  String divisi = "";
  String iduser = "";
  String tempid = "";
  TextEditingController contgl = TextEditingController();

  List<Map<String, dynamic>> _generateData({int n = 100}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = 1;
    print(i);
    // ignore: unused_local_variable
    for (var data in source) {
      temps.add({
        "no": i,
        // ignore: unnecessary_string_escapes
        "barang": "Barangku",
        "total": "200",
      });
      i++;
    }
    return temps;
  }

  DateTime selectedDate = DateTime.now();

  String tanggalsekarang = "";
  Future<Widget>? tanggal(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedDateShow = DateFormat('d MMMM y').format(selectedDate);
    setState(() {
      tanggalsekarang = formattedDate;
      contgl.text = formattedDateShow;
    });
  }

  bool onprogres = false;

  String grandTotal = "";

  // ignore: avoid_unnecessary_containers
  var bodyProgress = Container(
    child: Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: warnautama, //,Colors.orange[200],
                borderRadius: BorderRadius.circular(10.0)),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: const Center(
                    child: Text(
                      "Loading.. tunggu...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  // ignore: unused_element
  _initData() async {
    _mockPullData();
  }

  _mockPullData() async {
    // getDataPenjualan();
    _expanded = List.generate(_currentPerPage, (index) => false);

    // Calculate grand total
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 0)).then((value) {
      // modeldatapenjualanUpdate.clear();
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData());
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      // _source =
      //     _sourceFiltered.getRange(0, modeldatapenjualanUpdate.length).toList();
      _source = _sourceFiltered
          .getRange(0, _currentPerPage > _total ? _total : _currentPerPage)
          .toList();

      setState(() => _isLoading = false);
    });
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    // ignore: non_constant_identifier_names
    var _expanded_len =
        _total - start < _currentPerPage ? _total - start : _currentPerPage;
    Future.delayed(const Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expanded_len.toInt(), (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expanded_len).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
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
      var _rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    tanggal(context);
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1945, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        // var hasil = DateFormat('dd-MM-yyyy').format(picked);
        var hasil = DateFormat('yyyy-MM-dd').format(picked);
        var hasilShow = DateFormat('d MMMM y').format(picked);
        contgl.text = hasilShow;
        selectedDate = picked;

        print("iki selected Date" + hasil.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double fixwidthlayar = width - (width * 6 / 100);
    print("Lebar Layar " + width.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Helper.createAppBar(title: "Info Stok", actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: () {})
      ]),
      body: WillPopScope(
        onWillPop: () async => false,
        child: (onprogres)
            ? bodyProgress
            : Column(
                children: <Widget>[
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                              padding: const EdgeInsets.only(
                                  right: 5, left: 15, bottom: 5, top: 5),
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                borderRadius: BorderRadius.circular(5),
                                child: IgnorePointer(
                                    child: Helper.formdate(
                                        contgl,
                                        "Tanggal Periode",
                                        FontAwesomeIcons.calendar,
                                        borderRadius: 5)),
                              )
                              // HelperTanggal("Tanggal Periode", "Y",
                              //     "tglpembelian", contgl),
                              ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 5, top: 5, bottom: 5),
                            height: 50,
                            // ignore: deprecated_member_use
                            child: Helper.createIconButton(
                                FontAwesomeIcons.plus, () {},
                                borderRadius: 5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: OkeTable(
                        title: null,
                        widthtable: fixwidthlayar,
                        actions: [
                          if (_isSearch)
                            Expanded(
                                child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Cari Berdasarkan ' +
                                      _searchKey
                                          .replaceAll(RegExp('[\\W_]+'), ' ')
                                          .toUpperCase(),
                                  prefixIcon: IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          _isSearch = false;
                                          _filterData("");
                                        });
                                      }),
                                  suffixIcon: IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {})),
                              onSubmitted: (value) {
                                _filterData(value);
                              },
                            )),
                          if (!_isSearch)
                            IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = true;
                                  });
                                })
                        ],
                        headers: _headers,
                        source: _source,
                        // selecteds: _selecteds,
                        // showSelect: _showSelect,
                        autoHeight: false,
                        dropContainer: _dropContainer,
                        onTabRow: (data) {},
                        onSort: (value) {
                          setState(() => _isLoading = true);

                          setState(() {
                            _sortColumn = value;
                            _sortAscending = !_sortAscending;
                            if (_sortAscending) {
                              _sourceFiltered.sort((a, b) => b["$_sortColumn"]
                                  .compareTo(a["$_sortColumn"]));
                            } else {
                              _sourceFiltered.sort((a, b) => a["$_sortColumn"]
                                  .compareTo(b["$_sortColumn"]));
                            }
                            // ignore: non_constant_identifier_names
                            var _range_top =
                                _currentPerPage < _sourceFiltered.length
                                    ? _currentPerPage
                                    : _sourceFiltered.length;
                            _source = _sourceFiltered
                                .getRange(0, _range_top)
                                .toList();
                            _searchKey = value;

                            _isLoading = false;
                          });
                        },
                        expanded: _expanded,
                        sortAscending: _sortAscending,
                        sortColumn: _sortColumn,
                        isLoading: _isLoading,
                        onSelect: (value, item) {
                          print("$value  $item ");
                          if (value) {
                            setState(() => _selecteds.add(item));
                          } else {
                            setState(() =>
                                _selecteds.removeAt(_selecteds.indexOf(item)));
                          }
                        },
                        onSelectAll: (value) {
                          if (value) {
                            setState(() => _selecteds =
                                _source.map((entry) => entry).toList().cast());
                          } else {
                            setState(() => _selecteds.clear());
                          }
                        },
                        footers: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text("Tampil:"),
                          ),
                          // ignore: unnecessary_null_comparison
                          if (_perPages != null)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton(
                                  value: _currentPerPage,
                                  items: _perPages
                                      .map((e) => DropdownMenuItem(
                                            child: Text("$e"),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      // _currentPerPage = value;
                                      _currentPage = 1;
                                      _resetData();
                                    });
                                  }),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("$_currentPage - " +
                                (_currentPage + _currentPerPage - 1)
                                    .toString() +
                                " dari $_total"),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                            ),
                            onPressed: _currentPage == 1
                                ? null
                                : () {
                                    var _nextSet =
                                        _currentPage - _currentPerPage;
                                    setState(() {
                                      _currentPage =
                                          _nextSet > 1 ? _nextSet : 1;
                                      _resetData(start: _currentPage - 1);
                                    });
                                  },
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed:
                                _currentPage + _currentPerPage - 1 > _total
                                    ? null
                                    : () {
                                        var _nextSet =
                                            _currentPage + _currentPerPage;

                                        setState(() {
                                          _currentPage = _nextSet < _total
                                              ? _nextSet
                                              : _total - _currentPerPage;
                                          _resetData(start: _nextSet - 1);
                                        });
                                      },
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 20),
                  //   child: Row(
                  //     children: [
                  //       const Expanded(
                  //         child: Center(
                  //           child: Text(
                  //             "Grand Total",
                  //             style: textStyleMediumBold,
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Center(
                  //           child: Container(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 20, vertical: 5),
                  //             decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(360),
                  //                 color: warnakedua),
                  //             child: Text(
                  //               "Rp." + grandTotal,
                  //               style: textStyleMediumBoldInvert,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
