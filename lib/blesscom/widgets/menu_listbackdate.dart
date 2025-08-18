import 'package:kalbemd/blesscom/pages/barangdatang/barang_datang.dart';
import 'package:kalbemd/blesscom/pages/barangdatangbackdate/barang_datang_backdate.dart';
import 'package:kalbemd/blesscom/pages/distribusi/distribusi.dart';
import 'package:kalbemd/blesscom/pages/foto_produk/foto_produk.dart';
import 'package:kalbemd/blesscom/pages/foto_smd/foto_smd.dart';
import 'package:kalbemd/blesscom/pages/input_ijin/input_ijin.dart';
import 'package:kalbemd/blesscom/pages/input_penjualan_sales/input_penjualan_sales.dart';
import 'package:kalbemd/blesscom/pages/input_penjualan_sales/report_penjualan_sales.dart';
import 'package:kalbemd/blesscom/pages/input_pkm/input_pkm.dart';
import 'package:kalbemd/blesscom/pages/input_po/input_po.dart';
import 'package:kalbemd/blesscom/pages/input_stok/input_stok.dart';
import 'package:kalbemd/blesscom/pages/pembelian/pembelian.dart';
import 'package:kalbemd/blesscom/pages/pengembalian/pengembalian.dart';
import 'package:kalbemd/blesscom/pages/penjualan/penjualan.dart';
import 'package:kalbemd/blesscom/pages/returbarang/retur_barang.dart';
import 'package:kalbemd/blesscom/pages/returbarangbackdate/retur_barang_backdate.dart';
import 'package:kalbemd/blesscom/pages/saldoakhir/saldo_akhir.dart';
import 'package:kalbemd/blesscom/pages/saldoakhir/saldo_akhirold.dart';
import 'package:kalbemd/blesscom/pages/saldoakhirbackdate/saldo_akhir_backdate.dart';
import 'package:kalbemd/blesscom/pages/setor_uang/setor_uang.dart';
import 'package:kalbemd/blesscom/pages/stok_awal/stok_awal.dart';
import 'package:kalbemd/blesscom/pages/stok_awal_backdate/stok_awal_backdate.dart';
import 'package:kalbemd/blesscom/pages/updateharga/update_harga.dart';
import 'package:kalbemd/blesscom/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuListBackdate extends StatefulWidget {
  final dynamic infoLog;
  final bool loading;
  final Function()? onPop;

  const MenuListBackdate({
    required this.infoLog,
    this.loading = false,
    this.onPop,
    Key? key,
  }) : super(key: key);

  @override
  _MenuListBackdateState createState() => _MenuListBackdateState();
}

class _MenuListBackdateState extends State<MenuListBackdate> {
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

    bool _menuPenjualan = widget.infoLog["infoLog"]["menu_penjualan"] == "Y";
    bool _menuDistribusiProduk =
        widget.infoLog["infoLog"]["menu_distribusiproduk"] == "Y";
    bool _menuFotoActivityMotoris =
        widget.infoLog["infoLog"]["menu_fotoactivitymotoris"] == "Y";
    bool _menuFotoActivitySMD =
        widget.infoLog["infoLog"]["menu_fotoactivitysmd"] == "Y";
    bool _menuPembelian = widget.infoLog["infoLog"]["menu_pembelian"] == "Y";
    bool _menuPengembalian =
        widget.infoLog["infoLog"]["menu_pengembalian"] == "Y";
    bool _menuInputPO = widget.infoLog["infoLog"]["menu_inputpo"] == "Y";
    bool _menuInputStok = widget.infoLog["infoLog"]["menu_inputstok"] == "Y";
    bool _menuInputPkm = widget.infoLog["infoLog"]["menu_inputpkm"] == "Y";
    bool _menuSetorUang = widget.infoLog["infoLog"]["menu_setoruang"] == "Y";

    bool _menuStokAwal = widget.infoLog["infoLog"]["menu_stokawal"] == "Y";
    bool _menuBarangDatang =
        widget.infoLog["infoLog"]["menu_barangdatang"] == "Y";
    bool _menuReturBarang =
        widget.infoLog["infoLog"]["menu_returbarang"] == "Y";
    bool _menuSaldoAkhir = widget.infoLog["infoLog"]["menu_saldoakhir"] == "Y";
    bool _menuInputPenjualanSales =
        widget.infoLog["infoLog"]["menu_inputpenjualansales"] == "Y";
    bool _menuUpdateHarga =
        widget.infoLog["infoLog"]["menu_updateharga"] == "Y";

    bool _menuInputIjin = widget.infoLog["infoLog"]["menu_inputijin"] == "Y";

    bool _menuStokAwalBackdate =
        widget.infoLog["infoLog"]["menu_stokawalbackdate"] == "Y";
    bool _menuBarangDatangBackdate =
        widget.infoLog["infoLog"]["menu_barangdatangbackdate"] == "Y";
    bool _menuReturBarangBackdate =
        widget.infoLog["infoLog"]["menu_returbarangbackdate"] == "Y";
    bool _menuSaldoAkhirBackdate =
        widget.infoLog["infoLog"]["menu_saldoakhirbackdate"] == "Y";
    bool _menuInputPenjualanSalesBackdate =
        widget.infoLog["infoLog"]["menu_inputpenjualansalesbackdate"] == "Y";

    // Clear all menus
    _menuItems.clear();

    // Build menus
    // if (_menuPembelian) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cartPlus,
    //     name: "Pembelian",
    //     onTap: _checkedIn && _typeIsDistributor ? _goToPembelian : null,
    //   ));
    // }

    // if (_menuPenjualan) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cashRegister,
    //     name: "Penjualan",
    //     onTap: _checkedIn && _typeIsToko ? _goToPenjualan : null,
    //   ));
    // }

    // if (_menuDistribusiProduk) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.expandArrowsAlt,
    //     name: "Distribusi Produk",
    //     onTap: _checkedIn && _typeIsToko ? _goToDistribusi : null,
    //   ));
    // }
    // if (_menuFotoActivityMotoris) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cameraRetro,
    //     name: "Foto Activity Motoris",
    //     onTap: _checkedIn && _typeIsToko ? _goToFotoProduk : null,
    //   ));
    // }

    // if (_menuPengembalian) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.arrowCircleLeft,
    //     name: "Pengembalian",
    //     onTap: _checkedIn && _typeIsDistributor ? _goToPengembalian : null,
    //   ));
    // }

    // if (_menuInputPO) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.paperclip,
    //     name: "Input PO",
    //     onTap: _checkedIn && _typeIsDistributor ? _goInputPO : null,
    //   ));
    // }

    // if (_menuSetorUang) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.moneyBillWave,
    //     name: "Setor Uang",
    //     onTap: _checkedIn && _typeIsToko ? _goToSetorUang : null,
    //   ));
    // }

    // if (_menuInputStok) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.moneyBillWave,
    //     name: "Input Stok",
    //     onTap: _checkedIn && _typeIsToko ? _goInputStok : null,
    //   ));
    // }

    // if (_menuInputPkm) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.moneyBillWave,
    //     name: "Input PKM",
    //     onTap: _checkedIn && _typeIsToko ? _goInputPKM : null,
    //   ));
    // }

    // if (_menuStokAwal) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.firstOrder,
    //     name: "Input Stok Awal",
    //     onTap: _checkedIn ? _goStokAwal : null,
    //   ));
    // }

    // if (_menuBarangDatang) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.rightToBracket,
    //     name: "Barang Datang",
    //     onTap: _checkedIn ? _goBarangDatang : null,
    //   ));
    // }

    // if (_menuReturBarang) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.arrowRotateLeft,
    //     name: "Retur Barang",
    //     onTap: _checkedIn ? _goReturBarang : null,
    //   ));
    // }

    // if (_menuSaldoAkhir) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.fileInvoice,
    //     name: "Stok Akhir",
    //     onTap: _checkedIn ? _goSaldoAkhir : null,
    //   ));
    // }

    // if (_menuInputPenjualanSales) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cartArrowDown,
    //     name: "Input Penjualan Sales",
    //     onTap: _checkedIn ? _goInputPenjualanSales : null,
    //   ));
    // }

    // if (_menuUpdateHarga) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.moneyBillTrendUp,
    //     name: "Input Update Harga",
    //     onTap: _checkedIn && _typeIsToko ? _goInputUpdateHarga : null,
    //   ));
    // }

    // if (_menuFotoActivitySMD) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.images,
    //     name: "Foto Activity BA",
    //     onTap: _checkedIn && _typeIsToko ? _goToFotoProdukSMD : null,
    //   ));
    // }

    // if (_menuInputIjin) {
    //   _menuItems.add(MenuItemMotoris(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.houseMedical,
    //     name: "Input Ijin",
    //     onTap: _checkedIn && _typeIsToko ? _goToInputIjin : null,
    //   ));
    // }

    //menu backdate
    if (_menuStokAwalBackdate) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.firstOrder,
        name: "Input Stok Awal Backdate",
        onTap: _goStokAwalBackdate,
      ));
    }

    if (_menuBarangDatangBackdate) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.rightToBracket,
        name: "Barang Datang Backdate",
        onTap: _checkedIn ? _goBarangDatang : null,
      ));
    }

    if (_menuReturBarangBackdate) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.arrowRotateLeft,
        name: "Retur Barang Backdate",
        onTap: _checkedIn ? _goReturBarang : null,
      ));
    }

    if (_menuSaldoAkhirBackdate) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.fileInvoice,
        name: "Stok Akhir Backdate",
        onTap: _checkedIn ? _goSaldoAkhir : null,
      ));
    }

    if (_menuInputPenjualanSalesBackdate) {
      _menuItems.add(MenuItemMotoris(
        image: "assets/images/tokoku.png",
        icon: FontAwesomeIcons.cartArrowDown,
        name: "Penjualan Sales",
        onTap: _checkedIn ? _goInputPenjualanSales : null,
      ));
    }

    // _menuItems = [
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cashRegister,
    //     name: "Penjualan",
    //     onTap: _checkedIn && _typeIsToko ? _goToPenjualan : null,
    //   ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.expandArrowsAlt,
    //     name: "Distribusi Produk",
    //     onTap: _checkedIn && _typeIsToko ? _goToDistribusi : null,
    //   ),
    //   // MenuItem(
    //   //   image: "assets/images/tokoku.png",
    //   //   icon: FontAwesomeIcons.expandArrowsAlt,
    //   //   name: "Distribusi Produk",
    //   //   onTap: _checkedIn && _typeIsToko ? _goToDistribusi : null,
    //   // ),
    //   // MenuItem(
    //   //   image: "assets/images/tokoku.png",
    //   //   icon: FontAwesomeIcons.clipboardList,
    //   //   name: "Input Kuesioner",
    //   //   onTap: _checkedIn && _typeIsToko ? _goToKuesioner : null,
    //   // ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cameraRetro,
    //     name: "Foto Activity Motoris",
    //     onTap: _checkedIn && _typeIsToko ? _goToFotoProduk : null,
    //   ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.moneyBillWave,
    //     name: "Foto Activity SMD",
    //     onTap: _checkedIn && _typeIsToko ? _goToFotoProdukSMD : null,
    //   ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.cartPlus,
    //     name: "Pembelian",
    //     onTap: _checkedIn && _typeIsDistributor ? _goToPembelian : null,
    //   ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.arrowCircleLeft,
    //     name: "Pengembalian",
    //     onTap: _checkedIn && _typeIsDistributor ? _goToPengembalian : null,
    //   ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.paperclip,
    //     name: "Input PO",
    //     onTap: _checkedIn && _typeIsDistributor ? _goInputPO : null,
    //   ),
    //   MenuItem(
    //     image: "assets/images/tokoku.png",
    //     icon: FontAwesomeIcons.moneyBillWave,
    //     name: "Setor Uang",
    //     onTap: _checkedIn && _typeIsToko ? _goToSetorUang : null,
    //   ),
    // ];
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
            builder: (context) => BarangDatangBackdate(
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
            builder: (context) => ReturBarangBackdate(
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
            builder: (context) => SaldoAkhirBackdate(
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

  // void _goInputUpdateHarga() {
  //   Navigator.of(context)
  //       .push(
  //         MaterialPageRoute(
  //           builder: (context) => UpdateHarga(
  //             infoLog: widget.infoLog,
  //           ),
  //         ),
  //       )
  //       .then(
  //         (value) => widget.onPop?.call(),
  //       );
  // }

  @override
  void initState() {
    super.initState();
    _initMenu();
  }

  @override
  void didUpdateWidget(covariant MenuListBackdate oldWidget) {
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
