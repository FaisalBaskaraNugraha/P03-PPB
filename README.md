P03 — Lab Rental App
Aplikasi Flutter sederhana untuk mengelola inventaris dan transaksi peminjaman alat laboratorium secara real-time.
Apa Aplikasi Ini?
Lab Rental App adalah aplikasi manajemen laboratorium yang memfasilitasi pencatatan peminjaman dan pengembalian alat lab.
    • Layar Utama: Menampilkan daftar inventaris alat beserta indikator ketersediaan (Tersedia / Dipinjam) menggunakan custom widget StatusBadge.
    • Layar Detail: Menampilkan riwayat transaksi alat dan menyediakan fungsi pengembalian barang.
    • Layar Form: Memungkinkan pencatatan peminjaman baru dengan validasi input dan pembaruan status alat secara otomatis.
    
Bug Paling Menantang & Cara Menemukannya
Masalah: Badge Status Alat Tidak Memperbarui Tampilan di Layar Utama
    • Deskripsi Bug: Saat pengguna kembali dari Layar Form (setelah berhasil membuat peminjaman) atau Layar Detail (setelah mengembalikan alat), status alat di Layar Utama tetap menunjukkan Tersedia, meskipun data isAvailable pada objek model sudah berubah menjadi false.
    • Cara Menemukannya:
        1. Melakukan penelusuran (debugging) dengan menambahkan debugPrint(item.isAvailable) sebelum dan sesudah navigasi. Data di memori terbukti sudah berubah menjadi false.
        2. Memeriksa alur navigasi pada ListTile.onTap dan FloatingActionButton.onPressed.
        3. Ditemukan bahwa panggilan Navigator.push() bersifat asynchronous (Future), tetapi pembaruan UI di layar utama tidak dipicu kembali setelah halaman yang dipush ditutup (pop).
    • Solusi: Menambahkan kata kunci await pada pemanggilan Navigator.push() dan mengeksekusi setState(() {}) setelah proses await selesai. Hal ini memaksa EquipmentListScreen merefresh UI dengan data state terbaru.
