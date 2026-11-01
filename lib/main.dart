
import 'package:flutter/material.dart';
import 'config/api_config.dart';
import 'pages/page_login.dart';
import 'pages/page_dashboard.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RuangRD());
}

class RuangRD extends StatelessWidget {
  const RuangRD({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RuangR&D',
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.background,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.brown,
        ),
      ),
      home: const CheckLogin(),
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ApiConfig.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data != null) {
          return const PageDashboard(nama: 'Pengguna');
        }

        return const PageLogin();
      },
    );
  }
}
