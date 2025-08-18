import 'dart:math';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/forms/input_date.dart';
import 'package:kalbemd/blesscom/forms/input_dropdown.dart';
import 'package:kalbemd/blesscom/models/model_dropdown.dart';
import 'package:kalbemd/Plugin/Table/data_table_header.dart';
import 'package:kalbemd/Plugin/table_plugin.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:kalbemd/blesscom/widgets/boki_image_network.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class LogActivity extends StatefulWidget {
  const LogActivity({Key? key}) : super(key: key);

  @override
  _LogActivityState createState() => _LogActivityState();
}

class _LogActivityState extends State<LogActivity> {
  final List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "#",
        value: "no",
        show: true,
        flex: 1,
        sortable: true,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Tgl Check In",
        value: "date_check_in",
        show: true,
        flex: 2,
        sortable: true,
        editable: false,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Tgl Check Out",
        value: "date_check_out",
        show: true,
        flex: 2,
        sortable: true,
        editable: false,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Durasi",
        value: "work_duration",
        show: true,
        flex: 1,
        sortable: true,
        editable: false,
        listAlign: TextAlign.center,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Foto Check In",
        value: "foto_check_in",
        show: true,
        flex: 2,
        sortable: true,
        editable: false,
        listAlign: TextAlign.center,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Foto Check Out",
        value: "foto_check_out",
        show: true,
        flex: 2,
        sortable: true,
        editable: false,
        listAlign: TextAlign.center,
        textAlign: TextAlign.center),
  ];

  final List<int> _perPages = [5, 10, 20, 50];
  int _total = 100;
  int _currentPerPage = 10;
  List<bool>? _expanded;
  // ignore: unused_field
  String _searchKey = "distributor";
  // final FocusNode _focusSearch = FocusNode();

  int _currentPage = 1;
  // bool _isSearch = false;
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
  bool _isLoading = false;
  // ignore: unused_field
  final bool _showSelect = true;
  var random = Random();

  DateTime _tglAwal = DateTime.now();
  DateTime _tglAkhir = DateTime.now();
  Map<String, dynamic> _infoAkun = {};

  double _distributorKunjungan = 0;
  double _distributorPembelian = 0;
  double _distributorNominalBeli = 0;

  double _tokoKunjungan = 0;
  double _tokoPenjualan = 0;
  double _tokoNominalJual = 0;
  double _tokoSetorUang = 0;

  // int grandTotal = "";

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

  Future<Iterable<Map<String, dynamic>>> _generateData() async {
    // Request data
    HttpPostResponse response = await Helper.sendHttpPost(
      urlLogActivity,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "tglawal": DateFormat("yyyy-MM-dd").format(_tglAwal),
        "tglakhir": DateFormat("yyyy-MM-dd").format(_tglAkhir),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      // Calculate summary
      _infoAkun = response.data["infoAkun"];

      _distributorKunjungan =
          double.tryParse(_infoAkun["jmlkunjungandistributor"].toString()) ?? 0;
      _distributorPembelian =
          double.tryParse(_infoAkun["jmltransaksibeli"].toString()) ?? 0;
      _distributorNominalBeli =
          double.tryParse(_infoAkun["totalbeli"].toString()) ?? 0;

      _tokoKunjungan =
          double.tryParse(_infoAkun["jmlkunjungantoko"].toString()) ?? 0;
      _tokoPenjualan =
          double.tryParse(_infoAkun["jmltransaksijual"].toString()) ?? 0;
      _tokoNominalJual =
          double.tryParse(_infoAkun["totaljual"].toString()) ?? 0;
      _tokoSetorUang =
          double.tryParse(_infoAkun["jmlsetoruang"].toString()) ?? 0;

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["rows"]);

      // Add numbering
      int no = 1;
      for (var element in data) {
        element["no"] = no++;
      }

      if (sukses) {
        return data;
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

    return [];
  }

  var bodyProgress = Stack(
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
  );

  void _mockPullData() async {
    _expanded = List.generate(_currentPerPage, (index) => false);

    // Calculate grand total
    if (mounted) {
      setState(() => _isLoading = true);
    }

    _sourceOriginal.clear();
    _sourceOriginal.addAll(await _generateData());

    // Convert photos to widget
    for (var elem in _sourceOriginal) {
      var srcIn = elem["foto_check_in"];
      var srcOut = elem["foto_check_out"];
      var status = elem["status"];

      if (status == "I" || status == "C") {
        elem["foto_check_in"] = Card(
          shadowColor: Colors.transparent,
          // child: Image.network(
          //   srcIn,
          //   height: 96,
          //   fit: BoxFit.cover,
          //   errorBuilder: (context, error, stackTrace) => const SizedBox(
          //     height: 96,
          //     child: Icon(
          //       FontAwesomeIcons.unlink,
          //     ),
          //   ),
          // ),
          child: BokiImageNetwork(
            url: srcIn,
            height: 96,
            fit: BoxFit.cover,
          ),
        );
      } else {
        elem["foto_check_in"] = "Belum Check In";
      }

      if (status == "C") {
        elem["foto_check_out"] = Card(
          shadowColor: Colors.transparent,
          // child: Image.network(
          //   srcOut,
          //   height: 96,
          //   fit: BoxFit.cover,
          //   errorBuilder: (context, error, stackTrace) => const SizedBox(
          //     height: 96,
          //     child: Icon(
          //       FontAwesomeIcons.unlink,
          //     ),
          //   ),
          // ),
          child: BokiImageNetwork(
            url: srcIn,
            height: 96,
            fit: BoxFit.cover,
          ),
        );
      } else {
        elem["foto_check_out"] = "Belum Check Out";
      }
    }

    _sourceFiltered = _sourceOriginal;
    _total = _sourceFiltered.length;
    _source = _sourceFiltered
        .getRange(0, _currentPerPage > _total ? _total : _currentPerPage)
        .toList();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  _resetData({start = 0}) async {
    setState(() => _isLoading = true);
    var expandedLen =
        _total - start < _currentPerPage ? _total - start : _currentPerPage;
    Future.delayed(const Duration(seconds: 0)).then((value) {
      _expanded = List.generate(expandedLen.toInt(), (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  // _filterData(value) {
  //   setState(() => _isLoading = true);

  //   try {
  //     if (value == "" || value == null) {
  //       _sourceFiltered = _sourceOriginal;
  //     } else {
  //       _sourceFiltered = _sourceOriginal
  //           .where((data) => data[_searchKey]
  //               .toString()
  //               .toLowerCase()
  //               .contains(value.toString().toLowerCase()))
  //           .toList();
  //     }

  //     _total = _sourceFiltered.length;
  //     var _rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
  //     _expanded = List.generate(_rangeTop, (index) => false);
  //     _source = _sourceFiltered.getRange(0, _rangeTop).toList();
  //   } catch (e) {
  //     Helper.showSnackBar(context, e.toString());
  //   }
  //   setState(() => _isLoading = false);
  // }

  void _selectDate() {
    _mockPullData();
    // print("awal : $_tglAwal, akhir : $_tglAkhir");
  }

  void _onTabRow(dynamic data) {}

  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _selectDate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double fixwidthlayar = width - (width * 6 / 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log Activity",
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () => _selectDate(),
            icon: const Icon(
              FontAwesomeIcons.sync,
              size: 18,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: InputDate(
                      value: _tglAwal,
                      label: "Tanggal Awal",
                      hint: "Tanggal Awal",
                      displayFormat: "d MMM y",
                      onChange: (value) => setState(() {
                        _tglAwal = value ?? _tglAwal;
                        _selectDate();
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InputDate(
                      value: _tglAkhir,
                      label: "Tanggal Akhir",
                      hint: "Tanggal Akhir",
                      displayFormat: "d MMM y",
                      onChange: (value) => setState(() {
                        _tglAkhir = value ?? _tglAkhir;
                        _selectDate();
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Table(
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "Distributor",
                                    style: textStyleBold.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                const SizedBox(),
                                Text(
                                  "Toko",
                                  style: textStyleBold.copyWith(
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text(
                                  "Kunjungan",
                                  style: textStyleBold,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    Helper.formatNumberThousandSeparator(
                                        _distributorKunjungan),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                const Text(
                                  "Kunjungan",
                                  style: textStyleBold,
                                ),
                                Text(
                                  Helper.formatNumberThousandSeparator(
                                      _tokoKunjungan),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text(
                                  "Pembelian",
                                  style: textStyleBold,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    Helper.formatNumberThousandSeparator(
                                        _distributorPembelian),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                const Text(
                                  "Penjualan",
                                  style: textStyleBold,
                                ),
                                Text(
                                  Helper.formatNumberThousandSeparator(
                                      _tokoPenjualan),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text(
                                  "Nominal",
                                  style: textStyleBold,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    Helper.formatNumberThousandSeparator(
                                        _distributorNominalBeli),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                const Text(
                                  "Nominal",
                                  style: textStyleBold,
                                ),
                                Text(
                                  Helper.formatNumberThousandSeparator(
                                      _tokoNominalJual),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const SizedBox(),
                                const SizedBox(),
                                const Text(
                                  "Setor Uang",
                                  style: textStyleBold,
                                ),
                                Text(
                                  Helper.formatNumberThousandSeparator(
                                      _tokoSetorUang),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: Helper.getScreenHeight(context) * (55 / 100),
              child: OkeTable(
                title: null,
                widthtable: 680,
                // actions: [
                //   if (_isSearch)
                //     Expanded(
                //         child: TextField(
                //       focusNode: _focusSearch,
                //       decoration: InputDecoration(
                //           hintText: 'Cari Berdasarkan ' +
                //               _searchKey
                //                   .replaceAll(RegExp('[\\W_]+'), ' ')
                //                   .toUpperCase(),
                //           prefixIcon: IconButton(
                //               icon: const Icon(Icons.cancel),
                //               onPressed: () {
                //                 setState(() {
                //                   _isSearch = false;
                //                   _filterData("");
                //                 });
                //               }),
                //           suffixIcon: IconButton(
                //               icon: const Icon(Icons.search),
                //               onPressed: () {})),
                //       onChanged: (value) {
                //         _filterData(value);
                //       },
                //     )),
                //   if (!_isSearch)
                //     IconButton(
                //         icon: const Icon(Icons.search),
                //         onPressed: () {
                //           setState(() {
                //             _isSearch = true;
                //             _focusSearch.requestFocus();
                //           });
                //         })
                // ],
                headers: _headers,
                source: _source,
                // selecteds: _selecteds,
                // showSelect: _showSelect,
                autoHeight: false,
                dropContainer: _dropContainer,
                onTabRow: _onTabRow,
                onSort: (value) {
                  setState(() => _isLoading = true);

                  setState(() {
                    _sortColumn = value;
                    _sortAscending = !_sortAscending;
                    if (_sortAscending) {
                      _sourceFiltered.sort((a, b) =>
                          b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                    } else {
                      _sourceFiltered.sort((a, b) =>
                          a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                    }
                    // ignore: non_constant_identifier_names
                    var _range_top = _currentPerPage < _sourceFiltered.length
                        ? _currentPerPage
                        : _sourceFiltered.length;
                    _source = _sourceFiltered.getRange(0, _range_top).toList();
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
                        () => _selecteds.removeAt(_selecteds.indexOf(item)));
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
                    child: const Text("Show"),
                  ),
                  // ignore: unnecessary_null_comparison
                  if (_perPages != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              _currentPerPage = int.parse(value.toString());
                              _resetData();
                            });
                          }),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("$_currentPage - " +
                        (_currentPage + _currentPerPage - 1).toString() +
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
                            var _nextSet = _currentPage - _currentPerPage;
                            setState(() {
                              _currentPage = _nextSet > 1 ? _nextSet : 1;
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
                            var _nextSet = _currentPage + _currentPerPage;

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
