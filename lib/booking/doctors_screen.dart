
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:untitled3/booking/doctorcard.dart';
import '../apis/doctor_api_service.dart';
import '../models/doctor_model.dart';

class DoctorScreen extends StatefulWidget {
  final String specialty;

  const DoctorScreen({Key? key, required this.specialty}) : super(key: key);

  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late Future<List<Doctor>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = ApiServiceDoctor().getDoctorsBySpecialty(widget.specialty);
  }

  List<Doctor> _favoriteDoctors = [];

  void _handleFavoriteToggled(Doctor updatedDoctor) {
    setState(() {
      if (updatedDoctor.isFavorite!) {
        _favoriteDoctors.add(updatedDoctor);
      } else {
        _favoriteDoctors.removeWhere((doc) => doc.id == updatedDoctor.id);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.specialty,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: FutureBuilder<List<Doctor>>(
          future: _doctorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Transform.scale(
                  scale: 0.2,
                  child: Container(
                    color: Colors.transparent,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      colors: const [
                        Color(0xff92A3FD),
                        Color(0xff9DCEFF),
                        Colors.blue,
                      ],
                      strokeWidth: 30,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('error ${snapshot.error}'));
            }

            final doctors = snapshot.data ?? [];

            if (doctors.isEmpty) {
              return Center(child: Text('No Doctors '));
            }

            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return DoctorCard(doctor: doctor , onFavoriteToggled: _handleFavoriteToggled,);
              },
            );
          },
        ),
      ),
    );
  }
}
