import 'dart:math';
import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Plugin/Table/data_table_header.dart';
import 'package:kalbemd/Plugin/table_plugin.dart';
import 'package:kalbemd/Theme/colors.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'input_pkm_explore.dart';

class InputPkm extends StatefulWidget {
  final dynamic infoLog;
  const InputPkm({
    required this.infoLog,
    Key? key,
  }) : super(key: key);

  @override
  _InputPkmState createState() => _InputPkmState();
}

class _InputPkmState extends State<InputPkm> {
  bool _editable = false;
  final List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "#",
        value: "no",
        show: true,
        flex: 1,
        sortable: true,
        listAlign: TextAlign.center,
        textAlign: TextAlign.center),
    // DatatableHeader(
    //     text: "Nobukti",
    //     value: "nobukti",
    //     show: true,
    //     flex: 2,
    //     sortable: true,
    //     editable: false,
    //     listAlign: TextAlign.left,
    //     textAlign: TextAlign.left),
    DatatableHeader(
        text: "Tanggal",
        value: "tanggal",
        show: true,
        flex: 3,
        sortable: true,
        editable: false,
        listAlign: TextAlign.center,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Toko",
        value: "pelanggan",
        show: true,
        flex: 3,
        sortable: true,
        editable: false,
        listAlign: TextAlign.left,
        textAlign: TextAlign.left),
    // DatatableHeader(
    //     text: "Total",
    //     value: "grandtotal",
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
  String _searchKey = "distributor";
  final FocusNode _focusSearch = FocusNode();

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

  final TextEditingController _contgl = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool _loadingAdd = false;

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
      urlInputPkm,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "bulan": _selectedDate.month.toString(),
        "tahun": _selectedDate.year.toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["rows"]);

      // Add numbering
      int no = 1;
      for (var element in data) {
        bool statusOpen = element["status"] == "O";

        element["no"] = Container(
          decoration: BoxDecoration(
            color: statusOpen ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            (no++).toString(),
            textAlign: _headers
                .firstWhere((element) => element.value == "no")
                .textAlign,
          ),
        );
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
    // getDataInputPkm();
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
      Helper.showSnackBar(context, e.toString());
    }
    setState(() => _isLoading = false);
  }

  Future<void> _onTapDate() async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: _selectedDate,
      //locale: const Locale("id"),
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

  void _onTabRow(dynamic data) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputPkmExplore(
              infoLog: widget.infoLog,
              master: data,
            ),
          ),
        )
        .then((value) => _selectDate(_selectedDate));
  }

  void _addItem() async {
    String tanggal = DateFormat("d MMM y").format(DateTime.now());

    // Add data dialog
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Tambah Bukti InputPkm"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                Table(
                  children: [
                    TableRow(
                      children: [
                        const Text("Tanggal"),
                        Text(tanggal),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text("Toko"),
                        Text(widget.infoLog["namaToko"]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _addItemConfirm(tanggal, widget.infoLog["namaToko"]);
                  Navigator.of(context).pop();
                },
                child: const Text("Tambah"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).disabledColor),
                ),
              ),
            ],
          );
        });
  }

  void _addItemConfirm(String tanggal, String pelanggan) async {
    if (mounted) {
      setState(() {
        _loadingAdd = true;
      });
    }

    // Get temp_id
    HttpPostResponse response = await Helper.sendHttpPost(
      urlInputPkmAdd,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "action": "add",
        "mode": "simpan",
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
              onClose: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => InputPkmExplore(
                          infoLog: widget.infoLog,
                          master: {
                            "nobukti": response.data["Nobukti"],
                            "tanggal": tanggal,
                            "pelanggan": pelanggan,
                            "id": response.data["idmaster"],
                            "temp_id": response.data["temp_id"],
                            "status": response.data["Status"],
                            "grandtotal": response.data["data"]["grandtotal"],
                          },
                        ),
                      ),
                    )
                    .then((value) => _selectDate(_selectedDate));
              });
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
      setState(() {
        _loadingAdd = false;
      });
    }

    _selectDate(_selectedDate);
  }

  // ------------------
  // BUILD
  // ------------------

  @override
  void initState() {
    super.initState();
    _selectDate(_selectedDate);
    _editable = widget.infoLog["status_check_in"] == "Y" &&
        widget.infoLog["typeToko"] == "TOKO";
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
          "Input PKM",
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
      body: Column(
        children: <Widget>[
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
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    onPressed: !_loadingAdd && _editable ? _addItem : null,
                  ),
                ),
              ),
            ],
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
                      focusNode: _focusSearch,
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
                      onChanged: (value) {
                        _filterData(value);
                      },
                    )),
                  if (!_isSearch)
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearch = true;
                            _focusSearch.requestFocus();
                          });
                        })
                ],
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
          ),
          const Divider(),
        ],
      ),
    );
  }
}
