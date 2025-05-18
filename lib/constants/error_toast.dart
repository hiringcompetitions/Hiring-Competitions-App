import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ErrorToast extends StatelessWidget {
  final String title;
  const ErrorToast({
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      title: title,
    );
  }
}