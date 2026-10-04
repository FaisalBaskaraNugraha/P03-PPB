import 'package:flutter/foundation.dart';
import 'enums.dart';
import 'equipment.dart';
import 'exceptions.dart';
import 'member.dart';
import 'mixins.dart';

/// Class Transaksi yang menggabungkan Member dan Equipment (KOMPOSISI)
/// serta memanfaatkan `mixin Loggable` dengan kata kunci `with`.
class RentalTransaction with Loggable {
  /// ID unik transaksi
  final String id;

  /// Komposisi: Transaksi menyimpan objek `Member` utuh
  final Member member;

  /// Komposisi: Transaksi menyimpan objek `Equipment` utuh
  final Equipment equipment;

  /// Waktu peminjaman dilakukan (wajib ada sejak awal/non-nullable)
  final DateTime borrowedAt;

  /// Meaningful Null Safety: `returnedAt` bertipe `DateTime?` (nullable)
  /// karena saat transaksi pertama kali dibuat, barang BELUM dikembalikan (nilainya null).
  DateTime? returnedAt;

  /// Status transaksi menggunakan Enum `RentalStatus`
  RentalStatus status;

  /// Constructor dilengkapi dengan Initializer List dan Validasi Aturan Domain
  RentalTransaction({
    required this.id,
    required this.member,
    required this.equipment,
    required this.borrowedAt,
  }) : status = RentalStatus.active {
    // 1. ATURAN DOMAIN: Cek ketersediaan barang sebelum transaksi sah dibuat
    if (!equipment.isAvailable) {
      // Jika barang sedang dipinjam/tidak tersedia, hentikan program dengan Exception buatan sendiri
      throw EquipmentUnavailableException(
        equipment.name,
        'Barang sedang dipinjam oleh anggota lain',
      );
    }

    // 2. UBAH STATE: Jika valid, tandai barang menjadi tidak tersedia
    equipment.isAvailable = false;

    // 3. PANGGUL METHOD DARI MIXIN: Catat aktivitas pembuat transaksi
    logAction('Transaksi $id dibuat untuk ${member.name} (${equipment.name}).');
  }

  /// Method untuk memproses pengembalian alat dan mengevaluasi keterlambatan
  void returnEquipment(DateTime returnDate) {
    // Pelindung agar transaksi yang sudah selesai tidak bisa dikembalikan dua kali
    if (status == RentalStatus.returned || status == RentalStatus.late) {
      // debugPrint menggantikan print() standar untuk mematuhi aturan linting Flutter
      debugPrint('Info: Transaksi $id sudah ditutup sebelumnya.');
      return;
    }

    // Set tanggal pengembalian nyata (mengubah variabel nullable menjadi terisi)
    returnedAt = returnDate;

    // Kembalikan status ketersediaan alat menjadi true agar bisa dipinjam lagi
    equipment.isAvailable = true;

    // Menghitung batas waktu peminjaman (misal: durasi pinjam maksimal 7 hari)
    final dueDate = borrowedAt.add(const Duration(days: 7));

    // Evaluasi apakah tanggal pengembalian melewati batas waktu (dueDate)
    if (returnDate.isAfter(dueDate)) {
      status = RentalStatus.late; // Ubah status enum menjadi 'late'
      logAction('Transaksi $id dikembalikan TERLAMBAT.');
    } else {
      status = RentalStatus.returned; // Ubah status enum menjadi 'returned'
      logAction('Transaksi $id dikembalikan TEPAT WAKTU.');
    }
  }
}