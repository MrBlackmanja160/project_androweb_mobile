import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/pages/input_promo/input_promo_subdetail_add.dart';
import 'package:kalbemd/blesscom/pages/input_promo/model_input_promo_item.dart';
import 'package:kalbemd/blesscom/pages/input_promo/model_jenis_input_promo.dart';
import 'package:kalbemd/blesscom/widgets/boki_image_network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputPromoSubDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;
  final ModelJenisInputPromo masterSub;
  const InputPromoSubDetail({
    required this.infoLog,
    required this.master,
    required this.masterSub,
    Key? key,
  }) : super(key: key);

  @override
  _InputPromoSubDetailState createState() => _InputPromoSubDetailState();
}

class _InputPromoSubDetailState extends State<InputPromoSubDetail> {
  List<ModelJenisInputPromoItem> _data = [];
  bool _loading = false;
  bool _editable = false;

  void _pullData() async {
    _editable = widget.infoLog["status_check_in"] == "Y" &&
        widget.infoLog["typeToko"] == "TOKO" &&
        widget.master["status"] == "O";

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Request data
    HttpPostResponse response = await Helper.sendHttpPost(
      urlInputPromoDetailSub,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "temp_id": widget.masterSub.tempid.toString(),
        "idjenisphoto": widget.masterSub.idjenisfoto,
      },
    );

    // Response
    if (response.success) {
      bool sukses = response.data["Sukses"] == "Y";
      String pesan = response.data["Pesan"];

      if (sukses) {
        _data.clear();
        for (var row in response.data["rows"]) {
          _data.add(ModelJenisInputPromoItem(
            id: row["id"],
            tempid: row["temp_id"],
            idjenisphoto: row["idjenisphoto"],
            foto: row["foto"],
            ket: row["ket"],
          ));
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
        _loading = false;
      });
    }
  }

  void _addItem({ModelJenisInputPromoItem? item}) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputPromoSubdetailAdd(
              item: item,
              masterSub: widget.masterSub,
            ),
          ),
        )
        .then((value) => _pullData());
  }

  @override
  void initState() {
    super.initState();
    _pullData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LinearProgressIndicator();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        if (_data.isEmpty) const Text("Tidak ada data"),
        ...List.generate(
          _data.length,
          (index) => Card(
            child: InkWell(
              onTap: _editable
                  ? () => _addItem(
                        item: _data[index],
                      )
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Image.network(
                    //   "$baseURL/assets/images/lampiran/${_data[index].foto}",
                    //   fit: BoxFit.cover,
                    //   width: 56,
                    //   errorBuilder: (context, error, stackTrace) =>
                    //       const SizedBox(
                    //     width: 56,
                    //     height: 56,
                    //     child: Center(
                    //       child: Icon(
                    //         FontAwesomeIcons.unlink,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    BokiImageNetwork(
                      url:
                          "$baseURL/assets/images/lampiran/${_data[index].foto}",
                      width: 56,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Icon(
                                //   FontAwesomeIcons.boxes,
                                //   size: 16,
                                //   color: Theme.of(context).primaryColor,
                                // ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Ket : " + _data[index].ket,
                                      style: textStyleBold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const Divider(),
                            // Text(
                            //   _data[index].remark,
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_editable)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _addItem(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.plus,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text("Tambah Foto"),
                ],
              ),
            ),
          ),
        const SizedBox(
          height: 16,
        ),
      ]),
    );
  }
}
