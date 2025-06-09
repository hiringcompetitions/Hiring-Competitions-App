import 'package:flutter/material.dart';

class OpportunitiesPage extends StatelessWidget {
  const OpportunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Opportunities Page',
        ),
      ),
    );
  }
}