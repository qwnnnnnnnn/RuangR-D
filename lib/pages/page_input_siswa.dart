
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/siswa.dart';
import '../theme/app_theme.dart';

class PageInputSiswa extends StatefulWidget {
  final Siswa? siswa;

  const PageInputSiswa({super.key, this.siswa});

  @override
  State<PageInputSiswa> createState() => _PageInputSiswaState();
}

class _PageInputSiswaState extends State<PageInputSiswa> {
  final nipdController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final kelasController = TextEditingController();
  final jurusanController = TextEditingController();

  String? jenisKelamin;
  bool loading = false;

  bool get isEdit => widget.siswa != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final siswa = widget.siswa!;
      nipdController.text = siswa.nipd;
      namaController.text = siswa.namaLengkap;
      alamatController.text = siswa.alamat;
      kelasController.text = siswa.kelas;
      jurusanController.text = siswa.jurusan;
      jenisKelamin = siswa.jenisKelamin;
    }
  }

  @override
  void dispose() {
    nipdController.dispose();
    namaController.dispose();
    alamatController.dispose();
    kelasController.dispose();
    jurusanController.dispose();
    super.dispose();
  }

  Future<void> saveSiswa() async {
    if (nipdController.text.trim().isEmpty ||
        namaController.text.trim().isEmpty ||
        jenisKelamin == null ||
        kelasController.text.trim().isEmpty ||
        jurusanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi data wajib terlebih dahulu')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final body = {
      'nipd': nipdController.text.trim(),
      'nama_lengkap': namaController.text.trim(),
      'jenis_kelamin': jenisKelamin,
      'alamat': alamatController.text.trim(),
      'kelas': kelasController.text.trim(),
      'jurusan': jurusanController.text.trim(),
    };

    try {
      if (isEdit) {
        await ApiConfig.put('/siswa/${widget.siswa!.id}', body);
      } else {
        await ApiConfig.post('/siswa', body);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Data siswa berhasil diperbarui'
                : 'Data siswa berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Widget textInput({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppTheme.beige),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppTheme.beige),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppTheme.brown),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.brown,
        elevation: 0,
        title: Text(isEdit ? 'Edit Data Siswa' : 'Tambah Data Siswa'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(25),
            decoration: AppTheme.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Perbarui Data Siswa' : 'Input Data Siswa',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan masukkan data sesuai informasi siswa.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 24),
                textInput(
                  label: 'NIPD',
                  controller: nipdController,
                ),
                const SizedBox(height: 15),
                textInput(
                  label: 'Nama Lengkap',
                  controller: namaController,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: jenisKelamin,
                  decoration: InputDecoration(
                    labelText: 'Jenis Kelamin',
                    filled: true,
                    fillColor: AppTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(color: AppTheme.beige),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(color: AppTheme.beige),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      jenisKelamin = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                textInput(
                  label: 'Alamat',
                  controller: alamatController,
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                textInput(
                  label: 'Kelas',
                  controller: kelasController,
                ),
                const SizedBox(height: 15),
                textInput(
                  label: 'Jurusan',
                  controller: jurusanController,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : saveSiswa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      isEdit ? 'Simpan Perubahan' : 'Simpan Data',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
