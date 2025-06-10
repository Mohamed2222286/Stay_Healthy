import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = "http://192.168.1.3:8000/predict";
  static const String baseUrl = "http://127.0.0.1:8000/predict";

  static Future<Map<String, dynamic>> predictHeartDisease({
    required double bmi,
    required String smoking,
    required String alcoholDrinking,
    required String diffWalking,
    required String sex,
    required String ageCategory,
    required String diabetic,
    required String physicalActivity,
    required String asthma,
    required String kidneyDisease,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'BMI': bmi,
          'Smoking': smoking,
          'AlcoholDrinking': alcoholDrinking,
          'DiffWalking': diffWalking,
          'Sex': sex,
          'AgeCategory': ageCategory,
          'Diabetic': diabetic,
          'PhysicalActivity': physicalActivity,
          'Asthma': asthma,
          'KidneyDisease': kidneyDisease,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get prediction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}