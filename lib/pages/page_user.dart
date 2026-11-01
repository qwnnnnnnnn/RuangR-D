import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';
import 'page_input.dart';

class PageUser extends StatefulWidget {
  const PageUser({super.key});

  @override
  State<PageUser> createState() => _PageUserState();
}

class _PageUserState extends State<PageUser> {
  List<User> users = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      error = '';
    });

    try {
      final response = await ApiConfig.get('/users');

      final List data = response['data'] ?? [];

      final loadedUsers =
      data.map((item) => User.fromJson(item)).toList();

      if (!mounted) return;

      setState(() {
        users = loadedUsers;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> deleteUser(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.white,
        title: const Text('Hapus User'),
        content: const Text(
          'Yakin ingin menghapus data user ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await ApiConfig.delete('/users/$id');

      if (!mounted) return;

      await loadUsers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data user berhasil dihapus'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> openInput({User? user}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageInputUser(user: user),
      ),
    );

    if (!mounted) return;

    loadUsers();
  }

  Widget userCard(User user) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: AppTheme.card,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: AppTheme.softBeige,
                child: Text(
                  user.nama.isNotEmpty
                      ? user.nama[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppTheme.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'ID ${user.id}',
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            user.nama,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBrown,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            user.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
          const Spacer(),
          const Divider(color: AppTheme.softBeige),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => openInput(user: user),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                  ),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.brown,
                    side: const BorderSide(
                      color: AppTheme.beige,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: () => deleteUser(user.id),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 21,
                ),
                color: Colors.redAccent,
                tooltip: 'Hapus',
                visualDensity: VisualDensity.compact,
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
          'Data User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 950,
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelola Pengguna',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Daftar pengguna yang terdaftar di RuangR&D.',
                  style: TextStyle(
                    color: AppTheme.muted,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => openInput(),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah User'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brown,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: loadUsers,
                      icon: const Icon(Icons.refresh),
                      color: AppTheme.brown,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: loading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : error.isNotEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppTheme.brown,
                          size: 35,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          error,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: loadUsers,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                      : users.isEmpty
                      ? const Center(
                    child: Text(
                      'Belum ada data user.',
                      style: TextStyle(
                        color: AppTheme.muted,
                      ),
                    ),
                  )
                      : LayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                      constraints.maxWidth > 650
                          ? 2
                          : 1;

                      return GridView.builder(
                        itemCount: users.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: 215,
                        ),
                        itemBuilder: (context, index) {
                          return userCard(users[index]);
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
