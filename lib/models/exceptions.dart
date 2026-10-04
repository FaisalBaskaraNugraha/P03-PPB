/// Class ini adalah Exception buatan sendiri yang diturunkan dari class bawaan Dart `Exception`.
/// Digunakan khusus untuk menandai pelanggaran aturan domain peminjaman.
class EquipmentUnavailableException implements Exception {
  /// Menyimpan nama barang yang gagal dipinjam
  final String equipmentName;

  /// Menyimpan alasan spesifik kenapa barang tidak bisa dipinjam
  final String reason;

  /// Constructor untuk menerima nama barang dan alasannya saat exception ini dilempar
  EquipmentUnavailableException(this.equipmentName, this.reason);

  /// Method [toString] di-override agar saat exception di-print ke konsol,
  /// pesan kesalahan yang muncul mudah dibaca dan informatif.
  @override
  String toString() =>
      'EquipmentUnavailableException: "$equipmentName" tidak dapat dipinjam ($reason).';
}