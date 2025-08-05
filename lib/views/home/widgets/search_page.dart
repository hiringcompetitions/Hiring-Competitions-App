import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/search_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/Jobs/Job_info.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  List<Color> colors = [
    CustomColors().purple,
    CustomColors().blue,
    Colors.red,
    const Color.fromARGB(255, 0, 184, 6),
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _controller,
          onChanged: provider.search,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search job titles...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.results.isEmpty
              ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("lib/assets/images/no_results_found.png", height: 150,),
                  Text("No Results Found", style: GoogleFonts.commissioner(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 119, 39, 176),
                    fontWeight: FontWeight.w500
                  ),),
                  SizedBox(height: 80,)
                ],
              ))
              : ListView.builder(
                  itemCount: provider.results.length,
                  itemBuilder: (context, index) {
                    final title = provider.results[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JobInfo(
                                        eventName: title,
                                        logoColor: colors[index % 5],
                                      )));
                        },
                        child: Container(
                            height: 80,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 249, 249, 249),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 14,
                                children: [
                                  // Logo
                                  Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: colors[index % 5],
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        title.substring(0, 1),
                                        style: GoogleFonts.merriweather(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.commissioner(
                                            fontSize: 20,
                                            color: CustomColors().blackText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                ),
    );
  }
}
