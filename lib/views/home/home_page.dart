import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/views/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Home Page"),),
          TextButton(onPressed: () {
            provider.signout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
          }, child: Text("Log out")),
        ],
      ),
    );
  }
}