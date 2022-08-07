import 'dart:convert';

import 'package:codeforces_vis/models/contest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Contest>> fetchcontestList() async {
  String url = "https://codeforces.com/api/contest.list?";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = (json.decode(response.body)['result']);

    List<Contest> contestslist = data.map((d) => Contest.fromJson(d)).toList();

    return contestslist;
  } else {
    throw Exception('Couldn\'t load the list');
  }
}

class UpcomingContests extends StatefulWidget {
  const UpcomingContests({Key? key}) : super(key: key);

  @override
  State<UpcomingContests> createState() => _UpcomingContestsState();
}

class _UpcomingContestsState extends State<UpcomingContests> {
  late Future<List<Contest>> contests;
  @override
  void initState() {
    super.initState();
    contests = fetchcontestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Contests', ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 127, 226),
      ),
      body: FutureBuilder<List<Contest>>(
        future: contests,
        builder: (context, apidata) {
          if (apidata.hasData) {

            return ShowList(allContests: apidata.data!);
          } 
          else if (apidata.hasError) {
            return Center(
              child: Text('${apidata.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ShowList extends StatelessWidget {
  final List<Contest> allContests;
  ShowList({Key? key, required this.allContests}) : super(key: key);


  List<Contest> upcomingOnly = [];
  void filterContests() {
    for (int i = 0; i < allContests.length; i++) {
      if (allContests[i].phase == "FINISHED") {
        break;
      } else if (allContests[i].phase == "BEFORE") {
        upcomingOnly.add(allContests[i]);
      }
    }
    upcomingOnly.sort((a, b) => a.startTimeSeconds.compareTo(b.startTimeSeconds));
  }

  @override
  Widget build(BuildContext context) {
    filterContests();
    var sz = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: sz.height*.03,),
    
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
              itemCount: upcomingOnly.length,
              itemBuilder: (context, index) {
                return Card(
                  color: index % 2 == 0 ? const Color.fromARGB(255, 230, 193, 97) : const Color.fromARGB(255, 58, 202, 173),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 10,
                  child: ListTile(
                    // isThreeLine: true,
                    title: Text(upcomingOnly[index].name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),),
                    trailing: Text(
                      DateFormat('EEEE d MMM hh:mm:ss')
                      .format(
                        DateTime.fromMillisecondsSinceEpoch(
                          upcomingOnly[index].startTimeSeconds * 1000)
                    )
                      .toString(), 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                    ),
                    visualDensity: const VisualDensity(vertical: 4),
                    // leading: CircleAvatar(
                    //   child: Text(upcomingOnly[index].id.toString()),
                    // ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.blueGrey,
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                );
              },
            ),
        ],
      ),
    );
    // return ListView.builder(
    //   itemCount: upcomingOnly.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title: Text(
    //         upcomingOnly[index].name,
    //         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //       ),
    //       subtitle: Text(
    //         DateFormat('EEEE d MMM hh:mm:ss')
    //             .format(DateTime.fromMillisecondsSinceEpoch(
    //                 upcomingOnly[index].startTimeSeconds * 1000))
    //             .toString(),
    //         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    //       ),
    //     );
    //   },
    // );
  }
}
