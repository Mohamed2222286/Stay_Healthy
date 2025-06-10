import 'payment_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/doctor_model.dart';

class ScheduleAndPaymentScreen extends StatefulWidget {
  final Doctor doctor;

  const ScheduleAndPaymentScreen({super.key, required this.doctor});

  @override
  _ScheduleAndPaymentScreenState createState() =>
      _ScheduleAndPaymentScreenState();
}

class _ScheduleAndPaymentScreenState extends State<ScheduleAndPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _paymentMethod = 'master card';
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            )),
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titleMedium: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            )),
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titleMedium: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Schedule & Payment',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                _buildScheduleSection(),
                SizedBox(
                  height: 10,
                ),
                const Divider(height: 40),
                _buildPaymentSection(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitForm,
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 80),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Continue',
                            style: GoogleFonts.poppins(
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date & Time',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: Text(
            _selectedDate == null
                ? 'Select Date'
                : DateFormat('dd MMM yyyy').format(_selectedDate!),
            style: GoogleFonts.poppins(
                color: _selectedDate == null
                    ? Colors.grey[800]
                    : Color(0xff92a3fd),
                fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.calendar_today,
            color: _selectedDate == null ? Colors.grey[800] : Color(0xff92a3fd),
          ),
          onTap: _selectDate,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300)),
        ),
        const SizedBox(height: 15),
        ListTile(
          title: Text(
            _selectedTime == null
                ? 'Select Time'
                : _selectedTime!.format(context),
            style: GoogleFonts.poppins(
                color: _selectedTime == null
                    ? Colors.grey[800]
                    : Color(0xff92a3fd),
                fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.access_time,
            color: _selectedTime == null ? Colors.grey[800] : Color(0xff92a3fd),
          ),
          onTap: _selectTime,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300)),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Options',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        RadioListTile<String>(
          title: Text(
            'Credit/Debit Card',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          value: 'master card',
          groupValue: _paymentMethod,
          onChanged: (value) => setState(() => _paymentMethod = value!),
        ),
        if (_paymentMethod == 'master card') ...[
          _buildCardForm(),
          const SizedBox(height: 20),
        ],
        RadioListTile<String>(
          title: Text(
            'Pay at Clinic',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          value: 'clinic',
          groupValue: _paymentMethod,
          onChanged: (value) => setState(() => _paymentMethod = value!),
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            _cardController.value = _cardController.value.copyWith(
              text: value,
              selection: TextSelection.collapsed(offset: value.length),
            );
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            final cleaned = value.replaceAll(' ', '');
            if (cleaned.length != 16) {
              return 'Invalid card number length';
            }
            if (!RegExp(r'^[0-9]{16}$').hasMatch(cleaned)) {
              return 'Only numbers allowed';
            }
            if (!_isValidLuhn(cleaned)) {
              return 'Invalid card number';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CardNumberFormatter(),
          ],
          keyboardType: TextInputType.number,
          controller: _cardController,
          decoration: InputDecoration(
            labelText: 'Card Number',
            hintText: '0000 0000 0000 0000',
            prefixIcon: const Icon(Icons.credit_card),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Color(0xFF92a3fd)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Color(0xFF92a3fd)),
                    ),
                    labelText: 'MM/YY',
                    prefixIcon: Icon(Icons.calendar_month)),
                validator: (value) {
                  if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$')
                      .hasMatch(value!)) {
                    return 'Invalid expiry date';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                controller: _cvcController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Color(0xFF92a3fd)),
                    ),
                    labelText: 'CVC',
                    prefixIcon: Icon(Icons.lock)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.length < 3 || value.length > 4) {
                    return 'Invalid CVC';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
            'By providing your card information, you allow us to book appointment with doctor in the clinic',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Please select date and time',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )));
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSummaryScreen(
            doctor: widget.doctor,
            date: _selectedDate!,
            time: _selectedTime!,
            paymentMethod: _paymentMethod,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

bool _isValidLuhn(String input) {
  try {
    int sum = 0;
    bool alternate = false;
    for (int i = input.length - 1; i >= 0; i--) {
      int digit = int.parse(input[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      alternate = !alternate;
    }
    return (sum % 10) == 0;
  } catch (e) {
    return false;
  }
}
