import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Onbordingcard extends StatelessWidget {
  const Onbordingcard({
    super.key,
    required this.image,
    required this.text1,
    required this.text2,
    required this.page,
    required this.onPressed,
  });

  final String image;

  final String text1;

  final String text2;

  final PageController page;

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9DCEFF),
              Color(0xff92a3fd),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                ],
              ),
            ),
            Center(
              child: Container(
                child: Image.asset(image),
                height: 500,
                width: 500,
              ),
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      )),
                  alignment: Alignment.bottomCenter,
                  height: 300,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 17.0, horizontal: 8.0),
                        child: Text(
                          text1,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 120.0, horizontal: 8.0),
                        child: Text(
                          text2,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
