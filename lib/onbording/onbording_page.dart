import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Authontication/signin.dart';
import '../widgets/onbordingcard.dart';

void main() => runApp(OnbordingPage());

class OnbordingPage extends StatefulWidget {
  const OnbordingPage({super.key});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  static final PageController _pageController = PageController(initialPage: 0);
  bool islastpage = true;

  List<Widget> _onBordingpages = [
    Onbordingcard(
      image: 'assets/images/onbording-1.png',
      text1:
          " Medical services in various specialties and medical teams at the highest level ",
      text2:
          "Book an appointment with doctor. Chat with doctor via appointment letter and get consultationt.",
      page: _pageController,
      onPressed: () {
        _pageController.animateToPage(1,
            duration: Durations.long1, curve: Curves.linear);
      },
    ),
    Onbordingcard(
      image: 'assets/images/onbording-2.png',
      text1: " Predicting heart disease using machine learning",
      text2:
          "different deep learning models that can predict the probability of developing heart disease.",
      page: _pageController,
      onPressed: () {
        _pageController.animateToPage(2,
            duration: Durations.long1, curve: Curves.linear);
      },
    ),
    Onbordingcard(
      image: 'assets/images/onbording-3.png',
      text1: "Book your consultation via visa or at the clinic",
      text2: "Choose the specialist and book an appointment from your Home .",
      page: _pageController,
      onPressed: () {
        _pageController.animateToPage(3,
            duration: Durations.long1, curve: Curves.linear);
      },
    ),
    Onbordingcard(
      image: 'assets/images/onbording-4.png',
      text1: " The artificial intelligence intelligent assistant called Alex ",
      text2:
          "Alex is a large language model that can answer any question in the medical field.",
      page: _pageController,
      onPressed: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  if (index == 3)
                    setState(() {
                      islastpage = false;
                    });
                },
                controller: _pageController,
                children: _onBordingpages,
              ),
            ),
          ],
        ),
        bottomSheet: islastpage
            ? Container(
                height: 120,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _pageController.jumpToPage(3),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: _onBordingpages.length,
                          onDotClicked: (index) => _pageController.animateToPage(
                            index,
                            duration: Durations.long1,
                            curve: Curves.linear,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _pageController.nextPage(
                          duration: Durations.long1,
                          curve: Curves.linear,
                        ),
                        child: Text(
                          'Next',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                color: Colors.white,
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signin(),
                        ),
                      );
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
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Get Started',
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
              ),
    );
  }
}
