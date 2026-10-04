//Class yang merepresentasikan barang/alat laboratorium.



class Equipment {
  // ID unik barang (non-nullable, final)
  final String id;

  // Nama alat/barang (non-nullable, final)
  final String name;

  // Status ketersediaan barang.
  // Berbeda dari field lain, field ini TIDAK `final` karena nilainya
  // akan berubah secara dinamis saat dipinjam atau dikembalikan.
  bool isAvailable;

  // Constructor dengan nilai bawaan (default value) `isAvailable = true`
  Equipment({
    required this.id,
    required this.name,
    this.isAvailable = true,
  });
}