import 'package:codeforces_vis/models/user_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';


class ProblemTags extends StatefulWidget {
  final String handle;
  const ProblemTags({Key? key, required this.handle}) : super(key: key);

  @override
  State<ProblemTags> createState() => _ProblemTagsState();
}

class _ProblemTagsState extends State<ProblemTags> {
  late Future<List<Submission>> subResult;

  Future<List<Submission>> getProblemdetails(String handle) async {
  String url = "https://codeforces.com//api/user.status?handle=$handle";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print("Getting user.status \n");

    List<dynamic> data = (jsonDecode(response.body)['result']);

    List<Submission> subs = data.map((d) => Submission.fromJson(d)).toList();

    return subs;
  } 
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Problem tags');
  }
}

  @override
  void initState() {
    super.initState();
    subResult = getProblemdetails(widget.handle);
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Submission>>(
      future: subResult,
      builder: (context, apidata) {
        if (apidata.hasData) {

          return SortaccToTags(subs: apidata.data!);
        } 
        else if (apidata.hasError) {
          return Center(
            child: Text(apidata.error.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
        return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text(
                      'Fetching data...',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
                    )
                  ],
                ),
              );
      },
    );
  }
}

// ignore: must_be_immutable
class SortaccToTags extends StatelessWidget {
  final List<Submission> subs;
  SortaccToTags({Key? key, required this.subs}) : super(key: key);

  Map<String, int> uniquetags = {};
  LinkedHashMap sortedMap = LinkedHashMap();
  
  void makeMap() {
    Set<String> st = {};

    for (int i = 0; i < subs.length; i++) {

      String tmp = '${subs[i].contestId} ${subs[i].problem.name} ${subs[i].problem.index}';
      if (subs[i].verdict == 'OK' && !st.contains(tmp)) {
        for (int j = 0; j < subs[i].problem.tags.length; j++) {
          uniquetags.update(
              subs[i].problem.tags[j], (value) => ++value,
              ifAbsent: () => 1);
        }
        st.add(tmp);
      }
    }
    st.clear();
    var sortedKeys = uniquetags.keys.toList(growable: false)
      ..sort((k1, k2) => uniquetags[k2]!.compareTo(uniquetags[k1]!));

    sortedMap = LinkedHashMap.fromIterable(sortedKeys,
      key: (k) => k, value: (k) => uniquetags[k]);

  }

  @override
  Widget build(BuildContext context) {
    makeMap();

    return Expanded(
      child: Column(
        // mainAxisSize: MainAxisSize.min,  
        children: [
          Expanded(
            child: ListView(
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // Container(height: 100, color: Colors.red,),

                MyPieChart(sortedTags: uniquetags,),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 100),
                  child: ListView.builder(                       // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ TO DO $$$$$$$$$$$$$$$
                          scrollDirection: Axis.horizontal,        
                          physics: const BouncingScrollPhysics(),
                          // physics: const NeverScrollableScrollPhysics(), 
                          // primary: false,
                          shrinkWrap: true,
                            itemCount: sortedMap.length,
                            itemBuilder: ((context, index) {
                              String key = sortedMap.keys.elementAt(index);

                              return SizedBox(
                                width: 200,
                                child: Card(
                                  shadowColor: Colors.amber,
                                  elevation: 10,
                                  
                                  // child: Align(
                                    // alignment: Alignment.center,
                                    child: ListTile(  // wrap inside sized container
                                      title: Text(key, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, ),),
                                      subtitle: Text('${sortedMap[key]}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                                      visualDensity: const VisualDensity(vertical: -3),
                                    
                                    ),
                                  ),
                              );
                              // );
                              // return Container(width: 100, child: Text('${sortedMap[key]}'),);
                            })),
                ),
              ],
            ),
          ),
    
        ],
      ),
    );
  }
}


// ***************************************** PIE CHART **************************************
class MyPieChart extends StatefulWidget {
  final Map<String, int> sortedTags;

  const MyPieChart({Key? key, required this.sortedTags}) : super(key: key);

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  
 // You can't get more than about 30 colors with good distinctness no matter what you do
  List<Color> colorList = [
const Color(0xff01FFFE), const Color(0xffFFA6FE), const Color(0xffFFDB66), const Color(0xff006401), const Color(0xff010067), const Color(0xff95003A), const Color(0xff007DB5), const Color(0xffFF00F6), const Color(0xffFFEEE8), const Color(0xff774D00), const Color(0xff90FB92), const Color(0xffD5FF00), const Color(0xffFF937E), const Color(0xff6A826C), const Color(0xffFF029D), const Color(0xffFE8900), const Color(0xff7A4782), const Color(0xff7E2DD2), const Color(0xff85A900), const Color(0xffFF0056), const Color(0xffA42400), const Color(0xff00AE7E), const Color(0xff683D3B), const Color(0xffBDC6FF), const Color(0xff263400), const Color(0xffBDD393), const Color(0xff00B917), const Color(0xff9E008E), const Color(0xff001544), const Color(0xffC28C9F), const Color(0xffFF74A3), const Color(0xff01D0FF), const Color(0xff004754), const Color(0xffE56FFE), const Color(0xff788231), const Color(0xff0E4CA1), const Color(0xff91D0CB), const Color(0xffBE9970), const Color(0xff968AE8), const Color(0xffBB8800), const Color(0xff43002C), const Color(0xffDEFF74), const Color(0xff00FFC6), const Color(0xffFFE502), const Color(0xff620E00), const Color(0xff008F9C), const Color(0xff98FF52), const Color(0xff7544B1), const Color(0xffB500FF), const Color(0xff00FF78), const Color(0xffFF6E41), const Color(0xff005F39), const Color(0xff6B6882), const Color(0xff5FAD4E), const Color(0xffA75740), const Color(0xffA5FFD2), const Color(0xffFFB167), const Color(0xff009BFF), const Color(0xffE85EBE),
];
  
  Map<String, double> refinedMap = {};
  
  void parseInt(){
    widget.sortedTags.forEach((key, value) {
      var tmp = value.toDouble();
      
      refinedMap[key] = tmp;
     });

  }

  @override
  Widget build(BuildContext context) {
    parseInt();
    return PieChart(
          dataMap: refinedMap,
          chartType: ChartType.disc,
          colorList: colorList,
          chartRadius: MediaQuery.of(context).size.width / 1.15,
          ringStrokeWidth: 40,
          animationDuration: const Duration(seconds: 2),
          chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
              // showChartValuesOutside: false,
              showChartValuesInPercentage: true,
              showChartValueBackground: true,
              ),
          legendOptions: const LegendOptions(
              showLegends: true,
              legendShape: BoxShape.rectangle,
              legendTextStyle: TextStyle(fontSize: 17, color: Colors.white),
              legendPosition: LegendPosition.bottom,
              showLegendsInRow: false,
              legendLabels: {

              }
              ),
          
        );
  }
}