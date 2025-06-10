import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatelessWidget {
  final String prediction;
  final double confidence;
  final String riskLevel;

  const ResultScreen({
    super.key,
    required this.prediction,
    required this.confidence,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getRiskLevelAttributes(riskLevel);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prediction Result",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 150, left: 16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: color.withOpacity(0.3), width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(icon, size: 48, color: color),
                    const SizedBox(height: 20),
                    Text(
                      'Risk Level: $riskLevel',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildResultRow('Prediction', prediction),
                    _buildResultRow(
                        'Confidence', '${confidence.toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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
                        vertical: 20, horizontal: 100),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Make New Prediction',
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
    );
  }

  (Color, IconData) _getRiskLevelAttributes(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return (Colors.red, Icons.warning_rounded);
      case 'medium':
        return (Colors.orange, Icons.info_outline_rounded);
      case 'low':
        return (Colors.green, Icons.check_circle_outline_rounded);
      default:
        return (Colors.grey, Icons.help_outline_rounded);
    }
  }

  Widget _buildResultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          Text(value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
