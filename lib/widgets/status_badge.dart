import 'package:flutter/material.dart';

/// Class ini adalah WIDGET (Custom Widget) yang bersifat reusable (dapat dipakai ulang).
/// Menggunakan `StatelessWidget` karena widget ini HANYA BERTUGAS Menampilkan UI berdasarkan
/// data [isAvailable] yang diterimanya, tanpa perlu menyimpan state internal yang berubah-ubah.
class StatusBadge extends StatelessWidget {
  /// Property untuk menerima status ketersediaan alat (true = tersedia, false = dipinjam).
  /// Dideklarasikan `final` karena nilainya disuplai dari parent widget dan tidak diubah di dalam class ini.
  final bool isAvailable;

  /// Constructor dengan named parameter `required this.isAvailable`
  /// Kata kunci `super.key` digunakan untuk mengoper identifier unik widget ke superclass StatelessWidget.
  const StatusBadge({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    // Container digunakan untuk membuat kotak dekorasi (padding, warna background, border, border radius)
    return Container(
      // Padding internal: 10 piksel horizontal (kiri-kanan) dan 4 piksel vertikal (atas-bawah)
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      
      // BoxDecoration mengatur gaya visual kotak berdasarkan nilai boolean `isAvailable`
      decoration: BoxDecoration(
        // Operator Ternary (condition ? valueIfTrue : valueIfFalse):
        // Jika isAvailable true -> warna hijau muda, jika false -> warna merah muda
        color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
        
        // Memuat sudut kotak menjadi melengkung (rounded) sebesar 12 piksel
        borderRadius: BorderRadius.circular(12),
        
        // Garis tepi (border) menyesuaikan kondisi ketersediaan
        border: Border.all(
          color: isAvailable ? Colors.green : Colors.red,
        ),
      ),
      
      // Text menampilkan label kondisi barang
      child: Text(
        // Jika true tampilkan 'Tersedia', jika false tampilkan 'Dipinjam'
        isAvailable ? 'Tersedia' : 'Dipinjam',
        style: TextStyle(
          // Warna teks dibuat lebih gelap dari background agar kontras dan mudah dibaca
          color: isAvailable ? Colors.green.shade900 : Colors.red.shade900,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}