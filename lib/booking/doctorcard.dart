import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled3/apis/doctor_api_service.dart';
import '../models/doctor_model.dart';
import 'doctordetails.dart';
import 'bookmethod.dart';

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  final Function(Doctor) onFavoriteToggled;

  const DoctorCard({
    super.key,
    required this.doctor, required this.onFavoriteToggled,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {

  late bool _isFavorite;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.doctor.isFavorite!;
  }

  @override
  void didUpdateWidget(covariant DoctorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.doctor.isFavorite != oldWidget.doctor.isFavorite) {
      _isFavorite = widget.doctor.isFavorite!;
    }
  }


  void _toggleFavorite() async {
    if (_isUpdating || widget.doctor.id == null) return;

    setState(() => _isUpdating = true);
    try {
      final newStatus = !_isFavorite;
      final updatedDoctor = await ApiServiceDoctor().toggleFavorite(
        widget.doctor.id!,
        newStatus,
      );

      setState(() => _isFavorite = newStatus);
      widget.onFavoriteToggled(updatedDoctor);
    } catch (e) {
      log('Error updating favorite: $e');
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            // _buildDescription(),
            _buildWorkingHours(),
            const SizedBox(height: 8),
            _buildAddress(),
            const SizedBox(height: 25),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          child: Image.network(
            widget.doctor.profileImage.toString(),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctor.name.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.doctor.specialty.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: _isUpdating ? null : _toggleFavorite,
        ),
      ],
    );
  }

  // Widget _buildDescription() {
  Widget _buildWorkingHours() {
    return Padding(
      padding: const EdgeInsets.only(left: 75),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 25, color: Colors.blue),
          const SizedBox(width: 6),
          Text(
            '${widget.doctor.workingHours['start'] ?? '--:--'} - ${widget.doctor.workingHours['end'] ?? '--:--'}',
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Padding(
      padding: const EdgeInsets.only(left: 75),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 25, color: Colors.red),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              widget.doctor.address.toString(),
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(color: Color(0xff9DCEFF)), // Border color
            ),
            onPressed: () => _navigateToDetails(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9DCEFF),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => _navigateToSchedule(context),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff9DCEFF), Color(0xff92a3fd)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DoctorDetailsScreen(doctor: widget.doctor),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Create your tween animations
          const begin = Offset(0.0, 1.0); // Slide from bottom
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          // Add fade transition
          var fadeTween = Tween(begin: 0.0, end: 1.0);
          var fadeAnimation = animation.drive(fadeTween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToSchedule(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScheduleAndPaymentScreen(doctor: widget.doctor),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Create your tween animations
          const begin = Offset(0.0, 1.0); // Slide from bottom
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          // Add fade transition
          var fadeTween = Tween(begin: 0.0, end: 1.0);
          var fadeAnimation = animation.drive(fadeTween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
