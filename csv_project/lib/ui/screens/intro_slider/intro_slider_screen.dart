
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'indicator.dart';
import 'intro_page_screen.dart';

class IntroSliderScreen extends StatefulWidget {
  static const id = 'IntroSliderScreen';
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final controller = PageController();

  final messages = ['Test', 'Test 2', 'Test 3'];
  final titles = ['', '', ''];
  final images = [
    'assets/image.jpg',
    'assets/image_2.jpg',
    'assets/image_2.jpg'
  ];

  int numberOfPages = 3;
  int currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff18224C),
      body: Stack(children: <Widget>[
        PageView.builder(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemCount: numberOfPages,
          itemBuilder: (BuildContext context, int index) {
            if (index == 2) {}

            return IntroPageScreen(
                messages[index], images[index], titles[index]);
          },
        ),
        Positioned(
          bottom: 70,
          left: 40,
          right: 40,
          child: buildButton(
              onPressed: () {
                if (currentPage == 2) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (conetxt) {
                    return const HomePage();
                  }));
                } else {
                  ++currentPage;
                  controller.animateToPage(
                    currentPage,
                    curve: Curves.easeIn,
                    duration:const Duration(milliseconds: 500),
                  );
                }
              },
              title: currentPage == 2 ? 'Home' : 'Next',
              width: MediaQuery.of(context).size.width),
          height: 45,
        ),
        Positioned(
          bottom: 20,
          left: 0.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(child: Container()),
                Flexible(
                  child: Indicator(
                    controller: controller,
                  ),
                ),
                Flexible(child: Container()),
               
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildButton({
    String title = '',
    required Function()? onPressed,
    double height = 42.0,
    double width = 200.0,
    Color btnColor = Colors.red,
    Color texColor = Colors.white,
    FontWeight fontWeight = FontWeight.w600,
    Color borderColor = Colors.red,
    double radius = 0.0,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: btnColor,
          border: Border.all(color: borderColor, width: 2.0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(title,
              style: TextStyle(
                color: texColor,
                fontWeight: fontWeight,
                fontSize: 16,
              )),
        ),
      ),
    );
  }
}
