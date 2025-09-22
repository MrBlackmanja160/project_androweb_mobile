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
  final String? queryFotoRakNdb;
  final String? queryKeteranganRakNdb;

  const FotoSMDSubDetail({
    required this.infoLog,
    required this.master,
    required this.masterSub,
    this.queryFotoRakNdb,
    this.queryKeteranganRakNdb,
    Key? key,
  }) : super(key: key);

  @override
  _FotoSMDSubDetailState createState() => _FotoSMDSubDetailState();
}

class _FotoSMDSubDetailState extends State<FotoSMDSubDetail> {
  final List<ModelJenisFotoSMDItem> _data = [];
  bool _loading = false;
  bool _editable = false;

  void _pullData() async {
    _editable = widget.infoLog["status_check_in"] == "Y" &&
        widget.infoLog["typeToko"] == "TOKO" &&
        widget.master["status"] == "O";

    if (mounted) setState(() => _loading = true);

    HttpPostResponse response = await Helper.sendHttpPost(
      urlFotoActivitySMDDetailSub,
      postData: {
        "iduser": await Helper.getPrefs("iduser"),
        "token": await Helper.getPrefs("token"),
        "temp_id": widget.masterSub.tempid.toString(),
        "idjenisphoto": widget.masterSub.idjenisfoto,
      },
    );

    if (response.success) {
      final bool sukses = response.data["Sukses"] == "Y";
      final String pesan = response.data["Pesan"];

      if (sukses) {
        _data.clear();

        for (final row in (response.data["rows"] as List? ?? const [])) {
          final r = row as Map<String, dynamic>;
          String s(String k, [String d = '']) => r[k]?.toString() ?? d;

          _data.add(ModelJenisFotoSMDItem(
            id: s("id"),
            tempid: s("temp_id"),
            idjenisphoto: s("idjenisphoto"),
            foto: s("foto"),
            remark: s("remark"),
            lokasi: s("lokasi"),
            lokasidisplay: s("lokasidisplay"),
            brand: s("brand"),
            produk: s("produk"),
            qty: s("qty", "0"),
            idlokasi: s("idlokasi"),
            idbrand: s("idbrand"),
            idproduk: s("idproduk"),
            keterangan: s("keterangan"),
            idketerangan: s("idketerangan"),
            idkelompoknds: s("idkelompoknds"),
            idjenisnds: s("idjenisnds"),
            kelompoknds: s("kelompoknds"),
            jenisnds: s("jenisnds"),
            fotoRakNdb: s("foto_rak_ndb"),
            keteranganRakNdb: s("keterangan_rak_ndb"),
          ));
        }
      } else {
        if (mounted) {
          Helper.showAlert(context: context, message: pesan, type: AlertType.error);
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

    if (mounted) setState(() => _loading = false);
  }

  void _addItem({ModelJenisFotoSMDItem? item}) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FotoSMDSubdetailAdd(
              item: item,
              masterSub: widget.masterSub,
              queryLokasiDisplay:
                  widget.infoLog["infoLog"]["query_lokasi_display"],
              queryBrandProduk:
                  widget.infoLog["infoLog"]["query_brand_produk"],
              queryProduk: widget.infoLog["infoLog"]["query_add_produkkalbe"],
              queryKeterangan:
                  widget.infoLog["infoLog"]["query_keterangan"],
              queryKelompokNds:
                  widget.infoLog["infoLog"]["query_kelompoknds"],
              queryJenisNds: widget.infoLog["infoLog"]["query_jenisnds"],
              queryFotoRakNdb:
                  widget.infoLog["infoLog"]["query_foto_rak_ndb"]?.toString() ?? "",
              queryKeteranganRakNdb:
                  widget.infoLog["infoLog"]["query_keterangan_rak_ndb"]?.toString() ?? "",
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
      child: Column(
        children: [
          if (_data.isEmpty) const Text("Tidak ada data"),
          ...List.generate(
            _data.length,
            (index) => Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: _editable
                    ? () => _addItem(item: _data[index])
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar utama
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BokiImageNetwork(
                          url:
                              "$baseURL/assets/images/lampiran/${_data[index].foto}",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Detail teks
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _data[index].lokasidisplay,
                                    style: textStyleBold.copyWith(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),

                            Row(
                              children: [
                                const Icon(Icons.label, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _data[index].brand,
                                    style: textStyleRegular.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),

                            Row(
                              children: [
                                const Icon(Icons.shopping_cart, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _data[index].produk,
                                    style: textStyleRegular.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),

                            Row(
                              children: [
                                const Icon(Icons.storage, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Stok: ${_data[index].qty}",
                                    style: textStyleRegular.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            //  Foto & Keterangan Rak NDB hanya kalau jenisnds == "Ada Rak NDB"
                            if (_data[index].jenisnds == "Ada Rak NDB") ...[
                              if (_data[index].fotoRakNdb?.isNotEmpty ?? false) ...[
                                const SizedBox(height: 8),
                                const Divider(),
                                Row(
                                  children: [
                                    const Icon(Icons.photo, size: 16),
                                    const SizedBox(width: 8),
                                    Text("Foto Rak NDB:", style: textStyleBold),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                BokiImageNetwork(
                                  url:
                                      "$baseURL/assets/images/lampiran/${_data[index].fotoRakNdb!}",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ],
                              if (_data[index].keteranganRakNdb?.isNotEmpty ?? false) ...[
                                const SizedBox(height: 8),
                                const Divider(),
                                Row(
                                  children: [
                                    const Icon(Icons.notes, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _data[index].keteranganRakNdb!,
                                        style: textStyleRegular.copyWith(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
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
                    Icon(FontAwesomeIcons.plus, size: 16),
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
