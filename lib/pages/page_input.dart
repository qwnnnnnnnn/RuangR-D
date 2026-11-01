
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class PageInputUser extends StatefulWidget {
  final User? user;

  const PageInputUser({super.key, this.user});

  @override
  State<PageInputUser> createState() => _PageInputUserState();
}

class _PageInputUserState extends State<PageInputUser> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  bool get isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      namaController.text = widget.user!.nama;
      emailController.text = widget.user!.email;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> saveUser() async {
    if (namaController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        (!isEdit && passwordController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi data terlebih dahulu')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final body = {
      'nama': namaController.text.trim(),
      'email': emailController.text.trim(),
      if (passwordController.text.isNotEmpty)
        'password': passwordController.text,
    };

    try {
      if (isEdit) {
        await ApiConfig.put('/users/${widget.user!.id}', body);
      } else {
        await ApiConfig.post('/users', body);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Data user berhasil diperbarui'
                : 'Data user berhasil ditambahkan',
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
    bool password = false,
    bool email = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: password && obscurePassword,
      keyboardType:
      email ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppTheme.background,
        suffixIcon: password
            ? IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
        )
            : null,
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
        title: Text(isEdit ? 'Edit User' : 'Tambah User'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(25),
            decoration: AppTheme.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Perbarui Informasi User' : 'Tambah Pengguna Baru',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan isi informasi pengguna dengan benar.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 25),
                textInput(
                  label: 'Nama Lengkap',
                  controller: namaController,
                ),
                const SizedBox(height: 17),
                textInput(
                  label: 'Alamat Email',
                  controller: emailController,
                  email: true,
                ),
                const SizedBox(height: 17),
                textInput(
                  label: isEdit
                      ? 'Password Baru (Opsional)'
                      : 'Password',
                  controller: passwordController,
                  password: true,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : saveUser,
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
                        : Text(isEdit ? 'Simpan Perubahan' : 'Simpan Data'),
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
