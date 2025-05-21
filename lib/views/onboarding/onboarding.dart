import 'package:flutter/material.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/auth/login_page.dart';
import 'package:hiring_competition_app/views/onboarding/widgets/onboard_template.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  int currentIndex = 0;
  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Welcome Aboard",
      "subtitle":
          "Begin your journey with trusted opportunities directly shared by our college.",
      "textcolor": CustomColors().white,
      "color": CustomColors().blue,
    },
    {
      "title": "Compete & Grow",
      "subtitle":
          "Your gateway to real-world opportunities, verified and shared by your college.",
      "textcolor": CustomColors().blackText,
      "color": CustomColors().white,
    },
    {
      "title": "Skill Match",
      "subtitle":
          "No more endless scrolling - instantly discover company offers tailored to your skills and goals.",
      "textcolor": CustomColors().blackText,
      "color": CustomColors().yellow,
    },
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() => isLastPage = index == onboardingData.length - 1);
              currentIndex=index;
            },
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return OnboardTemplate(
                  textcolor: data['textcolor'],
                  color: data['color']!,
                  image: "onboard${index + 1}",
                  title: data['title']!,
                  description: data['subtitle']);
            },
          ),

          // Page indicator and next/done button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingData.length,
                  effect: const WormEffect(
                    dotColor: Colors.black26,
                    activeDotColor: Colors.black,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),


                //next button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: onboardingData[currentIndex]['textcolor'],
                    foregroundColor: onboardingData[currentIndex]['color'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150),
                    ),
                     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: isLastPage ? Text("Let's go") : Text("Next"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
