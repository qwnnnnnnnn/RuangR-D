class Siswa {
  final int id;
  final String nipd;
  final String namaLengkap;
  final String jenisKelamin;
  final String alamat;
  final String kelas;
  final String jurusan;

  Siswa({
    required this.id,
    required this.nipd,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.alamat,
    required this.kelas,
    required this.jurusan,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: int.parse(json['id'].toString()),
      nipd: json['nipd'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      alamat: json['alamat'] ?? '',
      kelas: json['kelas'] ?? '',
      jurusan: json['jurusan'] ?? '',
    );
  }
}
