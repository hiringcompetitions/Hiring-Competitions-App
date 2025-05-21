import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/internship_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/Jobs/widgets/info_tile.dart';
import 'package:provider/provider.dart';

class JobInfo extends StatefulWidget {
  final String event_name;
   JobInfo({
    required this.event_name,
    super.key});

  @override
  State<JobInfo> createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  final List<IconData> icons = [
    Icons.location_on_outlined,
    Icons.access_time_outlined,
    Icons.attach_money_outlined,
    Icons.school_outlined,
    Icons.calendar_today_outlined,
  ];

  final List<String> fields = [
    "location",
    "duration",
    "stipend",
    "eligibility",
    "lastdate",
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final provider = Provider.of<InternshipProvider>(context, listen: false);
    await provider.getdetails(widget.event_name);
    setState(() {
      _isLoading = false;
    });
  }

  String getTimeRemaining(Timestamp lastDate) {
    final deadline = lastDate.toDate();
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays > 0) {
      return "${difference.inDays} days left";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours left";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes left";
    } else {
      return "Expired";
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InternshipProvider>(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.details == null) {
      return Scaffold(
        body: Center(child: Text(provider.errormessage)),
      );
    }

    final details = provider.details!;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            // handle apply logic
          },
          child: Text("Apply Now",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // AppBar area
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          color: const Color(0xFFE5E5E5)),
                      child: const Icon(Icons.arrow_back_outlined),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "DETAILS",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: CustomColors().pink,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "G",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details['name'],
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        details['company'],
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Info Tiles
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(fields.length, (index) {
                  return InfoTile(
                    icon: icons[index],
                    text: (fields[index] == 'lastdate')
                        ? getTimeRemaining(details['lastdate'])
                        : (details[fields[index]] ?? 'N/A'),
                  );
                }),
              ),

              const SizedBox(height: 15),

              Text("About", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(details['about'],
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 15),

              Text("Other Info",
                  style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(details['other'].length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ",
                            style: Theme.of(context).textTheme.labelMedium),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            details['other'][index],
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
