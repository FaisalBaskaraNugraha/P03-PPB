import 'package:flutter/material.dart';
import '../models/equipment.dart';
import '../models/member.dart';
import '../models/rental_transaction.dart';

/// Class Layar Form Peminjaman
class AddRentalScreen extends StatefulWidget {
  /// Menerima daftar alat yang `isAvailable == true` dari Layar 1
  final List<Equipment> availableEquipments;

  const AddRentalScreen({super.key, required this.availableEquipments});

  @override
  State<AddRentalScreen> createState() => _AddRentalScreenState();
}

class _AddRentalScreenState extends State<AddRentalScreen> {
  // ---------------------------------------------------------------------------
  // CONTROLLER & FORM KEY (Sangat penting untuk Validasi Form)
  // ---------------------------------------------------------------------------

  /// GlobalKey digunakan untuk mengakses State internal dari Form widget
  /// dan mengeksekusi perintah validasi (`_formKey.currentState!.validate()`).
  final _formKey = GlobalKey<FormState>();

  /// TextEditingController membaca dan mengontrol isi inputan teks nama peminjam
  final _nameController = TextEditingController();

  /// State lokal untuk menyimpan barang yang dipilih dari Dropdown
  Equipment? _selectedEquipment;

  /// KELOLA MEMORI: dispose() dipanggil otomatis saat widget ini dihancurkan/ditutup.
  /// Wajib memanggil controller.dispose() untuk MENCEGAH KEBOCORAN MEMORI (Memory Leak).
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // LOGIKA PENGIRIMAN FORM
  // ---------------------------------------------------------------------------
  void _submitForm() {
    // 1. JALANKAN VALIDASI TEKS:
    // Menjalankan fungsi validator pada setiap TextFormField di dalam Form ini.
    // Jika ada yang mengembalikan String error, validate() bernilai false.
    if (_formKey.currentState!.validate()) {
      
      // 2. VALIDASI MANUAL DROPDOWN:
      if (_selectedEquipment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih alat yang ingin dipinjam!')),
        );
        return; // Hentikan eksekusi jika dropdown belum dipilih
      }

      // 3. INSTANSIASI MODEL DOMAIN (Menerapkan Domain P02):
      final newMember = Member(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text, // Membaca string hasil ketikan user
      );

      // Constructor RentalTransaction otomatis mengubah `_selectedEquipment.isAvailable` menjadi `false`
      final newTransaction = RentalTransaction(
        id: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
        member: newMember,
        equipment: _selectedEquipment!,
        borrowedAt: DateTime.now(),
      );

      // 4. NAVIGASI MUNDUR (Layar 3 -> Layar 1):
      // Navigator.pop menutup layar form dan MENGIRIMKAN objek `newTransaction`
      // kembali ke Layar 1 sebagai return value dari `Navigator.push`.
      Navigator.pop(context, newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        // Form Widget bertindak sebagai container penampung inputan yang akan divalidasi
        child: Form(
          key: _formKey, // Memasang identitas key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // INPUT 1: TEKS NAMA PEMINJAM (TextFormField)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Peminjam',
                  border: OutlineInputBorder(),
                ),
                
                // FUNGSI VALIDATOR: Memeriksa isi inputan
                validator: (value) {
                  // Jika value null atau hanya berisi spasi kosong
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama peminjam wajib diisi!'; // Pesan merah yang akan muncul di bawah input
                  }
                  return null; // Return null menandakan input valid!
                },
              ),
              const SizedBox(height: 16),

              // INPUT 2: DROPDOWN ALAT (DropdownButtonFormField)
              DropdownButtonFormField<Equipment>(
                decoration: const InputDecoration(
                  labelText: 'Pilih Alat Lab',
                  border: OutlineInputBorder(),
                ),
                
                // Mengubah List<Equipment> menjadi List<DropdownMenuItem>
                items: widget.availableEquipments.map((eq) {
                  return DropdownMenuItem(
                    value: eq,
                    child: Text(eq.name),
                  );
                }).toList(),
                
                // Callback saat user memilih salah satu opsi dropdown
                onChanged: (value) {
                  // Simpan item yang dipilih ke dalam state lokal
                  setState(() => _selectedEquipment = value);
                },
                
                // Validator untuk memastikan dropdown tidak dibiarkan kosong
                validator: (value) => value == null ? 'Wajib memilih alat!' : null,
              ),
              const SizedBox(height: 24),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm, // Memanggil fungsi validasi dan simpan di atas
                  child: const Text('Simpan Transaksi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}