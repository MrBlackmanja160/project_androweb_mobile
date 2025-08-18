const String appName = "BTrack";
const String appNameSub = "Kalbe MD";

// const String baseURL = "https://kalbe-md.blesscom1.com/";
const String baseURL = "http://192.168.2.61/kalbe-md/";

// const String urlToko = baseURL + "Parse_android/getToko";
const String tokenAplikasi = "2325427f-ba13-11eb-a15e-3c970e7a4464";

// LOGIN
const String urlLogin = "${baseURL}Parse_android/loginAndroid";
const String urlGetSelectAjax = "${baseURL}Tools/getSelectAjax";
const String urlGantiPassword = "${baseURL}Parse_android/updatePassword";

// INFO LOG
const String urlInfoLog = "${baseURL}Parse_android/infoLog";
const String urlSaveFoto = "${baseURL}Parse_android/SaveFoto";

// CHECK IN / OUT
const String urlCheckIn = "${baseURL}Parse_android/saveCheckin";
const String urlCheckOut = "${baseURL}Parse_android/saveCheckout";

const String urlTempId = "${baseURL}Parse_android/getTempId";

// PEMBELIAN
const String urlPembelian = "${baseURL}Parse_android/getDataPembelianProduk";
const String urlPembelianAdd =
    "${baseURL}Parse_android/saveMasterPembelianProduk";
const String urlPembelianDelete =
    "${baseURL}Parse_android/hapusDataPembelianProduk";
const String urlPembelianDetail =
    "${baseURL}Parse_android/getDetailPembelianProduk";
const String urlPembelianDetailAdd =
    "${baseURL}Parse_android/saveDetailPembelianProduk";
const String urlPembelianDetailDelete =
    "${baseURL}Parse_android/hapusDetailPembelianProduk";

// LOG PRODUK
const String urlLogProduk = "${baseURL}Parse_android/getLogProduk";
const String urlArchievment = "${baseURL}Parse_android/getArchievment";

// LOG UANG
const String urlLogUang = "${baseURL}Parse_android/getLogUang";

// LOG ACTIVITY
const String urlLogActivity = "${baseURL}Parse_android/getLogActivity";

// PENGEMBALIAN
const String urlPengembalian =
    "${baseURL}Parse_android/getDataPengembalianProduk";
const String urlPengembalianAdd =
    "${baseURL}Parse_android/saveMasterPengembalianProduk";
const String urlPengembalianDelete =
    "${baseURL}Parse_android/hapusDataPengembalianProduk";
const String urlPengembalianDetail =
    "${baseURL}Parse_android/getDetailPengembalianProduk";

// PENJUALAN
const String urlPenjualan = "${baseURL}Parse_android/getDataPenjualanProduk";
const String urlPenjualanAdd =
    "${baseURL}Parse_android/saveMasterPenjualanProduk";
const String urlPenjualanDelete =
    "${baseURL}Parse_android/hapusDataPenjualanProduk";
const String urlPenjualanDetail =
    "${baseURL}Parse_android/getDetailPenjualanProduk";
const String urlPenjualanDetailAdd =
    "${baseURL}Parse_android/saveDetailPenjualanProduk";
const String urlPenjualanDetailDelete =
    "${baseURL}Parse_android/hapusDetailPenjualanProduk";

// SETOR UANG
const String urlSetorUang = "${baseURL}Parse_android/getDataSetorUang";
const String urlSetorUangAdd = "${baseURL}Parse_android/saveMasterSetorUang";
const String urlSetorUangDelete = "${baseURL}Parse_android/hapusDataSetorUang";
const String urlSetorUangDetail = "${baseURL}Parse_android/getDetailSetorUang";
const String urlSetorUangSetorManual =
    "${baseURL}Parse_android/updateSetoranManual";

// DISTRIBUSI PRODUK
const String urlDistribusiProduk =
    "${baseURL}Parse_android/getDataDistribusiProduk";
const String urlDistribusiProdukAdd =
    "${baseURL}Parse_android/saveMasterDistribusiProduk";
const String urlDistribusiProdukDelete =
    "${baseURL}Parse_android/hapusDataDistribusiProduk";
const String urlDistribusiProdukDetail =
    "${baseURL}Parse_android/getDetailDistribusiProduk";
const String urlDistribusiProdukKompetitorList =
    "${baseURL}Parse_android/getProdukDanKompetitor";

// UPLOAD PHOTO
const String urlUploadPhoto = "${baseURL}Parse_android/uploadFotoMaster";
const String urlUploadPhotoProduk = "${baseURL}Parse_android/uploadFotoProduk";
const String urlUploadPhotoSMD = "${baseURL}Parse_android/uploadFotoProdukSMD";

// INPUT PO
const String urlInputPO = "${baseURL}Parse_android/getDataInputPO";
const String urlInputPOAdd = "${baseURL}Parse_android/saveMasterInputPO";
const String urlInputPODelete = "${baseURL}Parse_android/hapusDataInputPO";
const String urlInputPODetail = "${baseURL}Parse_android/getDetailInputPO";
const String urlInputPODetailAdd = "${baseURL}Parse_android/saveDetailInputPO";
const String urlInputPODetailDelete =
    "${baseURL}Parse_android/hapusDetailInputPO";

// Foto Activity Motoris
const String urlMasterJenisFotoMtr =
    "${baseURL}Parse_android/getMasterJenisFoto";
const String urlFotoActivityMtr = "${baseURL}Parse_android/getDataFotoActivity";
const String urlFotoActivityMtrAdd =
    "${baseURL}Parse_android/saveMasterFotoActivity";
const String urlFotoActivityMtrDelete =
    "${baseURL}Parse_android/hapusDataFotoActivity";
const String urlFotoActivityMtrDetail = "$baseURL";

// Foto Activity SMD
const String urlMasterJenisFotoSMD =
    "${baseURL}Parse_android/getMasterJenisFotoSMD";
const String urlFotoActivitySMD =
    "${baseURL}Parse_android/getDataFotoActivitySMD";
const String urlFotoActivitySMDAdd =
    "${baseURL}Parse_android/saveMasterFotoActivitySMD";
const String urlFotoActivitySMDDelete =
    "${baseURL}Parse_android/hapusDataFotoActivitySMD";
const String urlFotoActivitySMDDetail = "$baseURL";
const String urlFotoActivitySMDDetailSub =
    "${baseURL}Parse_android/getDetailSubFotoActivitySMD";
const String urlFotoActivitySMDDetailSubAdd =
    "${baseURL}Parse_android/saveDetailFotoActivitySMDDet";
const String urlFotoActivitySMDDetailSubAddV2 =
    "${baseURL}Parse_android/saveDetailFotoActivitySMDDetV2";

// INPUT Stok
const String urlInputStok = "${baseURL}Parse_android/getDataInputStok";
const String urlInputStokAdd = "${baseURL}Parse_android/saveMasterInputStok";
const String urlInputStokDelete = "${baseURL}Parse_android/hapusDataInputStok";
const String urlInputStokDetail = "${baseURL}Parse_android/getDetailInputStok";
const String urlInputStokDetailAdd =
    "${baseURL}Parse_android/saveDetailInputStok";
const String urlInputStokDetailDelete =
    "${baseURL}Parse_android/hapusDetailInputStok";

// INPUT PKM
const String urlInputPkm = "${baseURL}Parse_android/getDataInputPkm";
const String urlInputPkmAdd = "${baseURL}Parse_android/saveMasterInputPkm";
const String urlInputPkmDelete = "${baseURL}Parse_android/hapusDataInputPkm";
const String urlInputPkmDetail = "${baseURL}Parse_android/getDetailInputPkm";
const String urlInputPkmDetailAdd =
    "${baseURL}Parse_android/saveDetailInputPkm";
const String urlInputPkmDetailDelete =
    "${baseURL}Parse_android/hapusDetailInputPkm";

// STOK AWAL
const String urlStokAwal = "${baseURL}Parse_android/getDataStokAwal";
const String urlStokAwalAdd = "${baseURL}Parse_android/saveMasterStokAwal";
const String urlStokAwalAddBackdate =
    "${baseURL}Parse_android/saveMasterStokAwalBackdate";
const String urlStokAwalDelete = "${baseURL}Parse_android/hapusDataStokAwal";
const String urlStokAwalDetail = "${baseURL}Parse_android/getDetailStokAwal";
const String urlStokAwalDetailAdd =
    "${baseURL}Parse_android/saveDetailStokAwal";
const String urlStokAwalDetailDelete =
    "${baseURL}Parse_android/hapusDetailStokAwal";

// BARANG DATANG
const String urlBarangDatang = "${baseURL}Parse_android/getDataBarangDatang";
const String urlBarangDatangAdd =
    "${baseURL}Parse_android/saveMasterBarangDatang";
const String urlBarangDatangDelete =
    "${baseURL}Parse_android/hapusDataBarangDatang";
const String urlBarangDatangDetail =
    "${baseURL}Parse_android/getDetailBarangDatang";
const String urlBarangDatangDetailAdd =
    "${baseURL}Parse_android/saveDetailBarangDatang";
const String urlBarangDatangDetailDelete =
    "${baseURL}Parse_android/hapusDetailBarangDatang";

// RETUR BARANG
const String urlReturBarang = "${baseURL}Parse_android/getDataReturBarang";
const String urlReturBarangAdd =
    "${baseURL}Parse_android/saveMasterReturBarang";
const String urlReturBarangDelete =
    "${baseURL}Parse_android/hapusDataReturBarang";
const String urlReturBarangDetail =
    "${baseURL}Parse_android/getDetailReturBarang";
const String urlReturBarangDetailAdd =
    "${baseURL}Parse_android/saveDetailReturBarang";
const String urlReturBarangDetailDelete =
    "${baseURL}Parse_android/hapusDetailReturBarang";

// SALDO AKHIR
const String urlSaldoAkhir = "${baseURL}Parse_android/getDataSaldoAkhir";
const String urlStokAkhir = "${baseURL}Parse_android/getDataStokAkhir";
const String urlSaldoAkhirAdd = "${baseURL}Parse_android/saveMasterSaldoAkhir";
const String urlSaldoAkhirDelete =
    "${baseURL}Parse_android/hapusDataSaldoAkhir";
const String urlSaldoAkhirDetail =
    "${baseURL}Parse_android/getDetailSaldoAkhir";
const String urlSaldoAkhirDetailAdd =
    "${baseURL}Parse_android/saveDetailSaldoAkhir";
const String urlSaldoAkhirDetailDelete =
    "${baseURL}Parse_android/hapusDetailSaldoAkhir";

// INPUT PEnjualanSales
const String urlReportPenjualan =
    "${baseURL}Parse_android/getDataReportPenjualanSales";
const String urlInputPenjualanSales =
    "${baseURL}Parse_android/getDataInputPenjualanSales";
const String urlInputPenjualanSalesAdd =
    "${baseURL}Parse_android/saveMasterInputPenjualanSales";
const String urlInputPenjualanSalesDelete =
    "${baseURL}Parse_android/hapusDataInputPenjualanSales";
const String urlInputPenjualanSalesDetail =
    "${baseURL}Parse_android/getDetailInputPenjualanSales";
const String urlInputPenjualanSalesDetailAdd =
    "${baseURL}Parse_android/saveDetailInputPenjualanSales";
const String urlInputPenjualanSalesDetailDelete =
    "${baseURL}Parse_android/hapusDetailInputPenjualanSales";

// UPDATE HARGA
const String urlUpdateHarga = "${baseURL}Parse_android/getDataUpdateHarga";
const String urlUpdateHargaAdd =
    "${baseURL}Parse_android/saveMasterUpdateHarga";
const String urlUpdateHargaDelete =
    "${baseURL}Parse_android/hapusDataUpdateHarga";
const String urlUpdateHargaDetail =
    "${baseURL}Parse_android/getDetailUpdateHarga";
const String urlUpdateHargaDetailAdd =
    "${baseURL}Parse_android/saveDetailUpdateHarga";
const String urlUpdateHargaDetailDelete =
    "${baseURL}Parse_android/hapusDetailUpdateHarga";

// INPUT Ijin
const String urlInputIjin = "${baseURL}Parse_android/getDataInputIjin";
const String urlInputIjinAdd = "${baseURL}Parse_android/saveMasterInputIjin";
const String urlInputIjinEdit = "${baseURL}Parse_android/updateMasterInputIjin";
const String urlInputIjinPosting =
    "${baseURL}Parse_android/postingMasterInputIjin";

const String urlInputIjinDelete = "${baseURL}Parse_android/hapusDataInputIjin";
const String urlInputIjinDetail = "${baseURL}Parse_android/getDetailInputIjin";
const String urlInputIjinDetailAdd =
    "${baseURL}Parse_android/saveDetailInputIjin";
const String urlInputIjinDetailDelete =
    "${baseURL}Parse_android/hapusDetailInputPIjin";

//STOK AWAL BACKDATE
const String urlStokAwalBackdate =
    "${baseURL}Parse_android/getDataStokAwalBackdate";
const String urlStokAwalBackdateAdd =
    "${baseURL}Parse_android/saveMasterStokAwalBackdate";
const String urlStokAwalBackdateAddBackdate =
    "${baseURL}Parse_android/saveMasterStokAwalBackdate";
const String urlStokAwalBackdateDelete =
    "${baseURL}Parse_android/hapusDataStokAwalBackdate";
const String urlStokAwalBackdateDetail =
    "${baseURL}Parse_android/getDetailStokAwalBackdate";
const String urlStokAwalBackdateDetailAdd =
    "${baseURL}Parse_android/saveDetailStokAwalBackdate";
const String urlStokAwalBackdateDetailDelete =
    "${baseURL}Parse_android/hapusDetailStokAwalBackdate";

// SALDO AKHIR BACKDATE
const String urlSaldoAkhirBackdate =
    "${baseURL}Parse_android/getDataSaldoAkhir";
const String urlStokAkhirBackdate = "${baseURL}Parse_android/getDataStokAkhir";
const String urlSaldoAkhirBackdateAdd =
    "${baseURL}Parse_android/saveMasterSaldoAkhirBackdate";
const String urlSaldoAkhirBackdateDelete =
    "${baseURL}Parse_android/hapusDataSaldoAkhirBackdate";
const String urlSaldoAkhirBackdateDetail =
    "${baseURL}Parse_android/getDetailSaldoAkhir";
const String urlSaldoAkhirBackdateDetailAdd =
    "${baseURL}Parse_android/saveDetailSaldoAkhirBackdate";
const String urlSaldoAkhirBackdateDetailDelete =
    "${baseURL}Parse_android/hapusDetailSaldoAkhir";

// BARANG DATANG BACKDATE
const String urlBarangDatangBackdate =
    "${baseURL}Parse_android/getDataBarangDatangBackdate";
const String urlBarangDatangAddBackdate =
    "${baseURL}Parse_android/saveMasterBarangDatangBackdate";
const String urlBarangDatangDeleteBackdate =
    "${baseURL}Parse_atndroid/hapusDataBarangDatang";
const String urlBarangDatangDetailBackdate =
    "${baseURL}Parse_android/getDetailBarangDatang";
const String urlBarangDatangDetailAddBackdate =
    "${baseURL}Parse_android/saveDetailBarangDatangBackdate";
const String urlBarangDatangDetailDeleteBackdate =
    "${baseURL}Parse_android/hapusDetailBarangDatangBackdate";

// RETUR BARANG BACKDATE
const String urlReturBarangBackdate =
    "${baseURL}Parse_android/getDataReturBarangBackdate";
const String urlReturBarangAddBackdate =
    "${baseURL}Parse_android/saveMasterReturBarangBackdate";
const String urlReturBarangDeleteBackdate =
    "${baseURL}Parse_android/hapusDataReturBarangBackdate";
const String urlReturBarangDetailBackdate =
    "${baseURL}Parse_android/getDetailReturBarang";
const String urlReturBarangDetailAddBackdate =
    "${baseURL}Parse_android/saveDetailReturBarangBackdate";
const String urlReturBarangDetailDeleteBackdate =
    "${baseURL}Parse_android/hapusDetailReturBarang";

// INPUT HARGA KALBE
const String urlInputHargaKalbe = "${baseURL}Parse_android/getDataInputHargaKalbe";
const String urlInputHargaKalbeAdd = "${baseURL}Parse_android/saveMasterInputHargaKalbe";
const String urlInputHargaKalbeDelete = "${baseURL}Parse_android/hapusDataInputHargaKalbe";
const String urlInputHargaKalbeDetail = "${baseURL}Parse_android/getDetailInputHargaKalbe";
const String urlInputHargaKalbeDetailAdd = "${baseURL}Parse_android/saveDetailInputHargaKalbe";
const String urlInputHargaKalbeDetailDelete =
    "${baseURL}Parse_android/hapusDetailInputHargaKalbe";

// INPUT HARGA KOMPETITOR
const String urlInputHargaKompetitor = "${baseURL}Parse_android/getDataInputHargaKompetitor";
const String urlInputHargaKompetitorAdd = "${baseURL}Parse_android/saveMasterInputHargaKompetitor";
const String urlInputHargaKompetitorDelete = "${baseURL}Parse_android/hapusDataInputHargaKompetitor";
const String urlInputHargaKompetitorDetail = "${baseURL}Parse_android/getDetailInputHargaKompetitor";
const String urlInputHargaKompetitorDetailAdd = "${baseURL}Parse_android/saveDetailInputHargaKompetitor";
const String urlInputHargaKompetitorDetailDelete =
    "${baseURL}Parse_android/hapusDetailInputHargaKompetitor";

// PENJUALAN HARI INI
const String urlPenjualanHarian = "${baseURL}Parse_android/getDataPenjualanHarian";
const String urlPenjualanHarianAdd = "${baseURL}Parse_android/saveMasterPenjualanHarian";
const String urlPenjualanHarianAddBackdate =
    "${baseURL}Parse_android/saveMasterPenjualanHarianBackdate";
const String urlPenjualanHarianDelete = "${baseURL}Parse_android/hapusDataPenjualanHarian";
const String urlPenjualanHarianDetail = "${baseURL}Parse_android/getDetailPenjualanHarian";
const String urlPenjualanHarianDetailAdd =
    "${baseURL}Parse_android/saveDetailPenjualanHarian";
const String urlPenjualanHarianDetailDelete =
    "${baseURL}Parse_android/hapusDetailPenjualanHarian";

// OOS
const String urlOos = "${baseURL}Parse_android/getDataOos";
const String urlOosAdd = "${baseURL}Parse_android/saveMasterOos";
const String urlOosAddBackdate =
    "${baseURL}Parse_android/saveMasterOosBackdate";
const String urlOosDelete = "${baseURL}Parse_android/hapusDataOos";
const String urlOosDetail = "${baseURL}Parse_android/getDetailOos";
const String urlOosDetailAdd =
    "${baseURL}Parse_android/saveDetailOos";
const String urlOosDetailDelete =
    "${baseURL}Parse_android/hapusDetailOos";

// PRODUK EXPIRED
const String urlProdukExpired = "${baseURL}Parse_android/getDataProdukExpired";
const String urlProdukExpiredAdd = "${baseURL}Parse_android/saveMasterProdukExpired";
const String urlProdukExpiredAddBackdate =
    "${baseURL}Parse_android/saveMasterProdukExpiredBackdate";
const String urlProdukExpiredDelete = "${baseURL}Parse_android/hapusDataProdukExpired";
const String urlProdukExpiredDetail = "${baseURL}Parse_android/getDetailProdukExpired";
const String urlProdukExpiredDetailAdd =
    "${baseURL}Parse_android/saveDetailProdukExpired";
const String urlProdukExpiredDetailDelete =
    "${baseURL}Parse_android/hapusDetailProdukExpired";

// InputPromo
const String urlMasterJenisInputPromo = "${baseURL}Parse_android/getMasterJenisInputPromo";
const String urlInputPromo = "${baseURL}Parse_android/getDataInputPromo";
const String urlInputPromoAdd =
   "${baseURL}Parse_android/saveMasterInputPromo";
const String urlInputPromoDelete =
    "${baseURL}Parse_android/hapusDataInputPromo";
const String urlInputPromoDetail = "${baseURL}";
const String urlInputPromoDetailSub =
    "${baseURL}Parse_android/getDetailSubInputPromo";
const String urlInputPromoDetailSubAdd =
    "${baseURL}Parse_android/saveDetailInputPromoDet";
const String urlUploadPhotoInputPromo = "${baseURL}Parse_android/uploadFotoInputPromo";
const String urlInputPromoPosting = "${baseURL}Parse_android/postingInputPromo";
