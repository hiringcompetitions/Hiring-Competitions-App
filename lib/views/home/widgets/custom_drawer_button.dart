import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawerButton extends StatelessWidget {
  final String title;
  final String icon;
  final bool isActive;
  final VoidCallback? onTap;
  const CustomDrawerButton({super.key, required this.title, required this.icon, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 4,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF2A37FF) : Colors.transparent,
                      ),
                    ),
                    SizedBox(width: 18),
                    icon == 'logout'
                    ? Icon(Icons.logout)
                    : Image.asset(
                      "lib/assets/$icon.png",
                      height: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(title,
                        style: GoogleFonts.commissioner(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
    );
  }
}