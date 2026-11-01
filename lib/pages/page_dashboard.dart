
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../theme/app_theme.dart';
import 'page_login.dart';
import 'page_user.dart';
import 'page_siswa.dart';

class PageDashboard extends StatelessWidget {
  final String nama;

  const PageDashboard({super.key, required this.nama});

  Future<void> logout(BuildContext context) async {
    await ApiConfig.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PageLogin()),
          (route) => false,
    );
  }

  Widget menuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(22),
        decoration: AppTheme.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.softBeige,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 32, color: AppTheme.brown),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkBrown,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.muted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Text(
                  'Kelola Data',
                  style: TextStyle(
                    color: AppTheme.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 7),
                Icon(Icons.arrow_forward_rounded,
                    size: 17, color: AppTheme.brown),
              ],
            ),
          ],
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
        elevation: 0,
        title: const Text(
          'RuangR&D',
          style: TextStyle(
            color: AppTheme.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_rounded),
            color: AppTheme.brown,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Halo, $nama. Senang melihatmu kembali.',
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Menu Pengelolaan Data',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    menuCard(
                      context: context,
                      icon: Icons.manage_accounts_rounded,
                      title: 'Data User',
                      description: 'Kelola informasi pengguna aplikasi.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PageUser(),
                          ),
                        );
                      },
                    ),
                    menuCard(
                      context: context,
                      icon: Icons.school_rounded,
                      title: 'Data Siswa',
                      description: 'Kelola informasi data siswa sekolah.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PageSiswa(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.beige,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppTheme.brown,
                        size: 30,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'RuangR&D membantu pengelolaan data menjadi lebih mudah dan terorganisir.',
                          style: TextStyle(
                            color: AppTheme.darkBrown,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
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
