import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const int timeoutSeconds = 30;

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5001/api';
    }
    return 'http://192.168.1.154:5001/api';
  }

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<http.Response> register(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: headers,
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Request timeout: Server took too long to respond');
        },
      );
      return response;
    } on TimeoutException catch (e) {
      throw Exception('Connection timeout: $e');
    } on SocketException catch (e) {
      throw Exception('Network error: Unable to reach server. Make sure the backend is running on port 5001');
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  static Future<http.Response> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Request timeout: Server took too long to respond');
        },
      );
      return response;
    } on TimeoutException catch (e) {
      throw Exception('Connection timeout: $e');
    } on SocketException catch (e) {
      throw Exception('Network error: Unable to reach server. Make sure the backend is running on port 5001');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}
