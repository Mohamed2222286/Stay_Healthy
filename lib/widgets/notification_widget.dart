import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// notification_widget.dart

class NotificationWidget extends StatelessWidget {
  final String title;
  final String message;

  const NotificationWidget({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.check, color: Colors.white),
          radius: 30,
        ),
        title: Text(
          title, // Use dynamic title
          maxLines: 1,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message, // Use dynamic message
          maxLines: 2,
          style: GoogleFonts.poppins(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}