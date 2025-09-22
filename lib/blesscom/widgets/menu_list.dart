import 'package:kalbemd/blesscom/pages/barangdatang/barang_datang.dart';
import 'package:kalbemd/blesscom/pages/distribusi/distribusi.dart';
import 'package:kalbemd/blesscom/pages/foto_produk/foto_produk.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/foto_smd.dart';
import 'package:kalbemd/blesscom/pages/input_harga_kalbe/input_harga_kalbe.dart';
import 'package:kalbemd/blesscom/pages/input_harga_kompetitor/input_harga_kompetitor.dart';
import 'package:kalbemd/blesscom/pages/input_ijin/input_ijin.dart';
import 'package:kalbemd/blesscom/pages/input_penjualan_sales/input_penjualan_sales.dart';
import 'package:kalbemd/blesscom/pages/input_penjualan_sales/report_penjualan_sales.dart';
import 'package:kalbemd/blesscom/pages/input_pkm/input_pkm.dart';
import 'package:kalbemd/blesscom/pages/input_po/input_po.dart';
import 'package:kalbemd/blesscom/pages/input_promo/input_promo.dart';
import 'package:kalbemd/blesscom/pages/input_stok/input_stok.dart';
import 'package:kalbemd/blesscom/pages/oos/oos.dart';
import 'package:kalbemd/blesscom/pages/pembelian/pembelian.dart';
import 'package:kalbemd/blesscom/pages/pengembalian/pengembalian.dart';
import 'package:kalbemd/blesscom/pages/penjualan/penjualan.dart';
import 'package:kalbemd/blesscom/pages/penjualan_harian/penjualan_harian.dart';
import 'package:kalbemd/blesscom/pages/produk_expired/produk_expired.dart';
import 'package:kalbemd/blesscom/pages/returbarang/retur_barang.dart';
import 'package:kalbemd/blesscom/pages/saldoakhir/saldo_akhir.dart';
import 'package:kalbemd/blesscom/pages/saldoakhir/saldo_akhirold.dart';
import 'package:kalbemd/blesscom/pages/setor_uang/setor_uang.dart';
import 'package:kalbemd/blesscom/pages/stok_awal/stok_awal.dart';
import 'package:kalbemd/blesscom/pages/stok_awal_backdate/stok_awal_backdate.dart';
import 'package:kalbemd/blesscom/pages/updateharga/update_harga.dart';
import 'package:kalbemd/blesscom/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuList extends StatefulWidget {
  final dynamic infoLog;
  final bool loading;
  final Function()? onPop;

  const MenuList({
    required this.infoLog,
    this.loading = false,
    this.onPop,
    Key? key,
  }) : super(key: key);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  bool _checkedIn = false;
  bool _typeIsToko = false;
  bool _typeIsDistributor = false;

  final List<MenuItemMotoris> _menuItems = [];

  // log()

  void _initMenu() {
    // Type toko
    // _checkedIn = widget.infoLog["status_check_in"] == "Y";
    // print("ini checkin " + widget.infoLog["status_check_in"]);
    // _typeIsToko = widget.infoLog["typeToko"] == "TOKO";
    // _typeIsDistributor = widget.infoLog["typeToko"] == "DISTRIBUTOR";

    _checkedIn = true;
    _typeIsToko = true;
    _typeIsDistributor = true;

    bool menuPenjualan = widget.infoLog["infoLog"]["menu_penjualan"] == "Y";
    bool menuDistribusiProduk =
        widget.infoLog["infoLog"]["menu_distribusiproduk"] == "Y";
    bool menuFotoActivityMotoris =
        widget.infoLog["infoLog"]["menu_fotoactivitymotoris"] == "Y";
    bool menuFotoActivitySMD =
        widget.infoLog["infoLog"]["menu_fotoactivitysmd"] == "Y";
    bool menuPembelian = widget.infoLog["infoLog"]["menu_pembelian"] == "Y";
    bool menuPengembalian =
        widget.infoLog["infoLog"]["menu_pengembalian"] == "Y";
    bool menuInputPO = widget.infoLog["infoLog"]["menu_inputpo"] == "Y";
    bool menuInputStok = widget.infoLog["infoLog"]["menu_inputstok"] == "Y";
    bool menuInputPkm = widget.infoLog["infoLog"]["menu_inputpkm"] == "Y";
    bool menuSetorUang = widget.infoLog["infoLog"]["menu_setoruang"] == "Y";

    bool menuStokAwal = widget.infoLog["infoLog"]["menu_stokawal"] == "Y";
    bool menuBarangDatang =
        widget.infoLog["infoLog"]["menu_barangdatang"] == "Y";
    bool menuReturBarang =
        widget.infoLog["infoLog"]["menu_returbarang"] == "Y";
    bool menuSaldoAkhir = widget.infoLog["infoLog"]["menu_saldoakhir"] == "Y";
    bool menuInputPenjualanSales =
        widget.infoLog["infoLog"]["menu_inputpenjualansales"] == "Y";
    bool menuUpdateHarga =
        widget.infoLog["infoLog"]["menu_updateharga"] == "Y";

    bool menuInputIjin = widget.infoLog["infoLog"]["menu_inputijin"] == "Y";

    bool menuStokAwalBackdate =
        widget.infoLog["infoLog"]["menu_stokawalbackdate"] == "Y";
    bool menuBarangDatangBackdate =
        widget.infoLog["infoLog"]["menu_barangdatangbackdate"] == "Y";
    bool menuReturBarangBackdate =
        widget.infoLog["infoLog"]["menu_returbarangbackdate"] == "Y";
    bool menuSaldoAkhirBackdate =
        widget.infoLog["infoLog"]["menu_saldoakhirbackdate"] == "Y";
    bool menuInputPenjualanSalesBackdate =
        widget.infoLog["infoLog"]["menu_inputpenjualansalesbackdate"] == "Y";
    bool menuInputHargaKalbe =
        widget.infoLog["infoLog"]["menu_inputhargakalbe"] == "Y";
    bool menuInputHargaKompetitor =
        widget.infoLog["infoLog"]["menu_inputhargakompetitor"] == "Y";

    bool menuPenjualanHarian =
        widget.infoLog["infoLog"]["menu_penjualanharian"] == "Y";
    bool menuOos = widget.infoLog["infoLog"]["menu_oos"] == "Y";
    bool menuProdukExpired =
        widget.infoLog["infoLog"]["menu_produkexpired"] == "Y";
     bool menuInputPromo = widget.infoLog["infoLog"]["menu_inputpromo"] == "Y";

    // Clear all menus
    _menuItems.clear();

    // Build menus
    if (menuPembelian) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.cartPlus,
        name: "Pembelian",
        onTap: _checkedIn && _typeIsDistributor ? _goToPembelian : null,
      ));
    }

    if (menuPenjualan) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.cashRegister,
        name: "Penjualan",
        onTap: _checkedIn && _typeIsToko ? _goToPenjualan : null,
      ));
    }

    if (menuDistribusiProduk) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.expandArrowsAlt,
        name: "Distribusi Produk",
        onTap: _checkedIn && _typeIsToko ? _goToDistribusi : null,
      ));
    }
    if (menuFotoActivityMotoris) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.cameraRetro,
        name: "Foto Activity Motoris",
        onTap: _checkedIn && _typeIsToko ? _goToFotoProduk : null,
      ));
    }

    if (menuPengembalian) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.arrowCircleLeft,
        name: "Pengembalian",
        onTap: _checkedIn && _typeIsDistributor ? _goToPengembalian : null,
      ));
    }

    if (menuInputPO) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.paperclip,
        name: "Input PO",
        onTap: _checkedIn && _typeIsDistributor ? _goInputPO : null,
      ));
    }

    if (menuSetorUang) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.moneyBillWave,
        name: "Setor Uang",
        onTap: _checkedIn && _typeIsToko ? _goToSetorUang : null,
      ));
    }

    if (menuInputStok) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.moneyBillWave,
        name: "Input Stok",
        onTap: _checkedIn && _typeIsToko ? _goInputStok : null,
      ));
    }

    if (menuInputPkm) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.moneyBillWave,
        name: "Input PKM",
        onTap: _checkedIn && _typeIsToko ? _goInputPKM : null,
      ));
    }

    if (menuStokAwal) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.firstOrder,
        name: "Input Stok Awal",
        onTap: _checkedIn ? _goStokAwal : null,
      ));
    }

    if (menuBarangDatang) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.rightToBracket,
        name: "Barang Datang",
        onTap: _checkedIn ? _goBarangDatang : null,
      ));
    }

    if (menuReturBarang) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.arrowRotateLeft,
        name: "Retur Barang",
        onTap: _checkedIn ? _goReturBarang : null,
      ));
    }

    if (menuSaldoAkhir) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.fileInvoice,
        name: "Stok Akhir",
        onTap: _checkedIn ? _goSaldoAkhir : null,
      ));
    }

    if (menuInputPenjualanSales) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.cartArrowDown,
        name: "Penjualan Sales",
        onTap: _checkedIn ? _goInputPenjualanSales : null,
      ));
    }

    if (menuUpdateHarga) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.moneyBillTrendUp,
        name: "Input Update Harga",
        onTap: _checkedIn && _typeIsToko ? _goInputUpdateHarga : null,
      ));
    }

    if (menuFotoActivitySMD) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.images,
        name: "Foto Activity",
        onTap: _checkedIn && _typeIsToko ? _goToFotoProdukSMD : null,
      ));
    }

     if (menuInputPromo) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.bullhorn,
        name: "Keterjadian Promo",
        onTap: _checkedIn && _typeIsToko ? _goToInputPromo : null,
      ));
    }

    if (menuInputIjin) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.houseMedical,
        name: "Input Ijin",
        onTap: _checkedIn && _typeIsToko ? _goToInputIjin : null,
      ));
    }

    if (menuInputHargaKalbe) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.moneyBillTrendUp,
        name: "Input Harga Kalbe",
        onTap: _checkedIn && _typeIsDistributor ? _goInputHargaKalbe : null,
      ));
    }

    if (menuInputHargaKompetitor) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.moneyBillTrendUp,
        name: "Input Harga Kompetitor",
        onTap:
            _checkedIn && _typeIsDistributor ? _goInputHargaKompetitor : null,
      ));
    }

    if (menuPenjualanHarian) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.cartFlatbed,
        name: "Penjualan Hari Ini",
        onTap: _checkedIn && _typeIsDistributor ? _goPenjualanHarian : null,
      ));
    }
    if (menuOos) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.arrowTrendDown,
        name: "OOS",
        onTap: _checkedIn && _typeIsDistributor ? _goOos : null,
      ));
    }
    if (menuProdukExpired) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.schoolCircleCheck,
        name: "Produk Expired",
        onTap: _checkedIn && _typeIsDistributor ? _goProdukExpired : null,
      ));
    }

  }

   void _goToInputPromo() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputPromo(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goProdukExpired() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ProdukExpired(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goOos() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Oos(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goPenjualanHarian() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PenjualanHarian(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToPenjualan() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Penjualan(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputPO() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputPO(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputHargaKalbe() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputHargaKalbe(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputHargaKompetitor() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputHargaKompetitor(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToDistribusi() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Distribusi(
              infoLog: widget.infoLog,
              // master: {
              //   "temp_id": "22277",
              //   "status": "O",
              //   "nobukti": "WOW129831",
              //   "tanggal": "20 Des 2021",
              // },
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToKuesioner() {}
  void _goToFotoProduk() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FotoProduk(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToFotoProdukSMD() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FotoSMD(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToInputIjin() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputIjin(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToPembelian() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Pembelian(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToPengembalian() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Pengembalian(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goToSetorUang() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SetorUang(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputStok() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputStok(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputPKM() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => InputPkm(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goStokAwal() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => StokAwal(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goStokAwalBackdate() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => StokAwalBackdate(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goBarangDatang() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => BarangDatang(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goReturBarang() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ReturBarang(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goSaldoAkhir() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SaldoAkhir(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputPenjualanSales() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ReportPenjualanSales(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  void _goInputUpdateHarga() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => UpdateHarga(
              infoLog: widget.infoLog,
            ),
          ),
        )
        .then(
          (value) => widget.onPop?.call(),
        );
  }

  @override
  void initState() {
    super.initState();
    _initMenu();
  }

  @override
  void didUpdateWidget(covariant MenuList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? const LinearProgressIndicator()
        : Column(
            children: List.generate(
              _menuItems.length,
              (index) {
                if (index.remainder(2) == 0) {
                  return Row(
                    children: [
                      Expanded(
                        child: _menuItems[index],
                      ),
                      Expanded(
                        child: ((index + 1) < _menuItems.length)
                            ? _menuItems[index + 1]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
  }
}
