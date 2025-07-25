import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // For Android Emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // For iOS Simulator
  
  String? _sessionCookie;

  void setSessionCookie(String cookie) {
    _sessionCookie = cookie;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_sessionCookie != null) {
      headers['Cookie'] = _sessionCookie!;
    }
    return headers;
  }

  Future<Map<String, dynamic>> googleAuth(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      // Extract session cookie
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        setSessionCookie(cookies);
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/'),
      headers: _headers,
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/${task.id}/'),
      headers: _headers,
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId/'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }

  Future<Task> toggleTaskStatus(int taskId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/tasks/$taskId/toggle/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to toggle task status');
    }
  }
}