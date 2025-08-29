// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/internship_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/backend/models/application_model.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/constants/error_toast.dart';
import 'package:hiring_competition_app/views/Jobs/widgets/bottom_buttons.dart';
import 'package:hiring_competition_app/views/Jobs/widgets/info_tile.dart';
// Make sure this path to your WebViewPage is correct
import 'package:hiring_competition_app/views/webView/web_view_page.dart'; 
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class JobInfo extends StatefulWidget {
  final String eventName;
  final Color logoColor;
  const JobInfo({
    required this.logoColor,
    required this.eventName,
    super.key,
  });

  @override
  State<JobInfo> createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  final List<String> images = [
    "location_white",
    "time1",
    "payout_white",
    "user_white",
    "time1"
  ];

  final List<String> fields = [
    "location",
    "duration",
    "payout",
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
    await provider.getdetails(widget.eventName);
  }

  // This function contains the entire logic for your new feature.
  Future<void> handleApplyFlow(Map<String, dynamic> details) async {
    // 1. Navigate to the WebView and WAIT for the user to come back.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: details['url'], title: details['title']),
      ),
    );

    if (!mounted) return; // Safety check

    // 2. Show the dialog asking if they applied.
    final bool? didApply = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (context) => const _PostApplicationDialog(),
    );

    if (didApply == true) {
      final provider = Provider.of<InternshipProvider>(context, listen: false);
      final firestoreProvider = Provider.of<FirestoreProvider>(context, listen: false);
      final authProvider = Provider.of<CustomAuthProvider>(context, listen: false);

      await firestoreProvider.getUserDetails(authProvider.user?.uid ?? '');
      if (firestoreProvider.userDetails == null) {
        if (context.mounted) {
          errorToast("User not found", context);
        }
        return;
      }
      final data = firestoreProvider.userDetails ?? {};
      final application = ApplicationModel(
        name: data['name'],
        rollNo: data['rollNo'],
        branch: data['branch'],
        batch: data['passedOutYear'],
        status: 'Applied',
        email: data['email'],
        appliedOn: Timestamp.now(),
      );

      final res = await provider.addApplication(
        details['uid'],
        application,
        authProvider.user!.uid,
      );

      if (context.mounted) {
        if (res == null) {
          setState(() {});
          errorToast("Your status has been updated to 'Applied'!", context);
        } else {
          errorToast(res, context);
        }
      }
    }
  }

  String getTimeRemaining(Timestamp lastDate) {
    final deadline = lastDate.toDate();
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays > 0) {
      return "${difference.inDays}d left";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h left";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}min left";
    } else {
      return "Expired";
    }
  }

  void updateStatus(Map<String, dynamic> details) {
    final provider = Provider.of<InternshipProvider>(context, listen: false);
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Update Status as",
                style: GoogleFonts.commissioner(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: CustomColors().blackText,
                )),
            actions: [
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                onPressed: () async {
                  await provider.updateStatus(
                      authProvider.user!.uid, details['uid'], 'Rejected');
                  Navigator.pop(context);
                  errorToast("Status Updated", context);
                },
                child: Text(
                  "Rejected",
                  style: GoogleFonts.commissioner(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CustomColors().blackText,
                  ),
                ),
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors().darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                onPressed: () async {
                  await provider.updateStatus(
                      authProvider.user!.uid, details['uid'], 'Selected');
                  Navigator.pop(context);
                  errorToast("Status Updated", context);
                },
                child: Text(
                  "Selected",
                  style: GoogleFonts.commissioner(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        });
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
    final authProvider = Provider.of<CustomAuthProvider>(context);

    if (!provider.isLoading && provider.details == null) {
      return Scaffold(
        body: Center(child: Text(provider.errormessage)),
      );
    }

    final details = provider.details ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22.0),
        child: !provider.isLoading
                ? StreamBuilder(
                key: ValueKey(details['uid']),
                stream: provider.getAppliedStatus(authProvider.user!.uid, details['uid']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmerBlock(height: 60, width: double.infinity);
                  }

                  if (snapshot.hasError) {
                    return Text("errrrorrrr");
                  }

                  final data = snapshot.data;

                      if (data == null || !(data as dynamic).exists) {
                        return BottomButtons(
                          mainButton: "Apply Now",
                          secondButton: "",
                          mainFunction: () => handleApplyFlow(details),
                          secondFunction: null,
                        );
                      }

                  final data1 = (data as dynamic).data() as Map<String, dynamic>? ?? {};
                  final status = data1['status'];

                  return status == null
                          ? BottomButtons(
                              mainButton: "Apply Now",
                              secondButton: "",
                              mainFunction: () => handleApplyFlow(details),
                              secondFunction: null,
                            )
                          : status == 'Applied'
                              ? BottomButtons(
                                  mainButton: "Update Status",
                                  secondButton: "",
                                  mainFunction: () => updateStatus(details),
                                  secondFunction: null,
                                )
                              : BottomButtons(
                                  mainButton: status,
                                  secondButton: "",
                                  mainFunction: null,
                                  secondFunction: null,
                                );
                },
              )
            : buildShimmerBlock(height: 60, width: double.infinity),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

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
              provider.isLoading
                  ? Row(
                      children: [
                        buildShimmerBlock(height: 60, width: 60),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildShimmerBlock(
                                height: 20,
                                width:
                                    MediaQuery.of(context).size.width * 0.65),
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
                              color: widget.logoColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            details['title'].substring(0, 1).toUpperCase(),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(details['title'],
                                  style: GoogleFonts.commissioner(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors().blackText,
                                  )),
                            ),
                            Text(details['organization'],
                                style: GoogleFonts.commissioner(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: CustomColors().greyText)),
                          ],
                        )
                      ],
                    ),

              const SizedBox(height: 20),

              // Info Tiles
              provider.isLoading
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        fields.length,
                        (index) => buildShimmerBlock(
                            height: 60,
                            width: MediaQuery.of(context).size.width),
                      ),
                    )
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(fields.length, (index) {
                        return InfoTile(
                          image: images[index],
                          text: (fields[index] == 'lastdate')
                              ? getTimeRemaining(details['lastdate'])
                              : fields[index] == 'eligibility'
                                  ? (details['eligibility'] as List).join(', ')
                                  : (details[fields[index]] ?? 'N/A'),
                        );
                      }),
                    ),

              const SizedBox(height: 15),

              // About section
              Text("About", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              provider.isLoading
                  ? buildShimmerBlock(height: 80, width: double.infinity)
                  : Text(details['about'],
                      style: Theme.of(context).textTheme.labelMedium),

              const SizedBox(height: 15),

              // Other Info section
              Text("Other Info",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              provider.isLoading
                  ? Column(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: buildShimmerBlock(
                              height: 14, width: double.infinity),
                        );
                      }),
                    )
                  : Text(
                      details['otherInfo'] ??
                          'No additional information provided.',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// The dialog widget that asks the user to confirm their application status
class _PostApplicationDialog extends StatefulWidget {
  const _PostApplicationDialog();

  @override
  _PostApplicationDialogState createState() => _PostApplicationDialogState();
}

class _PostApplicationDialogState extends State<_PostApplicationDialog> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Text('Update Application Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Did you successfully submit your application?'),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              isExpanded: true,
              hint: const Text('Please confirm'),
              value: _selectedValue,
              items: ['Yes, I applied', 'No, I did not']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(color: CustomColors().blackText),),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              if (_selectedValue != null) {
                Navigator.of(context).pop(_selectedValue == 'Yes, I applied');
              } else {
                errorToast("Please make a selection", context);
              }
            },
          ),
        ],
      ),
    );
  }
}