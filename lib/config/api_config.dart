
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String baseUrl = 'http://192.168.1.8:3000/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, String>> headers() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic handleResponse(http.Response response) {
    final body = response.body;
    dynamic data;

    try {
      data = body.isNotEmpty ? jsonDecode(body) : null;
    } catch (e) {
      throw Exception(
        'Respons bukan JSON. Status: ${response.statusCode}. '
            'Isi respons: ${body.substring(0, body.length > 300 ? 300 : body.length)}',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(
      data is Map
          ? data['message'] ?? 'Terjadi kesalahan'
          : 'Terjadi kesalahan: ${response.statusCode}',
    );
  }

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await headers(),
    );

    return handleResponse(response);
  }

  static Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await headers(),
      body: jsonEncode(body),
    );

    return handleResponse(response);
  }

  static Future<dynamic> put(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await headers(),
      body: jsonEncode(body),
    );

    return handleResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await headers(),
    );

    return handleResponse(response);
  }
}
