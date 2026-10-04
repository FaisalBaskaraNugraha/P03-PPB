import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/rental_transaction.dart';
import '../widgets/status_badge.dart';

/// Class Layar Detail menggunakan `StatefulWidget`
/// agar tombol "Kembalikan Alat" dapat memperbarui status transaksi di layar ini secara langsung.
class EquipmentDetailScreen extends StatefulWidget {
  final Equipment equipment;
  final List<RentalTransaction> transactions;

  const EquipmentDetailScreen({
    super.key,
    required this.equipment,
    required this.transactions,
  });

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // `widget.equipment` digunakan untuk mengakses properti yang ada di StatefulWidget parent
        title: Text(widget.equipment.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row untuk menyusun ID dan Badge secara mendatar (horizontal)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kode: ${widget.equipment.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // PENGGUNAAN kEDUA DARI CUSTOM WIDGET (Memenuhi kriteria tugas P03)
                StatusBadge(isAvailable: widget.equipment.isAvailable),
              ],
            ),
            const Divider(height: 30),
            
            Text(
              'Riwayat Transaksi (${widget.transactions.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Expanded mengisi sisa ruang vertikal yang tersedia dalam Column
            Expanded(
              // Operator Ternary: Jika daftar transaksi kosong, tampilkan teks placeholder
              child: widget.transactions.isEmpty
                  ? const Center(child: Text('Belum ada riwayat peminjaman.'))
                  : ListView.builder(
                      itemCount: widget.transactions.length,
                      itemBuilder: (context, index) {
                        final trx = widget.transactions[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text('Peminjam: ${trx.member.name}'),
                          subtitle: Text('Status: ${trx.status.name}'),
                        );
                      },
                    ),
            ),

            // KONDISIONAL RENDERING WIDGET:
            // Tombol "Kembalikan Alat Ini" HANYA MUNCUL jika barang sedang dipinjam (`!isAvailable`)
            if (!widget.equipment.isAvailable)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    // Cari transaksi aktif yang barangnya belum dikembalikan (`returnedAt == null`)
                    final activeTrx = widget.transactions.firstWhere(
                      (t) => t.equipment.id == widget.equipment.id && t.returnedAt == null,
                    );

                    // PANGGIL setState UNTUK MENGUBAH STATE LOKAL & MODEL DOMAIN
                    setState(() {
                      // Method domain OOP P02 dipanggil: memulihkan status isAvailable = true
                      activeTrx.returnEquipment(DateTime.now());
                    });

                    // Tampilkan notifikasi pop-up (SnackBar)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alat berhasil dikembalikan!')),
                    );
                  },
                  child: const Text('Kembalikan Alat Ini', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}