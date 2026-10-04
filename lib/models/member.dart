//Class yang merepresentasikan data peminjam/anggota lab.
class Member {
  // ID anggota wajib ada dan tidak boleh berubah (final, non-nullable)
  final String id;

  // Nama anggota wajib ada (final, non-nullable)
  final String name;

  // Email bersifat opsional (nullable: `String?`),
  // karena tidak semua anggota wajib mendaftarkan alamat email.
  final String? email;

  // Constructor menggunakan Named Parameters dengan kata kunci `required`
  // untuk memastikan id dan name tidak pernah lupa diisi.
  Member({
    required this.id,
    required this.name,
    this.email, // Opsional, jika tidak diisi nilainya akan menjadi `null`
  });
}