# 1.1 Latar Belakang

Di era digital saat ini, kecepatan dan akurasi informasi menjadi kunci utama dalam memenangkan persaingan bisnis, terutama di sektor distribusi barang konsumsi (Fast-Moving Consumer Goods) dan farmasi. PT. Kalbe, sebagai salah satu perusahaan distribusi terkemuka, menghadapi tantangan dalam mengelola data penjualan dan stok yang tersebar di berbagai area. Kondisi aktual di lapangan menunjukkan bahwa proses pelaporan aktivitas penjualan oleh tenaga penjual (sales force) seringkali mengalami kendala, seperti keterlambatan pengiriman data, ketidaksesuaian stok antara catatan lapangan dan sistem pusat, serta proses administrasi manual yang memakan waktu.

Permasalahan ini melatarbelakangi perlunya sebuah solusi teknologi yang dapat mengintegrasikan aktivitas operasional di lapangan dengan sistem manajemen di pusat secara terstruktur dan akurat. Kesenjangan (gap) antara kebutuhan akan data yang valid dengan kondisi infrastruktur pelaporan yang masih manual menjadi dasar utama penelitian ini. Oleh karena itu, pengembangan sistem terintegrasi berbasis Mobile-Web Architecture menjadi solusi yang diajukan. Sistem ini memungkinkan data yang diinputkan melalui aplikasi mobile, seperti dokumentasi foto aktivitas, laporan kunjungan (absen), dan pengajuan izin sebelum check-in toko, dapat tersinkronisasi dan tampil pada aplikasi web sebagai laporan rekapitulasi untuk kebutuhan pemantauan manajemen.

# 1.2 Perumusan Masalah

Berdasarkan latar belakang yang telah diuraikan, maka perumusan masalah yang menjadi fokus dalam penelitian ini adalah sebagai berikut:

1.  Bagaimana merancang arsitektur sistem yang mengintegrasikan aplikasi mobile Android dan aplikasi web secara efektif menggunakan teknologi RESTful API pada PT. Kalbe?
2.  Bagaimana membangun mekanisme sinkronisasi data yang mampu menangani pengiriman data transaksi harian serta data mundur (backdate) untuk menjamin validitas dan konsistensi data stok antara lapangan dan pusat?
3.  Bagaimana implementasi sistem Mobile-Web terintegrasi ini dapat meningkatkan efektivitas tata kelola distribusi dan kecepatan pelaporan aktivitas penjualan di Divisi Distribusi Nasional?

# 1.3 Batasan Masalah

Agar penelitian ini lebih terarah dan fokus pada tujuan yang ingin dicapai, maka penulis menetapkan batasan-batasan masalah sebagai berikut:

1.  **Objek Penelitian**: Penelitian dilakukan pada Divisi Distribusi Nasional PT. Kalbe, dengan fokus pada proses pelaporan data distribusi oleh tenaga penjual (sales force).
2.  **Lingkup Sistem**:
    *   **Aplikasi Mobile (Android)**: Terbatas pada fitur operasional lapangan, meliputi: Absensi (Check-in/Check-out), Pencatatan Stok (Awal, Akhir, Out of Stock, Expired), Transaksi Penjualan, Retur Barang, dan Dokumentasi Aktivitas (Foto).
    *   **Aplikasi Web**: Berperan sebagai Central Management System (CMS) yang komprehensif, mencakup:
        *   **Manajemen Data Master (Master Data Management)**: Pengelolaan data referensi terpusat yang meliputi Struktur Organisasi (Regional, Area), Sumber Daya Manusia (Karyawan, Jabatan, Sales Force), Jaringan Distribusi (Distributor, Toko, Group Toko), serta Data Produk yang mendalam (Brand, Kategori, Harga Jual, dan Konversi Satuan).
        *   **Master Transaksi & Operasional**: Fitur untuk memantau aktivitas harian, termasuk Validasi Absensi, Call Plan (Rencana Kunjungan), Mutasi Stok Gudang & Outlet, serta Verifikasi Retur Barang.
        *   **Master Pelaporan & Analisis (Reporting)**: Penyajian dashboard eksekutif dan laporan detail yang dapat diekspor, meliputi Laporan Penjualan (Sales Performance), Laporan Availability Stok (Out of Stock), Laporan Visual Aktivitas (Photo Activity Before/After), serta Laporan Check-in/Check-out (CICO) untuk memantau durasi kunjungan sales.
        *   **Administrasi Sistem**: Pengaturan hak akses pengguna bertingkat (Role-based Access Control) dan fasilitas impor/ekspor data massal menggunakan templat Excel.
3.  **Teknologi Integrasi**: Sinkronisasi data menggunakan arsitektur Client-Server dengan metode RESTful API berbasis JSON. Bahasa pemrograman yang dibahas meliputi Dart (Flutter) untuk sisi Android dan PHP untuk sisi Server/API.
4.  **Aspek Data**: Pembahasan difokuskan pada mekanisme pengiriman dan validasi data transaksi (termasuk fitur backdate), tidak mencakup analisis keamanan jaringan tingkat lanjut atau infrastruktur hardware server secara mendalam.

# 1.4 Tujuan Penelitian

Berdasarkan rumusan masalah yang telah ditetapkan, tujuan yang ingin dicapai dari penelitian ini adalah:

1.  Merancang dan membangun arsitektur sistem terintegrasi antara aplikasi mobile Android dan aplikasi web menggunakan teknologi RESTful API yang sesuai dengan kebutuhan operasional PT. Kalbe.
2.  Mengembangkan mekanisme sinkronisasi data yang handal untuk menangani transaksi harian dan backdate, sehingga menjamin validitas dan konsistensi data stok antara pengguna lapangan dan sistem pusat.
3.  Mengevaluasi peningkatan efektivitas tata kelola distribusi dan kecepatan pelaporan aktivitas penjualan setelah implementasi sistem Mobile-Web terintegrasi.

# 1.5 Manfaat Penelitian

Penelitian ini diharapkan dapat memberikan manfaat baik secara teoritis maupun praktis, sebagai berikut:

### 1. Manfaat Teoritis
*   Memberikan kontribusi pada pengembangan ilmu pengetahuan di bidang Rekayasa Perangkat Lunak, khususnya terkait implementasi arsitektur Mobile-Web dan teknik sinkronisasi data pada sistem distribusi.
*   Menjadi referensi bagi penelitian selanjutnya yang membahas topik integrasi sistem informasi dan pengembangan aplikasi enterprise berbasis mobile.

### 2. Manfaat Praktis
*   **Bagi Instansi (PT. Kalbe)**: Memberikan dokumentasi ilmiah dan analisis teknis terhadap sistem yang telah berjalan.
*   **Bagi Penulis**: Menerapkan ilmu dan teori yang didapat selama perkuliahan ke dalam kasus nyata di industri, serta meningkatkan kompetensi teknis dalam pengembangan sistem skala industri.
*   **Bagi Pihak Lain**: Menambah referensi kepustakaan bagi mahasiswa atau peneliti lain yang tertarik pada topik integrasi sistem informasi berbasis mobile dan web.

# 1.6 Metode Penelitian

Metode penelitian yang digunakan untuk mencapai tujuan penelitian ini disusun secara sistematis meliputi:

### 1. Jenis dan Pendekatan Penelitian
Penelitian ini merupakan penelitian terapan (applied research) dengan pendekatan kualitatif. Fokus utama adalah merancang dan mengimplementasikan solusi teknologi untuk memecahkan permasalahan operasional distribusi yang spesifik.

### 2. Sumber Data
Data yang digunakan dalam penelitian ini dikelompokkan menjadi dua sumber:
*   **Data Primer**: Data yang diperoleh secara langsung dari sumber aslinya, yaitu hasil observasi terhadap alur sistem dan hasil wawancara dengan pembimbing lapangan mengenai spesifikasi kebutuhan.
*   **Data Sekunder**: Data pendukung yang diperoleh dari dokumentasi teknis, jurnal ilmiah, buku referensi, dan sumber pustaka lain yang relevan dengan teknologi mobile-web dan RESTful API.

### 3. Teknik Pengumpulan Data
*   **Observasi**: Melakukan pengamatan terhadap alur proses sistem aplikasi web dan mobile yang sedang dalam tahap pengembangan untuk memahami mekanisme kerja dan interaksi antar modul.
*   **Wawancara**: Melakukan tanya jawab dengan supervisor atau pembimbing lapangan di tempat pembuatan sistem untuk menggali kebutuhan sistem dan spesifikasi fitur yang diharapkan.
*   **Studi Pustaka**: Mempelajari literatur teknis, jurnal, dan dokumentasi terkait teknologi Android, RESTful API, dan sistem distribusi.

### 4. Metode Pengembangan Sistem
Metode pengembangan perangkat lunak yang digunakan adalah **SDLC (System Development Life Cycle)** model Waterfall, yang menjadi prosedur utama penelitian ini:
*   **Analisis Kebutuhan**: Mengidentifikasi kebutuhan fungsional dan non-fungsional sistem.
*   **Desain Sistem**: Merancang arsitektur, basis data, dan antarmuka pengguna (User Interface/User Experience).
*   **Implementasi**: Penulisan kode program (coding) untuk aplikasi mobile (Flutter) dan web (PHP).
*   **Pengujian**: Melakukan Black Box Testing untuk memastikan fungsi berjalan sesuai spesifikasi.
*   **Pemeliharaan**: Perbaikan dan penyesuaian sistem berdasarkan hasil pengujian.

### 5. Teknik Analisis Data
Teknik analisis data yang digunakan adalah analisis deskriptif kualitatif. Data kebutuhan yang terkumpul dianalisis dan dimodelkan menggunakan diagram UML (Unified Modeling Language) untuk mendefinisikan struktur dan perilaku sistem sebelum tahap implementasi.

# 1.7 Sistematika Penulisan

Untuk memberikan gambaran yang jelas mengenai isi laporan penelitian ini, sistematika penulisan disusun sebagai berikut:

**BAB I: PENDAHULUAN**
Bab ini menguraikan latar belakang masalah, perumusan masalah, batasan masalah, tujuan penelitian, manfaat penelitian (teoritis dan praktis), metode penelitian, serta sistematika penulisan laporan.

**BAB II: TINJAUAN PUSTAKA**
Bab ini berisi landasan teori yang mendukung penelitian, meliputi konsep dasar sistem informasi, teori pengembangan perangkat lunak, serta tinjauan teknologi yang digunakan seperti Android, Web Architecture, RESTful API, dan Database Management System.

**BAB III: METODOLOGI PENELITIAN**
Bab ini menjelaskan secara rinci metode penelitian yang digunakan, mulai dari kerangka kerja penelitian, analisis kebutuhan sistem, perancangan arsitektur dan basis data, hingga rencana pengujian sistem.

**BAB IV: HASIL DAN PEMBAHASAN**
Bab ini memaparkan hasil implementasi sistem yang telah dibangun, meliputi tampilan antarmuka, potongan kode program utama, serta hasil pengujian dan evaluasi terhadap efektivitas sistem dalam menjawab rumusan masalah.

**BAB V: PENUTUP**
Bab ini berisi kesimpulan dari seluruh rangkaian penelitian yang telah dilakukan serta saran-saran untuk pengembangan sistem lebih lanjut di masa mendatang.
