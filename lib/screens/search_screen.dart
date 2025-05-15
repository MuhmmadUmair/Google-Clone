import 'package:flutter/material.dart';
import 'package:google_clone/colors.dart';
import 'package:google_clone/services/api_service.dart';
import 'package:google_clone/widgets/search_footer.dart';
import 'package:google_clone/widgets/search_header.dart';
import 'package:google_clone/widgets/search_result_component.dart';
import 'package:google_clone/widgets/search_tabs.dart';

class SearchScreen extends StatelessWidget {
  final String searchquery;
  final String start;
  const SearchScreen({
    super.key,
    required this.searchquery,
    required this.start,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Title(
      color: Colors.blue,
      title: searchquery,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Web header
              const SearchHeader(),
              // Tabs for news images etc
              Padding(
                padding: EdgeInsets.only(right: size.width <= 768 ? 10: 700.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SearchTabs(),
                  ),
              ),
              Divider(height: 0, thickness: 0.3),
              FutureBuilder(
                future: ApiService().fetchData(
                  queryTerm: searchquery,
                  start: start,
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: size.width <= 768 ? 10 : 150.0, top: 12),
                          child: Text(
                            'About ${snapshot.data?['searchInformation']['formattedTotalResults']} results (${snapshot.data?['searchInformation']['searchTime']} seconds)',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0XFF70757A),
                            ),
                          ),
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?['items'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: size.width <= 768 ? 10 : 150.0, top: 10),
                              child: SearchResultComponent(
                                desc: snapshot.data?['items'][index]['snippet'],
                                linktoGo: snapshot.data?['items'][index]['link'],
                                link:
                                    snapshot
                                        .data?['items'][index]['formattedUrl'],
                                text: snapshot.data?['items'][index]['title'],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              // Search result
              // Pagination buttons
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (start != '0') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => SearchScreen(
                                    searchquery: searchquery,
                                    start: (int.parse(start) - 10).toString(),
                                  ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '< Prev',
                        style: TextStyle(fontSize: 15, color: blueColor),
                      ),
                    ),
                    const SizedBox(width: 30),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => SearchScreen(
                                  searchquery: searchquery,
                                  start: (int.parse(start) + 10).toString(),
                                ),
                          ),
                        );
                      },
                      child: Text(
                        'Next >',
                        style: TextStyle(fontSize: 15, color: blueColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SearchFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
