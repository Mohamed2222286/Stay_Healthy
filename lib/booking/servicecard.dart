
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/booking/sevice_model.dart';

class ServiceCard extends StatelessWidget {
  final Servicemodel service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 200,
          width: 130,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff92A3FD),
            ),
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 0.5,
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(service.imagePath, height: 60),
              const SizedBox(height: 25),
              Text(
                service.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
