
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled3/booking/servicecard.dart';
import 'package:untitled3/booking/sevice_model.dart';
import '../apis/doctor_api_service.dart';
import 'doctors_screen.dart';

class ServiceGridScreen extends StatelessWidget {
  final List<Servicemodel> services = [
    Servicemodel("General", 'assets/images/051_Doctor 1.png'),
    Servicemodel("Heart Disease", 'assets/images/037_Heart.png'),
    Servicemodel("Dentistry", 'assets/images/007_Tooth.png'),
    Servicemodel("Stomach", 'assets/images/036_Stomach.png'),
    Servicemodel("Liver", 'assets/images/049_Liver.png'),
    Servicemodel("Kidney", 'assets/images/047_Kidney.png'),
    Servicemodel("Bones", 'assets/images/022_Broken_Bone.png'),
  ];

  final ApiServiceDoctor _apiService = ApiServiceDoctor();

  String _mapServiceToApiKey(String serviceTitle) {
    switch (serviceTitle) {
      case 'General':
        return 'General Surgery';
      case 'Heart Disease':
        return 'Cardiology';
      case 'Dentistry':
        return 'Dentistry';
      case 'Stomach':
        return 'Gastroenterology';
      case 'Liver':
        return 'Liver';
      case 'Kidney':
        return 'Kidney';
      case 'Bones':
        return 'Orthopedics';
      default:
        throw Exception('Unknown service: $serviceTitle');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleServiceTap(
      BuildContext context, Servicemodel service) async {
    try {
      final doctors = await _apiService
          .getDoctorsBySpecialty(_mapServiceToApiKey(service.title));

      if (!context.mounted) return;

      if (doctors.isEmpty) {
        _showSnackBar(context, 'No doctors found for ${service.title}');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorScreen(
            specialty: _mapServiceToApiKey(service.title),
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      _showSnackBar(context, 'Failed to load doctors. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Services",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 16),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return ServiceCard(
              service: services[index],
              onTap: () => _handleServiceTap(context, services[index]),
            );
          },
        ),
      ),
    );
  }
}
