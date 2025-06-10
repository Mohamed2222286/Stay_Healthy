import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergence extends StatelessWidget {
  const Emergence({super.key});

  Future<void> _callNumber() async {
    final Uri callUri = Uri.parse("tel:123"); // Replace 123 with your number

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw "Could not launch $callUri";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emergence",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              'This service is available 24 hours ',
              style: GoogleFonts.nunito(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xffF44336),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: ElevatedButton(
              onPressed: _callNumber,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff9DCEFF), Color(0xff92a3fd)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ambulance Icon
                      Image.asset(
                        'assets/images/001 Ambulance.png',
                        // Replace with actual asset path
                        height: 50,
                        width: 50,
                      ),
                      SizedBox(width: 10),

                      // Button Text
                      Text(
                        "Call the emergency directly",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
