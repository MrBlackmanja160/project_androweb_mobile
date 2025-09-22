import 'dart:math';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/forms/input_dropdown.dart';
import 'package:kalbemd/blesscom/models/model_dropdown.dart';
import 'package:kalbemd/Plugin/Table/data_table_header.dart';
import 'package:kalbemd/Plugin/table_plugin.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ReportPenjualanSales extends StatefulWidget {
  final dynamic infoLog;

  const ReportPenjualanSales({required this.infoLog, Key? key})
      : super(key: key);

  @override
  _ReportPenjualanSalesState createState() => _ReportPenjualanSalesState();
}

class _ReportPenjualanSalesState extends State<ReportPenjualanSales> {
  final List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "#",
        value: "no",
        show: true,
        flex: 1,
        sortable: true,
        listAlign: TextAlign.center,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Tanggal",
        value: "tanggal",
        show: true,
        flex: 3,
        sortable: true,
        editable: false,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Toko",
        value: "pelanggan",
        show: true,
        flex: 3,
        sortable: true,
        editable: false,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "Barang",
        value: "barang",
        show: true,
        flex: 4,
        sortable: true,
        editable: false,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
    DatatableHeader(
        text: "Penjualan",
        value: "penjualan",
        show: true,
        flex: 4,
        sortable: true,
        editable: false,
        listAlign: TextAlign.right,
        textAlign: TextAlign.right),
    // DatatableHeader(
    //     text: "%",
    //     value: "pencapaian",
    //     show: true,
    //     flex: 2,
    //     sortable: true,
    //     editable: false,
    //     listAlign: TextAlign.right,
    //     textAlign: TextAlign.right),
  ];

  final List<int> _perPages = [5, 10, 20, 50];
  int _total = 100;
  int _currentPerPage = 10;
  List<bool>? _expanded;
  // ignore: unused_field
  String _searchKey = "nama";
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
  final String _selectableKey = "nama";
  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = false;
  // ignore: unused_field
  final bool _showSelect = true;
  var random = Random();

  final TextEditingController _contgl = TextEditingController();
  // ModelDropdown _selectedBarang = ModelDropdown();
  DateTime _selectedDate = DateTime.now();
  final Map<String, dynamic> _infoBarang = {};

  // double _hargaPerPcs = 0;
  // double _qtySaldoAwal = 0;
  // double _qtyDebet = 0;
  // double _qtyKredit = 0;
  // double _qtySaldoAkhir = 0;

  // double _nominalSaldoAwal = 0;
  // double _nominalDebet = 0;
  // double _nominalKredit = 0;
  // double _nominalSaldoAkhir = 0;

  // int grandTotal = "";

  Widget _dropContainer(data) {
    // ignore: unused_local_variable
    List<Widget> children = data.entries.map<Widget>((entry) {
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
      urlReportPenjualan,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        // "idbarang": _selectedBarang.id,
        "bulan": _selectedDate.month.toString(),
        "tahun": _selectedDate.year.toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      // Calculate summary
      // _infoBarang = response.data["infoBarang"];
      // _hargaPerPcs = double.tryParse(_infoBarang["hargaperpcs"].toString()) ?? 0;

      // _qtySaldoAwal = double.tryParse(_infoBarang["s_awal"].toString()) ?? 0;
      // _qtyDebet = double.tryParse(_infoBarang["debet"].toString()) ?? 0;
      // _qtyKredit = double.tryParse(_infoBarang["kredit"].toString()) ?? 0;
      // _qtySaldoAkhir = double.tryParse(_infoBarang["s_akhir"].toString()) ?? 0;

      // _nominalSaldoAwal = _hargaPerPcs * _qtySaldoAwal;
      // _nominalDebet = _hargaPerPcs * _qtyDebet;
      // _nominalKredit = _hargaPerPcs * _qtyKredit;
      // _nominalSaldoAkhir = _hargaPerPcs * _qtySaldoAkhir;

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

  Future<void> _onTapDate() async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: _selectedDate,
      // //locale: const Locale("id"),
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
        _contgl.text = DateFormat("MMM y").format(_selectedDate);
      });
    }

    // Update table
    // if (_selectedBarang.isEmpty()) {
    //   return;
    // }
    _mockPullData();
  }

  void _onTabRow(dynamic data) {}

  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _selectDate(_selectedDate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fixwidthlayar = width - (width * 6 / 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Penjualan",
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () => _selectDate(_selectedDate),
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
                  // Expanded(
                  //   child: InputDropdown(
                  //     label: "Barang",
                  //     value: _selectedBarang,
                  //     ajaxUrl: urlGetSelectAjax,
                  //     customQuery:
                  //         "select id, nama as text from m_barang a where isdeleted=0",
                  //     hint: "Pilih Barang",
                  //     hintSearch: "Cari Barang",
                  //     onChange: (value) {
                  //       _selectedBarang = value;
                  //       _selectDate(_selectedDate);
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                  Expanded(
                    child: InputText(
                      controller: _contgl,
                      label: "Bulan",
                      readOnly: true,
                      showCursor: false,
                      suffixIcon: const Icon(
                        FontAwesomeIcons.calendar,
                        size: 18,
                      ),
                      onTap: _onTapDate,
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 8,
            //   ),
            //   child: Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(16),
            //       child: _isLoading
            //           ? const Center(
            //               child: Padding(
            //                 padding: EdgeInsets.all(16),
            //                 child: CircularProgressIndicator(),
            //               ),
            //             )
            //           : Table(
            //               children: [
            //                 TableRow(
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.only(bottom: 8),
            //                       child: Text(
            //                         "Ket",
            //                         style: textStyleBold.copyWith(
            //                             color: Theme.of(context).primaryColor),
            //                       ),
            //                     ),
            //                     Text(
            //                       "Qty",
            //                       style: textStyleBold.copyWith(
            //                           color: Theme.of(context).primaryColor),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                     Text(
            //                       "Nominal",
            //                       style: textStyleBold.copyWith(
            //                           color: Theme.of(context).primaryColor),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                   ],
            //                 ),
            //                 TableRow(
            //                   children: [
            //                     const Text(
            //                       "Saldo Awal",
            //                       style: textStyleBold,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _qtySaldoAwal),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _nominalSaldoAwal),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                   ],
            //                 ),
            //                 TableRow(
            //                   children: [
            //                     const Text(
            //                       "Debet",
            //                       style: textStyleBold,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _qtyDebet),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _nominalDebet),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                   ],
            //                 ),
            //                 TableRow(
            //                   children: [
            //                     const Text(
            //                       "Kredit",
            //                       style: textStyleBold,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _qtyKredit),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _nominalKredit),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                   ],
            //                 ),
            //                 TableRow(
            //                   children: [
            //                     const Text(
            //                       "Saldo Akhir",
            //                       style: textStyleBold,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _qtySaldoAkhir),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                     Text(
            //                       Helper.formatNumberThousandSeparator(
            //                           _nominalSaldoAkhir),
            //                       textAlign: TextAlign.end,
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: Helper.getScreenHeight(context) * (55 / 100),
              child: OkeTable(
                title: null,
                widthtable: fixwidthlayar,
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
                    var range_top = _currentPerPage < _sourceFiltered.length
                        ? _currentPerPage
                        : _sourceFiltered.length;
                    _source = _sourceFiltered.getRange(0, range_top).toList();
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
                                    value: e,
                                    child: Text("$e"),
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
                    child: Text(
                        "$_currentPage - ${_currentPage + _currentPerPage - 1} dari $_total"),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
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
                            var nextSet = _currentPage + _currentPerPage;

                            setState(() {
                              _currentPage = nextSet < _total
                                  ? nextSet
                                  : _total - _currentPerPage;
                              _resetData(start: nextSet - 1);
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
