// File ini menyimpan daftar nilai konstan/terbatas (enum)
// untuk mencegah penggunaan String bebas yang rentan salah ketik (typo).

enum RentalStatus {
  // Transaksi sedang berjalan, barang belum dikembalikan
  active,

  // Barang sudah dikembalikan tepat waktu
  returned,

  // Barang dikembalikan melebihi batas waktu yang ditentukan
  late,
}