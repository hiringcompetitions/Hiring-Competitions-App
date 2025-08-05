import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/notification_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/Jobs/Job_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<NotificationProvider>(context, listen: false);
      provider.getStoredNotifications();
    });
  }

  String getDateDifference(String date) {
    final date2 = DateTime.parse(date);
    final res = DateTime.now().difference(date2);
    final days = res.inDays;
    final hours = res.inHours;
    final minutes = res.inMinutes;
    final seconds = res.inSeconds;

    if(days > 0) {
      return "${days}d ago";
    } else if(hours > 0) {
      return "${hours}h ago";
    } else if(minutes > 0) {
      return "${minutes}min ago";
    } else if(seconds > 0) {
      return "${seconds}s ago";
    } else {
      return ''; 
    }
  }

  Future<void> markAsRead(String body) async {
    final prefs = await SharedPreferences.getInstance();

    // Load and decode the notification list
    String? storedData = prefs.getString('notifications');

    if (storedData != null) {
      List<dynamic> jsonList = jsonDecode(storedData);
      List<Map<String, dynamic>> notifications = jsonList.cast<Map<String, dynamic>>();

      // Find and update the notification by body (you can use 'id' if available)
      int indexToUpdate = notifications.indexWhere((item) => item['body'] == body);

      print("Notification index: $indexToUpdate");

      if (indexToUpdate != -1) {
        notifications[indexToUpdate]['isOpened'] = true;

        // Encode and save the updated list
        String updatedJson = jsonEncode(notifications);
        await prefs.setString('notifications', updatedJson);

        print("Notification updated and saved.");
      } else {
        print("Notification not found.");
      }
    } else {
      print("No notifications found in SharedPreferences.");
    }
  }

  List<Color> colors = [
    const Color.fromARGB(255, 247, 79, 79),
    const Color.fromARGB(255, 23, 150, 152),
    const Color.fromARGB(255, 216, 79, 247),
    const Color.fromARGB(255, 113, 79, 247),
    const Color.fromARGB(255, 118, 147, 15),
    const Color.fromARGB(255, 4, 139, 37),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Notifications",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: CustomColors().blackText,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                print("Clearing");
                provider.clearAllNotifications();
              },
              child: Icon(
                Icons.clear_all,
                size: 26,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          children: [
            provider.isLoading 
            ? Center(child: CircularProgressIndicator(),)
            : provider.notifications == null
            ? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image.asset("lib/assets/images/no_notifications1.png", height: 450,),),
                ],
              ),
            ) 
            : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.notifications?.length ?? 0,
              itemBuilder: (context, index) {
                final data = provider.notifications?[index] ?? {};
                return GestureDetector(
                  onTap: () {
                    final screenData = data['data'];
                    markAsRead(data['body']);
                    if(screenData['screen'] == 'jobInfo') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => JobInfo(logoColor: Colors.green, eventName: screenData['name']) ));
                    }
                  },
                  child: BuildNotificationCard(
                    context, 
                    data['title'] ?? '', 
                    data['body'] ?? '', 
                    getDateDifference(data['timestamp'].toString()),
                    data['isOpened'] ?? false, 
                    Icons.assessment, 
                    colors[index % 6],
                  ),
                );
              }
            ),
          ],
        ));
  }

  Widget BuildNotificationCard(BuildContext context, String title, String desc,
      String time, bool isRead, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color:
              isRead ? Colors.white : const Color.fromARGB(255, 246, 251, 255),
          border: Border(
              bottom: BorderSide(width: 1, color: Colors.grey.shade100))),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                icon,
                size: 14,
                color: color,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.commissioner(
                      fontSize: 16,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  desc,
                  style: GoogleFonts.commissioner(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
