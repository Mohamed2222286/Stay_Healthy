import 'package:flutter/material.dart';

import 'doctor_model.dart';

class Booking {
  final Doctor doctor;
  final DateTime date;
  final TimeOfDay time;
  final String paymentMethod;

  Booking({
    required this.doctor,
    required this.date,
    required this.time,
    required this.paymentMethod,
  });
}

class BookingProvider extends ChangeNotifier {
  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }
}