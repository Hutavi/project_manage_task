import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';

import 'indicator.dart';

class StateChart extends StatefulWidget {
  const StateChart({super.key, required this.data});

  final Map<String, double> data;

  @override
  State<StatefulWidget> createState() => StateChartState(data: data);
}

class StateChartState extends State {
  StateChartState({required this.data});
  final Map<String, double> data;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(data),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: COLOR_DONE,
                text: 'Hoàn thành',
                isSquare: false,
                textColor: COLOR_TEXT_MAIN,
              ),
              SizedBox(
                height: 6,
              ),
              Indicator(
                color: COLOR_INPROGRESS,
                text: 'Đang xử lí',
                isSquare: false,
                textColor: COLOR_TEXT_MAIN,
              ),
              SizedBox(
                height: 6,
              ),
              Indicator(
                color: COLOR_PLAN,
                text: 'Kế hoạch',
                isSquare: false,
                textColor: COLOR_TEXT_MAIN,
              ),
              SizedBox(
                height: 6,
              ),
              Indicator(
                color: COLOR_LATE,
                text: 'Trễ hạn',
                isSquare: false,
                textColor: COLOR_TEXT_MAIN,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(Map<String, double> data) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 21.0 : 16.0;
      final radius = isTouched ? 62.0 : 50.0;
      const shadows = [
        Shadow(color: Color.fromARGB(99, 145, 145, 145), blurRadius: 1)
      ];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: COLOR_DONE,
            value: data['Completed'],
            title:
                '${((data['Completed']! / data['total']!) * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: COLOR_WHITE,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: COLOR_INPROGRESS,
            value: data['In Progress'],
            title:
                '${((data['In Progress']! / data['total']!) * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: COLOR_WHITE,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: COLOR_PLAN,
            value: data['plan'],
            title:
                '${((data['plan']! / data['total']!) * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: COLOR_WHITE,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: COLOR_LATE,
            value: data['late'],
            title:
                '${((data['late']! / data['total']!) * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: COLOR_WHITE,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
