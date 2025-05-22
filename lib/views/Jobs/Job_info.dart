import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/internship_provider.dart';
import 'package:hiring_competition_app/views/Jobs/widgets/info_tile.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class JobInfo extends StatefulWidget {
  final String event_name;
  final Color logo_color;
  JobInfo({
    required this.logo_color,
    required this.event_name,
    super.key,
  });

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

  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    fetchDetails();
  });
}


  Future<void> fetchDetails() async {
    final provider = Provider.of<InternshipProvider>(context, listen: false);
    await provider.getdetails(widget.event_name);
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

  Widget buildShimmerBlock({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InternshipProvider>(context);
    final isLoading = provider.isLoading;

    if (!isLoading && provider.details == null) {
      return Scaffold(
        body: Center(child: Text(provider.errormessage)),
      );
    }

    final details = provider.details ?? {};

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
              const SizedBox(height: 20),

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
                        color: const Color(0xFFE5E5E5),
                      ),
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
              isLoading
                  ? Row(
                      children: [
                        buildShimmerBlock(height: 60, width: 60),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildShimmerBlock(height: 20, width: 150),
                            const SizedBox(height: 8),
                            buildShimmerBlock(height: 14, width: 100),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: widget.logo_color,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            details['name'][0],
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
                            Text(details['name'],
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            Text(details['company'],
                                style:
                                    Theme.of(context).textTheme.labelLarge),
                          ],
                        )
                      ],
                    ),

              const SizedBox(height: 20),

              // Info Tiles
              isLoading
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        fields.length,
                        (index) =>
                            buildShimmerBlock(height: 60, width: 160),
                      ),
                    )
                  : Wrap(
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

              // About section
              Text("About",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              isLoading
                  ? buildShimmerBlock(height: 80, width: double.infinity)
                  : Text(details['about'],
                      style: Theme.of(context).textTheme.labelMedium),

              const SizedBox(height: 15),

              // Other Info section
              Text("Other Info",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              isLoading
                  ? Column(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: buildShimmerBlock(
                              height: 14, width: double.infinity),
                        );
                      }),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          List.generate(details['other'].length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• ",
                                  style:
                                      Theme.of(context).textTheme.labelMedium),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  details['other'][index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium,
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
