import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/doctor_model.dart';
import '../../booking/doctorcard.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Doctor> favoriteDoctors;
  final Function(Doctor) onFavoriteToggled;

  const FavoritesScreen({
    super.key,
    required this.favoriteDoctors,
    required this.onFavoriteToggled,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Doctor> _favoriteDoctors;

  @override
  void initState() {
    super.initState();
    _favoriteDoctors = widget.favoriteDoctors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Doctors',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: widget.favoriteDoctors.isEmpty
          ? _buildEmptyState()
          : _buildDoctorsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No Favorite Doctors yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList() {
    return ListView.builder(
      itemCount: _favoriteDoctors.length,
      itemBuilder: (ctx, index) => DoctorCard(
        doctor: _favoriteDoctors[index],
        onFavoriteToggled: (updated) {
          if (!updated.isFavorite!) {
            setState(() => _favoriteDoctors.remove(updated));
          }
          widget.onFavoriteToggled(updated);
        },
      ),
    );
  }
}
