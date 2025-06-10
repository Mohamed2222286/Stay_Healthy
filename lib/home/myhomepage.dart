import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled3/home/bottombarpages/chatbotpage.dart';
import 'package:untitled3/home/bottombarpages/prediction_form.dart';
import 'package:untitled3/home/bottombarpages/profile/profilepage.dart';
import 'package:untitled3/home/bottombarpages/homescreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController(initialPage: 0);
  final _controller = NotchBottomBarController(index: 0);
  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const HomeScreen(),
    PredictionForm(),
    const Chatbotpage(),
    const Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(

        kIconSize: 25 ,
        kBottomRadius: 40,
        /// Provide NotchBottomBarController
        notchBottomBarController: _controller,
        color: const Color(0xFF9DCEFF),
        showLabel: false,
        notchColor: Colors.white,
        removeMargins: false,
        bottomBarWidth: 500,
        durationInMilliSeconds: 300,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_filled,
              color: Colors.white,
            ),
            activeItem: Icon(
              Icons.home_filled,
              color: Color(0xffD997E1),
            ),
          ),
          BottomBarItem(
            inActiveItem: SvgPicture.asset(
              'assets/icons/heartnotactive.svg',
            ),
            activeItem: SvgPicture.asset(
              'assets/icons/heartmodelactive.svg',
            ),
            itemLabel: 'Page 2',
          ),
          BottomBarItem(
            inActiveItem: Image.asset(
              'assets/images/applogo.png',
            ),
            activeItem: Image.asset(
              'assets/images/applogo.png',
              height: 50,
              width: 50,
            ),
          ),
          const BottomBarItem(
            inActiveItem: Icon(
              Icons.person_3_rounded,
              color: Colors.white,
            ),
            activeItem: Icon(
              Icons.person_3_rounded,
              color: Color(0xffD997E1),
            ),
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      )
          : null,
    );
  }
}
