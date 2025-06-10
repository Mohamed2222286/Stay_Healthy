import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/home/myhomepage.dart';
import '../models/bookingmodel.dart';
import '../providers/notificationprovider.dart';
import '../models/doctor_model.dart';

class ConfirmationScreen extends StatelessWidget {
  final Doctor doctor;
  final DateTime date;
  final TimeOfDay time;
  final String paymentMethod;

  const ConfirmationScreen({
    super.key,
    required this.doctor,
    required this.date,
    required this.time,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation/Animation - 1746057585253.json',
                width: 200, height: 200),
            Text(
              'Booking Confirmed!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(color: Color(0xff9DCEFF)), // Border color
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                  (route) => false,
                );
                final newBooking = Booking(
                  doctor: doctor,
                  date: date,
                  time: time,
                  paymentMethod: paymentMethod,
                );
                context.read<BookingProvider>().addBooking(newBooking);
                Provider.of<NotificationProvider>(context, listen: false)
                    .addNotification(
                  'Booking Accepted',
                  'Your booking has been confirmed',
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Back to Home',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff9DCEFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
