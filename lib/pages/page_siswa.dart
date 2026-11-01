
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/siswa.dart';
import '../theme/app_theme.dart';
import 'page_input_siswa.dart';

class PageSiswa extends StatefulWidget {
  const PageSiswa({super.key});

  @override
  State<PageSiswa> createState() => _PageSiswaState();
}

class _PageSiswaState extends State<PageSiswa> {
  List<Siswa> siswaList = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadSiswa();
  }

  Future<void> loadSiswa() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final response = await ApiConfig.get('/siswa');
      final List data = response['data'];

      siswaList = data.map((item) => Siswa.fromJson(item)).toList();
    } catch (e) {
      error = e.toString();
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> deleteSiswa(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.white,
        title: const Text('Hapus Data Siswa'),
        content: const Text('Yakin ingin menghapus data siswa ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ApiConfig.delete('/siswa/$id');
      await loadSiswa();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data siswa berhasil dihapus')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget siswaCard(Siswa siswa) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: AppTheme.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.softBeige,
                child: const Icon(
                  Icons.school_rounded,
                  color: AppTheme.brown,
                ),
              ),
              const Spacer(),
              Text(
                'ID ${siswa.id}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            siswa.namaLengkap,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'NIPD: ${siswa.nipd}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${siswa.kelas} • ${siswa.jurusan}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.brown,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppTheme.softBeige),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageInputSiswa(siswa: siswa),
                      ),
                    );
                    loadSiswa();
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.brown,
                    side: const BorderSide(color: AppTheme.beige),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => deleteSiswa(siswa.id),
                icon: const Icon(Icons.delete_outline_rounded),
                color: Colors.redAccent,
                tooltip: 'Hapus',
              ),
            ],
          ),
        ],
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
        title: const Text(
          'Data Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelola Data Siswa',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Daftar informasi siswa yang tersimpan.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PageInputSiswa(),
                          ),
                        );
                        loadSiswa();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Siswa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brown,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: loadSiswa,
                      icon: const Icon(Icons.refresh),
                      color: AppTheme.brown,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : error.isNotEmpty
                      ? Center(child: Text(error))
                      : siswaList.isEmpty
                      ? const Center(
                    child: Text('Belum ada data siswa.'),
                  )
                      : LayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                      constraints.maxWidth > 650 ? 2 : 1;

                      return GridView.builder(
                        itemCount: siswaList.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: 235,
                        ),
                        itemBuilder: (context, index) {
                          return siswaCard(siswaList[index]);
                        },
                      );
                    },
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
