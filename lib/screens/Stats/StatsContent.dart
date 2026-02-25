
import 'package:diary/models/stats_model.dart';
import 'package:diary/services/journal_service.dart';
import 'package:diary/theme.dart';
import 'package:diary/ui_widgets/EmojiPanel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsContent extends StatefulWidget {
  const StatsContent({super.key, required this.type});

  final String type;

  @override
  State<StatsContent> createState() => _StatsContentState();
}

class _StatsContentState extends State<StatsContent> {


  List<Map<String, dynamic>>? data;
  StatsModel? totalEntriesStats;

  final User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    print(widget.type);
    getStats();
    totalStats();
  }

  void getStats () async{
    JournalService jservice = JournalService();
    print("in get stats in stats content");

    List<Map<String, dynamic>> res = [];
    if(widget.type == "this week") {
      res = await jservice.getStats(user!.uid, "this week");
    }

    if(widget.type == "last week") {
      res = await jservice.getStats(user!.uid, "last week");
    }

    setState(() {
      data = res;
    });

  }

  void totalStats() async {
    JournalService jservice = JournalService();
    StatsModel total = await jservice.totalStats(user!.uid);
    setState(() {
      totalEntriesStats = total;
    });

  }
  List<BarChartGroupData> makeGroup(){
    List<BarChartGroupData> res = [];

    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < data!.length; j++){
        if (i == data![j]["day"] - 1){
          final data1 = BarChartGroupData(
              x: i ,
              barRods: [BarChartRodData(
                  toY: data![j]["total_count"],
                  width: 15,
                  rodStackItems: [
                    BarChartRodStackItem(
                        0.0, data![j]["happy"].toDouble(), Colors.yellow[100]!),
                    BarChartRodStackItem(data![j]["happy"]!,
                        (data![j]["neutral"]!.toDouble() + data![j]["happy"]!.toDouble()),
                        Colors.orange[100]!),
                    BarChartRodStackItem(
                        (data![j]["neutral"]!.toDouble() + data![j]["happy"]!.toDouble()),
                        data![j]["total_count"]!.toDouble(), Colors.blue[100]!),
                  ]
              )
              ]
          );
          res.add(data1);
        }
      }
    }
    print(res);
    return res;
  }


  @override
  Widget build(BuildContext context) {

    if(data == null){
      return CircularProgressIndicator();
    }

    if (widget.type == "this week") {
      return Column(
        children: [
          Text("Total entries this week:"),
          Expanded(
            child: BarChart(
              BarChartData(
                groupsSpace: 5.0,
                barGroups: makeGroup(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, metadata) {
                        switch (value.toInt()) {
                          case 0:
                            return Text("M");
                          case 1:
                            return Text("T");
                          case 2:
                            return Text("W");
                          case 3:
                            return Text("Th");
                          case 4:
                            return Text("F");
                          case 5:
                            return Text("S");
                          case 6:
                            return Text("SU");
                          default:
                            return Text("X");
                        }
                      }
                    )
                  )
                )
              ),


            ) ,
          ),
        ],
      );
    }
    else if (widget.type == "last week") {
      return Column(
        children: [
          Text("Total entries last week: "),
          Expanded(child: BarChart(
            BarChartData(
                groupsSpace: 5.0,
                barGroups: makeGroup(),
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, metadata) {
                              switch (value.toInt()) {
                                case 0:
                                  return Text("M");
                                case 1:
                                  return Text("T");
                                case 2:
                                  return Text("W");
                                case 3:
                                  return Text("Th");
                                case 4:
                                  return Text("F");
                                case 5:
                                  return Text("S");
                                case 6:
                                  return Text("SU");
                                default:
                                  return Text("X");
                              }
                            }

                        )
                    )
                )
            ),


          ) ,)
        ],
      );
    }else {
      if (totalEntriesStats == null) {
        return CircularProgressIndicator();
      } else {
        return Column(
          children: [
            Text("Total entries:  ${totalEntriesStats!.total_num.toInt()} "),
            Expanded(child:
            BarChart(BarChartData(
                barGroups: [

                  BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(
                        toY: totalEntriesStats!.happy_num,
                        width: 15,
                        color: Colors.yellow[100],
                      )
                      ]
                  ),
                  BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(
                        toY: totalEntriesStats!.neutral_num,
                        width: 15,
                        color: Colors.orange[100],
                      )
                      ]
                  ),
                  BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(
                        toY: totalEntriesStats!.sad_num,
                        width: 15,
                        color: Colors.blue[100],
                      )
                      ]
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, metadata) {
                        switch (value.toInt()) {
                          case 0:
                            return Text("🥰");
                          case 1:
                            return Text("😐");
                          case 2:
                            return Text("😔");
                          default:
                            return Text("X");
                        }
                      }
                    )
                  )
                ),
            )))

          ],
        );
      }
    }
  }
}

