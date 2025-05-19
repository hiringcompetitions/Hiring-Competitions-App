import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/views/home/home_page.dart';
import 'package:hiring_competition_app/views/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.5;
      });
    });

    super.initState();
    Future.delayed(Duration.zero, () async {
      final provider = Provider.of<AuthProvider>(context, listen: false);
      provider.loadUser();

      await Future.delayed(
          const Duration(seconds: 1));

      final user = provider.user;

      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user,)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: _scale),
              duration: Duration(seconds: 1),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Image.asset(
                    "lib/assets/images/icon.png",
                    height: 200,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
