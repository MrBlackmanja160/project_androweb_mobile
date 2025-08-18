import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/foto_smd_subdetail_add.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/model_foto_smd_item.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/model_jenis_foto_smd.dart';
import 'package:kalbemd/blesscom/widgets/boki_image_network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FotoSMDSubDetail extends StatefulWidget {
  final dynamic infoLog;
  final dynamic master;
  final ModelJenisFotoSMD masterSub;
  const FotoSMDSubDetail({
    required this.infoLog,
    required this.master,
    required this.masterSub,
    Key? key,
  }) : super(key: key);

  @override
  _FotoSMDSubDetailState createState() => _FotoSMDSubDetailState();
}

class _FotoSMDSubDetailState extends State<FotoSMDSubDetail> {
  List<ModelJenisFotoSMDItem> _data = [];
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
      urlFotoActivitySMDDetailSub,
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
          _data.add(ModelJenisFotoSMDItem(
            id: row["id"],
            tempid: row["temp_id"],
            idjenisphoto: row["idjenisphoto"],
            foto: row["foto"],
            remark: row["remark"],
            lokasi: row["lokasi"],
            lokasidisplay: row["lokasidisplay"],
            brand: row["brand"],
            produk: row["produk"],
            qty: row["qty"],
            idlokasi: row["idlokasi"],
            idbrand: row["idbrand"],
            idproduk: row["idproduk"],
            keterangan: row["keterangan"],
            idketerangan: row["idketerangan"],
            idkelompoknds: row["idkelompoknds"],
            idjenisnds: row["idjenisnds"],
            kelompoknds: row["kelompoknds"],
            jenisnds: row["jenisnds"],
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

  void _addItem({ModelJenisFotoSMDItem? item}) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FotoSMDSubdetailAdd(
              item: item,
              masterSub: widget.masterSub,
              queryLokasiDisplay: widget.infoLog["infoLog"]["query_lokasi_display"],
              queryBrandProduk: widget.infoLog["infoLog"]["query_brand_produk"],
              queryProduk: widget.infoLog["infoLog"]["query_add_produkkalbe"],
              queryKeterangan: widget.infoLog["infoLog"]["query_keterangan"],
              queryKelompokNds: widget.infoLog["infoLog"]["query_kelompoknds"],
              queryJenisNds: widget.infoLog["infoLog"]["query_jenisnds"],
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
    // return Container(
    //   width: double.infinity,
    //   padding: const EdgeInsets.symmetric(horizontal: 10),
    //   child: Column(children: [
    //     if (_data.isEmpty) const Text("Tidak ada data"),
    //     ...List.generate(
    //       _data.length,
    //       (index) => Card(
    //         child: InkWell(
    //           onTap: _editable
    //               ? () => _addItem(
    //                     item: _data[index],
    //                   )
    //               : null,
    //           child: Padding(
    //             padding: const EdgeInsets.all(16),
    //             child: Row(
    //               children: [
    //                 BokiImageNetwork(
    //                   url:
    //                       "$baseURL/assets/images/lampiran/${_data[index].foto}",
    //                   width: 56,
    //                 ),
    //                 Expanded(
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(left: 16),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             Icon(
    //                               FontAwesomeIcons.boxes,
    //                               size: 16,
    //                               color: Theme.of(context).primaryColor,
    //                             ),
    //                             Expanded(
    //                               child: Padding(
    //                                 padding: const EdgeInsets.only(left: 8),
    //                                 child: Text(
    //                                   _data[index].lokasidisplay,
    //                                   style: textStyleBold,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         const Divider(),
    //                         Text(
    //                           _data[index].brand,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     if (_editable)
    //       SizedBox(
    //         width: double.infinity,
    //         child: OutlinedButton(
    //           onPressed: () => _addItem(),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: const [
    //               Icon(
    //                 FontAwesomeIcons.plus,
    //                 size: 16,
    //               ),
    //               SizedBox(width: 8),
    //               Text("Tambah Foto"),
    //             ],
    //           ),
    //         ),
    //       ),
    //     const SizedBox(
    //       height: 16,
    //     ),
    //   ]),
    // );

   return Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 10),
  child: Column(
    children: [
      if (_data.isEmpty)
        const Text("Tidak ada data"),
      ...List.generate(
        _data.length,
        (index) => Card(
          elevation: 4, // Elevasi untuk memberikan efek bayangan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Membuat sudut lebih halus
          ),
          child: InkWell(
            onTap: _editable
                ? () => _addItem(
                      item: _data[index],
                    )
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar di sebelah kiri
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Rounded corners untuk gambar
                    child: BokiImageNetwork(
                      url: "$baseURL/assets/images/lampiran/${_data[index].foto}",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Keterangan di sebelah kanan gambar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lokasi Display dengan ikon
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _data[index].lokasidisplay,
                              style: textStyleBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(), // Pemisah antar informasi
                        // Brand dengan ikon
                        Row(
                          children: [
                            Icon(
                              Icons.label,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _data[index].brand,
                              style: textStyleRegular.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(), // Pemisah antar informasi
                        // Produk dengan ikon
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _data[index].produk,
                              style: textStyleRegular.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(), // Pemisah antar informasi
                        // Stok dengan ikon
                        Row(
                          children: [
                            Icon(
                              Icons.storage,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Stok: ${_data[index].qty}",
                              style: textStyleRegular.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
      const SizedBox(height: 16),
    ],
  ),
);


  }
}
