import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/rental_transaction.dart';
import '../widgets/status_badge.dart';
import 'add_rental_screen.dart';
import 'equipment_detail_screen.dart';

/// Class Layar Utama menggunakan `StatefulWidget` karena layar ini MENYIMPAN STATE
/// daftar barang dan daftar transaksi yang datanya bisa bertambah atau berubah secara dinamis.
class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

/// Class State yang mengelola siklus hidup (lifecycle) dan perubahan tampilan Layar Utama
class _EquipmentListScreenState extends State<EquipmentListScreen> {
  // ---------------------------------------------------------------------------
  // STATE APLIKASI (Hidup di memori selama aplikasi berjalan)
  // ---------------------------------------------------------------------------

  /// List instansiasi objek Equipment yang berfungsi sebagai basis data dummy lokal
  final List<Equipment> _equipments = [
    Equipment(id: 'EQ01', name: 'Oscilloscope Digital'),
    Equipment(id: 'EQ02', name: 'Multimeter Precision'),
    Equipment(id: 'EQ03', name: 'Function Generator'),
  ];

  /// List untuk menampung seluruh objek transaksi peminjaman yang berhasil dibuat
  final List<RentalTransaction> _transactions = [];

  // ---------------------------------------------------------------------------
  // BUILD METHOD (Merender tampilan UI berdasarkan state terbaru)
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar merupakan bilah navigasi bagian atas
      appBar: AppBar(
        title: const Text('Inventaris Alat Lab'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      // ListView.builder digunakan untuk membuat DAFTAR DINAMIS (persyaratan tugas P03).
      // Mengapa builder? Karena hemat memori—hanya merender item yang saat ini tampil di layar.
      body: ListView.builder(
        // Total baris daftar disesuaikan dengan jumlah data di dalam List `_equipments`
        itemCount: _equipments.length,
        
        // itemBuilder dipanggil berulang kali sesuai nilai itemCount untuk merender tiap elemen
        itemBuilder: (context, index) {
          // Mengambil objek Equipment pada posisi indeks tertentu
          final item = _equipments[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              // Title menampilkan nama alat
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              
              // Subtitle menampilkan ID unik alat
              subtitle: Text('ID: ${item.id}'),
              
              // Trailing (sebelah kanan) memanggil Custom Widget `StatusBadge`
              trailing: StatusBadge(isAvailable: item.isAvailable),
              
              // Callback saat salah satu baris item ditekan
              onTap: () async {
                // NAVIGASI MAJU (Layar 1 -> Layar 2)
                // Menggunakan `await` karena kita menunggu user kembali dari Layar Detail
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Mengirimkan objek item dan daftar transaksi spesifik barang tersebut
                    builder: (context) => EquipmentDetailScreen(
                      equipment: item,
                      transactions: _transactions.where((t) => t.equipment.id == item.id).toList(),
                    ),
                  ),
                );

                // MEMANGGIL setState() SETELAH KEMBALI DARI LAYAR 2:
                // Jika di Layar 2 ada aksi pengembalian barang, `item.isAvailable` berubah.
                // Pemanggilan `setState` di sini akan memaksa Layar 1 merender ulang
                // agar badge status ketersediaan di layar utama ikut diperbarui secara real-time.
                setState(() {});
              },
            ),
          );
        },
      ),

      // FloatingActionButton di pojok kanan bawah untuk berpindah ke Form Peminjaman
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // NAVIGASI MAJU (Layar 1 -> Layar 3 / Form)
          // `push<RentalTransaction>` menyatakan kita menunggu objek transaksi yang dikirim saat Navigator.pop()
          final result = await Navigator.push<RentalTransaction>(
            context,
            MaterialPageRoute(
              builder: (context) => AddRentalScreen(
                // Mengirimkan HANYA daftar alat yang statusnya saat ini sedang tersedia (`isAvailable == true`)
                availableEquipments: _equipments.where((e) => e.isAvailable).toList(),
              ),
            ),
          );

          // PENGELOLAAN STATE SETELAH NAVIGASI KEMBALI:
          // Jika `result` tidak null (artinya user menekan tombol simpan dan mengembalikan data transaksi)
          if (result != null) {
            // Kita bungkus penambahan data ke dalam `setState()`
            // Fungsi `setState()` memberitahu Flutter bahwa internal state berubah,
            // sehingga layar utama dipicu untuk merefresh UI (update badge ketersediaan barang).
            setState(() {
              _transactions.add(result);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Pinjam Alat'),
      ),
    );
  }
}