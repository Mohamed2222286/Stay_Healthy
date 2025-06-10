import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';

class ApiServiceDoctor {
  static const String _baseUrl = 'https://api.jsonbin.io/v3/b/68113e508960c979a58febd0';
  static String _authToken = 'your-master-key-here';
  static DateTime? _tokenExpiry;

  Future<Map<String, String>> _getHeaders() async {
    if (_isTokenExpired()) {
      await _refreshToken();
    }
    return {
      'X-Master-Key': _authToken,
      'Content-Type': 'application/json',
      'X-Bin-Versioning': 'false'
    };
  }

  bool _isTokenExpired() => _tokenExpiry?.isBefore(DateTime.now()) ?? true;

  Future<void> _refreshToken() async {
    // Token refresh implementation
  }

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400: return 'Bad request';
      case 401: return 'Unauthorized - check key';
      case 404: return 'Data not found';
      case 500: return 'Server error';
      default: return 'Request failed (code: $statusCode)';
    }
  }

  String _handleGenericError(dynamic error) {
    if (error is http.ClientException) return 'Connection error';
    if (error is TimeoutException) return 'Timeout';
    return 'Unexpected error: ${error.toString()}';
  }

  Future<Doctor> toggleFavorite(String doctorId, bool isFavorite) async {
    try {
      final headers = await _getHeaders();
      final currentResponse = await http.get(Uri.parse(_baseUrl), headers: headers);

      if (currentResponse.statusCode != 200) {
        throw Exception(_handleError(currentResponse.statusCode));
      }

      final Map<String, dynamic> fullData = json.decode(currentResponse.body)['record'];
      final categories = fullData['categories'] as Map<String, dynamic>;
      bool doctorFound = false;

      categories.forEach((key, category) {
        final List<dynamic> doctors = (category['data'] as List);
        final index = doctors.indexWhere((doc) => doc['id']?.toString() == doctorId);
        if (index != -1) {
          doctors[index]['isFavorite'] = isFavorite;
          doctorFound = true;
        }
      });

      if (!doctorFound) throw Exception('Doctor not found');

      final updateResponse = await http.put(
        Uri.parse(_baseUrl),
        headers: headers,
        body: json.encode(fullData),
      );

      if (updateResponse.statusCode == 200) {
        return _findDoctorById(json.decode(updateResponse.body)['record'], doctorId);
      } else {
        throw Exception(_handleError(updateResponse.statusCode));
      }
    } catch (e) {
      throw Exception(_handleGenericError(e));
    }
  }

  Doctor _findDoctorById(Map<String, dynamic> data, String doctorId) {
    final categories = data['categories'] as Map<String, dynamic>;
    for (final category in categories.values) {
      final doctors = (category['data'] as List)
          .map((doc) => Doctor.fromJson(doc))
          .toList();
      try {
        return doctors.firstWhere((doc) => doc.id == doctorId);
      } catch (_) {}
    }
    throw Exception('Doctor not found after update');
  }

  Future<ApiResponse> getDoctors() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body)['record']);
      } else {
        throw Exception(_handleError(response.statusCode));
      }
    } catch (e) {
      throw Exception(_handleGenericError(e));
    }
  }

  Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final record = data['record'] as Map<String, dynamic>? ?? {};
        final categories = record['categories'] as Map<String, dynamic>? ?? {};
        final specialtyData = categories[specialty];

        if (specialtyData == null) throw Exception('Specialty not found');

        return (specialtyData['data'] as List?)
            ?.map((d) => Doctor.fromJson(d))
            .toList() ?? [];
      } else {
        throw Exception(_handleError(response.statusCode));
      }
    } catch (e) {
      throw Exception(_handleGenericError(e));
    }
  }
}