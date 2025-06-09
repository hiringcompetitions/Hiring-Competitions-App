// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const WebViewPage({
    required this.url,
    required this.title,
    super.key
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  late WebViewController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        )
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey.shade800
        ),
        backgroundColor: Colors.white,
        title: Text(widget.title, style: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600
        ),),
      ),
      body: Stack(children: [
        WebViewWidget(
          controller: controller,
        ),
        isLoading ? Positioned(
          left: MediaQuery.of(context).size.width / 2 - 20,
          top: MediaQuery.of(context).size.height / 2 - 100,
          child: CircularProgressIndicator(
            color: Colors.grey.shade800,
          )
        ) : SizedBox.shrink(),
      ]),
    );
  }
}