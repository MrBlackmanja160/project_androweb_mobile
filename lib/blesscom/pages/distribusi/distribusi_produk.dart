import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/widgets/labeled_text.dart';
import 'package:kalbemd/blesscom/widgets/loading_small.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DistribusiProduk extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;

  const DistribusiProduk({
    required this.infoLog,
    required this.master,
    Key? key,
  }) : super(key: key);

  @override
  _DistribusiProdukState createState() => _DistribusiProdukState();
}

class _DistribusiProdukState extends State<DistribusiProduk> {
  bool _editable = false;
  bool _loading = true;
  bool _loadingPosting = false;
  List<Map<String, dynamic>> _data = [];
  final EdgeInsets _cardPadding = const EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );

  Future<List<Map<String, dynamic>>> _getKompetitor() async {
    // Request data
    HttpPostResponse response = await Helper.sendHttpPost(
      urlDistribusiProdukKompetitorList,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["rows"]);

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

  Future<List<Map<String, dynamic>>> _getDistribusiValues() async {
    // Request data
    HttpPostResponse response = await Helper.sendHttpPost(
      urlDistribusiProdukDetail,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "temp_id": widget.master["temp_id"].toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["rows"]);

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

  void _posting() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Posting Data?"),
        content: const Text(
            "Pastikan Data sudah Betul, setelah Posting data tidak bisa diedit ?!"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _postingConfirm();
              Navigator.of(context).pop();
            },
            child: const Text("Ya"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  void _postingConfirm() async {
    setState(() {
      _loadingPosting = true;
    });

    // POST data
    var postData = {
      "iduser": await Helper.getPrefs("iduser"),
      "token": await Helper.getPrefs("token"),
      "action": "edit",
      "mode": "posting",
      "temp_id": widget.master["temp_id"].toString(),
    };

    _data.asMap().forEach((key, data) {
      String id = data["id"];
      // Product
      if (_getCheckedProduct(key)) {
        postData.addAll({"product_$id": ""});
      }

      // Kompetitor
      for (var i = 0; i < 5; i++) {
        if (_getCheckedKompetitor(key, i)) {
          postData.addAll({"competitor${i + 1}_$id": ""});
        }
      }
    });

    HttpPostResponse response = await Helper.sendHttpPost(
      urlDistribusiProdukAdd,
      postData: postData,
    );

    // Response
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

        widget.master["status"] = "C";

        // Refresh
        _init();
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
        _loadingPosting = false;
      });
    }
  }

  void _init() async {
    _editable = widget.infoLog["status_check_in"] == "Y" &&
        widget.infoLog["typeToko"] == "TOKO" &&
        widget.master["status"] == "O";

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    _data.clear();

    // Requests
    _data = await _getKompetitor();
    List<Map<String, dynamic>> values = await _getDistribusiValues();

    // Set values
    for (var d in _data) {
      String id = d["id"].toString();
      // Default values, convert to bool
      d["yt_product"] = false;
      d["yt_competitor1"] = false;
      d["yt_competitor2"] = false;
      d["yt_competitor3"] = false;
      d["yt_competitor4"] = false;
      d["yt_competitor5"] = false;

      for (var val in values) {
        String idBarang = val["idbarang"].toString();
        if (id == idBarang) {
          // Set checked values
          d["yt_product"] = val["yt_product"].toString() == "Y";
          d["yt_competitor1"] = val["yt_competitor1"].toString() == "Y";
          d["yt_competitor2"] = val["yt_competitor2"].toString() == "Y";
          d["yt_competitor3"] = val["yt_competitor3"].toString() == "Y";
          d["yt_competitor4"] = val["yt_competitor4"].toString() == "Y";
          d["yt_competitor5"] = val["yt_competitor5"].toString() == "Y";
        }
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _deleteMaster() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.master["nobukti"]),
        content: const Text("Yakin Hapus Bukti Distribusi Produk?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _deleteMasterConfirm();
              Navigator.of(context).pop();
            },
            child: const Text("Ya"),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tidak"),
          ),
        ],
      ),
    );
  }

  void _deleteMasterConfirm() async {
    HttpPostResponse response = await Helper.sendHttpPost(
      urlDistribusiProdukDelete,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "id": widget.master["id"].toString(),
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      if (sukses) {
        if (mounted) {
          Helper.showAlert(
            context: context,
            message: pesan,
            type: AlertType.success,
            onClose: () => Navigator.of(context).pop(),
          );
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
  }

  bool _getCheckedProduct(int indexTab) {
    return _data[indexTab]["yt_product"];
  }

  bool _getCheckedKompetitor(int indexTab, int indexList) {
    return _data[indexTab]["yt_competitor${indexList + 1}"];
  }

  void _onCheckBoxProdukTap(int indexTab) {
    if (!_editable) {
      return;
    }

    _data[indexTab]["yt_product"] = !_data[indexTab]["yt_product"];
    setState(() {});
  }

  void _onCheckBoxKompetitorTap(int indexTab, int indexList) {
    if (!_editable) {
      return;
    }

    _data[indexTab]["yt_competitor${indexList + 1}"] =
        !_data[indexTab]["yt_competitor${indexList + 1}"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    String status = "";
    Color statusColor = Colors.red;
    switch (widget.master["status"]) {
      case "O":
        statusColor = Colors.red;
        status = "Status : Open";
        break;
      case "C":
        statusColor = Colors.green;
        status = "Status : Close";
        break;
    }

    return DefaultTabController(
      length: _data.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Distribusi Produk",
          ),
          actions: [
            IconButton(
              onPressed: _editable && !_loadingPosting ? _deleteMaster : null,
              icon: const Icon(
                FontAwesomeIcons.trash,
                size: 18,
              ),
            ),
            IconButton(
              onPressed: _loading ? null : _init,
              icon: const Icon(
                FontAwesomeIcons.sync,
                size: 18,
              ),
            ),
          ],
          // bottom: !_loading
          //     ? PreferredSize(
          //         preferredSize: AppBar().preferredSize,
          //         child: Container(
          //           color: Theme.of(context).cardColor,
          //           child: TabBar(
          //             tabs: List.generate(
          //               _data.length,
          //               (index) => Tab(
          //                 child: Text(_data[index]["nama"]),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : null,
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 36,
                            color: statusColor,
                            child: Center(
                                child: Text(
                              status,
                              style: textStyleBold,
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    LabeledText(
                                      title: "No Bukti",
                                      description:
                                          widget.master["nobukti"].toString(),
                                    ),
                                    LabeledText(
                                      title: "Tanggal",
                                      description:
                                          widget.master["tanggal"].toString(),
                                    ),
                                  ],
                                ),
                                const TableRow(children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TabBar(
                    tabs: List.generate(
                      _data.length,
                      (index) => Tab(
                        child: Text(_data[index]["nama"]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(
                          _data.length,
                          (indexTab) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 16, 8, 8),
                                            child: Text(
                                              "Produk",
                                              style: textStyleMediumBold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Card(
                                              child: InkWell(
                                                onTap: () =>
                                                    _onCheckBoxProdukTap(
                                                        indexTab),
                                                child: Padding(
                                                  padding: _cardPadding,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .boxOpen,
                                                        size: 18,
                                                        color: _data[indexTab]
                                                                ["yt_product"]
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Theme.of(context)
                                                                .disabledColor,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16),
                                                          child: Text(
                                                              _data[indexTab]
                                                                  ["nama"]),
                                                        ),
                                                      ),
                                                      IgnorePointer(
                                                        child: Checkbox(
                                                          value:
                                                              _getCheckedProduct(
                                                                  indexTab),
                                                          onChanged: (value) {},
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 16, 8, 8),
                                            child: Text(
                                              "Kompetitor",
                                              style: textStyleMediumBold,
                                            ),
                                          ),
                                          ...List.generate(
                                            5,
                                            (indexList) => Card(
                                              child: InkWell(
                                                onTap: () =>
                                                    _onCheckBoxKompetitorTap(
                                                        indexTab, indexList),
                                                child: Padding(
                                                  padding: _cardPadding,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.boxes,
                                                        size: 18,
                                                        color: _getCheckedKompetitor(
                                                                indexTab,
                                                                indexList)
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Theme.of(context)
                                                                .disabledColor,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16),
                                                          child: Text(_data[
                                                                      indexTab][
                                                                  "competitor${indexList + 1}"]
                                                              .toString()),
                                                        ),
                                                      ),
                                                      IgnorePointer(
                                                        child: Checkbox(
                                                          value:
                                                              _getCheckedKompetitor(
                                                                  indexTab,
                                                                  indexList),
                                                          onChanged: (value) {},
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: Material(
          child: Ink(
            color: _editable && !_loadingPosting
                ? Colors.red
                : Theme.of(context).disabledColor,
            child: InkWell(
              onTap: _editable && !_loadingPosting ? _posting : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _loadingPosting
                    ? const LoadingSmall()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            FontAwesomeIcons.save,
                            size: 18,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "POSTING",
                            style: textStyleBold,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
