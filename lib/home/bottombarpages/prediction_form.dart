import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_screen.dart';
import 'package:untitled3/apis/model_api_service.dart';

class PredictionForm extends StatefulWidget {
  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isLoading = false;

  final List<String> _ageCategories = [
    '40-49',
    '50-59',
    '60-69',
    '70-79',
    '80+'
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.predictHeartDisease(
        bmi: _formData['bmi'],
        smoking: _formData['smoking'],
        alcoholDrinking: _formData['alcoholDrinking'],
        diffWalking: _formData['diffWalking'],
        sex: _formData['sex'],
        ageCategory: _formData['ageCategory'],
        diabetic: _formData['diabetic'],
        physicalActivity: _formData['physicalActivity'],
        asthma: _formData['asthma'],
        kidneyDisease: _formData['kidneyDisease'],
      );

      // Navigate to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            prediction: result['prediction'],
            confidence: result['confidence'],
            riskLevel: result['risk_level'],
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Heart disease Prediction",
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Model",
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Column(
                  children: [
                    _buildNumberInput('bmi', 'BMI', 'Enter BMI (18.5 - 40.0)'),
                    _buildDropdown('smoking', 'Do you smoke?', ['Yes', 'No']),
                    _buildDropdown('alcoholDrinking', 'Do you drink alcohol?',
                        ['Yes', 'No']),
                    _buildDropdown(
                        'diffWalking', 'Difficulty walking?', ['Yes', 'No']),
                    _buildDropdown('sex', 'Gender', ['Male', 'Female']),
                    _buildDropdown('ageCategory', 'Age Group', _ageCategories),
                    _buildDropdown('diabetic', 'Diabetic?', ['Yes', 'No']),
                    _buildDropdown('physicalActivity', 'Physically active?',
                        ['Yes', 'No']),
                    _buildDropdown('asthma', 'Have asthma?', ['Yes', 'No']),
                    _buildDropdown(
                        'kidneyDisease', 'Kidney disease?', ['Yes', 'No']),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Predict Heart Disease',
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
    );
  }


  Widget _buildNumberInput(String fieldKey, String label, String hint) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFF92a3fd), width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        final numValue = double.tryParse(value);
        if (numValue == null) return 'Enter valid number';
        if (numValue < 18.5 || numValue > 40)
          return 'BMI must be between 18.5-40';
        return null;
      },
      onSaved: (value) => _formData[fieldKey] = double.parse(value!),
    );
  }

  Widget _buildDropdown(String fieldKey, String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFF92a3fd), width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // suffix: const Icon(Icons.arrow_drop_down, size: 24),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        iconSize: 24,
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
        validator: (value) => value == null ? 'Required field' : null,
        onChanged: (value) => _formData[fieldKey] = value,
        menuMaxHeight: 300,
        elevation: 2,
        isExpanded: true,
        selectedItemBuilder: (BuildContext context) {
          return options.map<Widget>((String value) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
