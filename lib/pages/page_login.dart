
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import 'page_dashboard.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  final Color brown = const Color(0xFF795C43);
  final Color cream = const Color(0xFFF8F3EB);

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await ApiConfig.post('/auth/login', {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      final data = response['data'];

      await ApiConfig.saveToken(data['token']);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageDashboard(
            nama: data['user']['nama'] ?? 'Pengguna',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: brown,
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool password = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: password && obscurePassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: brown),
        suffixIcon: password
            ? IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: brown,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        )
            : null,
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE4D7C8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE4D7C8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: brown, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D8C5),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -70,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: const Color(0xFF795C43),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = MediaQuery.of(context).size.width > 750;

                  return Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: brown.withValues(alpha: 0.12),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: desktop
                        ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: 110,
                                color: brown,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'RuangR&D',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: brown,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Ruang pengelolaan data yang praktis, nyaman, dan terorganisir.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: brown.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 35),
                        Expanded(
                          child: loginForm(),
                        ),
                      ],
                    )
                        : loginForm(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.groups_rounded,
          size: 65,
          color: brown,
        ),
        const SizedBox(height: 15),
        Text(
          'RuangR&D',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: brown,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan login untuk melanjutkan',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: brown.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 30),
        inputField(
          label: 'Alamat Email',
          icon: Icons.email_outlined,
          controller: emailController,
        ),
        const SizedBox(height: 18),
        inputField(
          label: 'Password',
          icon: Icons.lock_outline,
          controller: passwordController,
          password: true,
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: loading ? null : login,
            style: ElevatedButton.styleFrom(
              backgroundColor: brown,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
