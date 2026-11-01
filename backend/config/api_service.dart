import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, String>> headers() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<dynamic>> getData(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await headers(),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(result['message'] ?? 'Gagal mengambil data');
    }

    return result['data'];
  }

  static Future<Map<String, dynamic>> postData(
    String url,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await headers(),
      body: jsonEncode(data),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(result['message'] ?? 'Gagal menyimpan data');
    }

    return result;
  }

  static Future<Map<String, dynamic>> putData(
    String url,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse(url),
      headers: await headers(),
      body: jsonEncode(data),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(result['message'] ?? 'Gagal mengubah data');
    }

    return result;
  }

  static Future<Map<String, dynamic>> deleteData(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: await headers(),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw Exception(result['message'] ?? 'Gagal menghapus data');
    }

    return result;
  }
}