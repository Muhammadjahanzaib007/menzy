import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menzy/dbhelper/DataBaseHelper.dart';
import 'package:menzy/dbhelper/datamodel/StepsData.dart';
import 'package:menzy/interfaces/TopBarClickListener.dart';
import 'package:menzy/localization/language/languages.dart';
import 'package:menzy/localization/locale_constant.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:menzy/utils/Color.dart';
import 'package:menzy/utils/Constant.dart';
import 'package:intl/intl.dart';
import 'package:menzy/utils/Preference.dart';
import 'package:menzy/utils/Utils.dart';

import '../../Utils/App-TextStyle.dart';

class StepsStatisticsScreen extends StatefulWidget {
  final int? currentStepCount;

  StepsStatisticsScreen({this.currentStepCount});

  @override
  _StepsTrackerStatisticsScreenState createState() =>
      _StepsTrackerStatisticsScreenState();
}

class _StepsTrackerStatisticsScreenState extends State<StepsStatisticsScreen>
    implements TopBarClickListener {
  DateTime currentDate = DateTime.now();
  var currentMonth = DateFormat('MM').format(DateTime.now());
  var currentYear = DateFormat.y().format(DateTime.now());

  int? daysInMonth;
  List<StepsData>? stepsDataMonth;
  Map<String, int> mapMonth = {};

  int? totalStepsMonth = 0;
  double? avgStepsMonth = 0.0;

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<StepsData>? stepsDataWeek;

  int? totalStepsWeek = 0;
  double? avgStepsWeek = 0.0;

  var currentDay =
      DateFormat('EEEE', getLocale().languageCode).format(DateTime.now());

  int touchedIndexForStepsChart = -1;

  List<String> weekDates = [];
  Map<String, int> mapWeek = {};

  bool isMonthSelected = false;
  bool isWeekSelected = true;

  List<String> allDays = DateFormat.EEEE(getLocale().languageCode)
      .dateSymbols
      .STANDALONESHORTWEEKDAYS;
  List<String> allMonths =
      DateFormat.EEEE(getLocale().languageCode).dateSymbols.MONTHS;

  int? prefSelectedDay;

  @override
  void initState() {
    prefSelectedDay =
        Preference.shared.getInt(Preference.FIRST_DAY_OF_WEEK_IN_NUM) ?? 1;
    daysInMonth =
        Utils.daysInMonth(int.parse(currentMonth), int.parse(currentYear));
    getChartDataOfStepsForMonth();
    getTotalStepsMonth();

    getChartDataOfStepsForWeek();
    getTotalStepsWeek();
    super.initState();
  }

  final List<Color> weekColors = const [
    AppColors.primary,
    Color.fromARGB(255, 223, 122, 241),
    Color.fromARGB(255, 203, 89, 223),
    Color.fromARGB(255, 171, 62, 190),
    Color.fromARGB(255, 203, 89, 223),
    Color.fromARGB(255, 223, 122, 241),
    Color.fromARGB(255, 230, 145, 245),
  ];

  final List<Color> availableColors = const [
    AppColors.primary,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,right: 16),
                  child: Text(
                    "Chart History",
                    style: AppTextStyle.regularWhite16,
                  ),
                ),
                // const SizedBox(
                // width: 5,
                // ),

                Spacer(),

              ],
            ),

            Expanded(
              child: Container(
                child: Column(
                  children: [

                    reportWidget(fullHeight, fullWidth, context),
                  ],
                ),
              ),
            ),
            selectMonthOrWeek(fullHeight, fullWidth)
          ],
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget getMonthTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('1', style: style);
        break;
      case 1:
        text = const Text('2', style: style);
        break;
      case 2:
        text = const Text('3', style: style);
        break;
      case 3:
        text = const Text('4', style: style);
        break;
      case 4:
        text = const Text('5', style: style);
        break;
      case 5:
        text = const Text('6', style: style);
        break;
      case 6:
        text = const Text('7', style: style);
        break;
      case 7:
        text = const Text('8', style: style);
        break;
      case 8:
        text = const Text('9', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 10:
        text = const Text('11', style: style);
        break;
      case 11:
        text = const Text('12', style: style);
        break;
      case 12:
        text = const Text('13', style: style);
        break;
      case 13:
        text = const Text('14', style: style);
        break;
      case 14:
        text = const Text('15', style: style);
        break;
      case 15:
        text = const Text('16', style: style);
        break;
      case 16:
        text = const Text('17', style: style);
        break;
      case 17:
        text = const Text('18', style: style);
        break;
      case 18:
        text = const Text('19', style: style);
        break;
      case 19:
        text = const Text('20', style: style);
        break;
      case 20:
        text = const Text('21', style: style);
        break;
      case 21:
        text = const Text('22', style: style);
        break;
      case 22:
        text = const Text('23', style: style);
        break;
      case 23:
        text = const Text('24', style: style);
        break;
      case 24:
        text = const Text('25', style: style);
        break;
      case 25:
        text = const Text('26', style: style);
        break;
      case 26:
        text = const Text('27', style: style);
        break;
      case 27:
        text = const Text('28', style: style);
        break;
      case 28:
        text = const Text('29', style: style);
        break;
      case 29:
        text = const Text('30', style: style);
        break;
      case 30:
        text = const Text('31', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  selectMonthOrWeek(double fullHeight, double fullWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: fullHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isMonthSelected = false;
                isWeekSelected = true;
              });
            },
            child: Container(
              height: fullHeight * 0.07,
              width: fullWidth * 0.35,
              decoration: isWeekSelected
                  ? BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primarySplash]),
                      borderRadius: BorderRadius.circular(20),
                    )
                  : BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
              child: Center(
                child: Text(
                  Languages.of(context)!.txtWeek,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isMonthSelected = true;
                isWeekSelected = false;
              });
            },
            child: Container(
              height: fullHeight * 0.07,
              width: fullWidth * 0.35,
              decoration: isMonthSelected
                  ? BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primarySplash]),
                      borderRadius: BorderRadius.circular(20),
                    )
                  : BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
              child: Center(
                child: Text(
                  Languages.of(context)!.txtMonth,
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  reportWidget(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.015),
      child: Column(
        children: [
          totalAndAverage(),
          buildStatisticsContainer(fullHeight, fullWidth, context)
        ],
      ),
    );
  }

  buildStatisticsContainer(
      double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.055),
      child: Column(
        children: [
          Text(
            isMonthSelected
                ? displayMonth()
                : Languages.of(context)!.txtThisWeek,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colur.txt_grey),
          ),
          isMonthSelected
              ? graphWidgetMonth(fullHeight, fullWidth, context)
              : graphWidgetWeek(fullHeight, fullWidth, context)
        ],
      ),
    );
  }

  graphWidgetMonth(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.05),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(
              top: fullHeight * 0.01,
              left: fullWidth * 0.03,
              right: fullWidth * 0.03),
          height: fullHeight * 0.5,
          width: MediaQuery.of(context).size.width * 3,
          child: BarChart(
            BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      direction: TooltipDirection.top,
                      tooltipBgColor: AppColors.lightGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        int day = group.x + 1;
                        return BarTooltipItem(
                          "${day.toString()} ${displayMonth()}" + '\n',
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY.toInt() - 1).toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndexForStepsChart = -1;
                        return;
                      }
                      touchedIndexForStepsChart =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                gridData: FlGridData(show: false),
                // titlesData: FlTitlesData(
                //   show: true,
                //   topTitles: AxisTitles(drawBehindEverything: false),
                //   bottomTitles: yAxisTitleData(),
                //   leftTitles: xAxisTitleData(),
                //   rightTitles: AxisTitles(drawBehindEverything: false),
                // ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getMonthTitles,
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                        left: BorderSide.none,
                        right: BorderSide.none,
                        bottom:
                            BorderSide(width: 1, color: Colur.gray_border))),
                barGroups: showingStepsGroups()),
            swapAnimationCurve: Curves.ease,
            swapAnimationDuration: Duration(seconds: 0),
          ),
        ),
      ),
    );
  }

  graphWidgetWeek(double fullHeight, double fullWidth, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: fullHeight * 0.05,
      ),
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(
            top: fullHeight * 0.01,
            left: fullWidth * 0.03,
            right: fullWidth * 0.03),
        height: fullHeight * 0.5,
        width: MediaQuery.of(context).size.width * 3,
        child: BarChart(
          BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 12,
                    direction: TooltipDirection.top,
                    tooltipBgColor: AppColors.lightGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay;
                      if (allDays.isNotEmpty) {
                        weekDay = allDays[groupIndex.toInt()];
                      } else {
                        weekDay = "";
                      }
                      return BarTooltipItem(
                        weekDay + '\n',
                        TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: (rod.toY.toInt() - 1).toString(),
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      touchedIndexForStepsChart = -1;
                      return;
                    }
                    touchedIndexForStepsChart =
                        barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              gridData: FlGridData(show: false),
              // titlesData: FlTitlesData(
              //   show: true,
              //   topTitles: AxisTitles(),
              //   bottomTitles: xAxisTitleData(),
              //   leftTitles: yAxisTitleData(),
              //   rightTitles: AxisTitles(),
              // ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getTitles,
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border(
                      left: BorderSide.none,
                      top: BorderSide.none,
                      right: BorderSide.none,
                      bottom: BorderSide(width: 1, color: Colur.gray_border))),
              barGroups: showingStepsGroups()),
          swapAnimationCurve: Curves.ease,
          swapAnimationDuration: Duration(seconds: 0),
        ),
      ),
    );
  }

  xAxisTitleData() {
    return AxisTitles(
      // drawBehindEverything: true,
      // margin: 20,
      // getTextStyles: isMonthSelected
      //     ? (context, value) => _unSelectedTextStyle()
      //     : (context, value) {
      //         if (allDays.isNotEmpty) {
      //           if (allDays[value.toInt()] == currentDay) {
      //             return _selectedTextStyle();
      //           } else {
      //             return _unSelectedTextStyle();
      //           }
      //         } else {
      //           return _unSelectedTextStyle();
      //         }
      //       },

      sideTitles: SideTitles(
        getTitlesWidget: (double value, TitleMeta meta) {
          if (allDays.isNotEmpty) {
            if (allDays[value.toInt()] == currentDay) {
              return Text(Languages.of(context)!.txtToday);
            } else {
              return Text(allDays[value.toInt()].substring(0, 3));
            }
          } else {
            return Text('');
          }
        },
      ),
    );
  }

  yAxisTitleData() {
    return AxisTitles(
        drawBehindEverything: true,
        sideTitles: SideTitles(
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return Text("1");
                case 1:
                  return Text("2");
                case 2:
                  return Text('3');
                case 3:
                  return Text("4");
                case 4:
                  return Text("5");
                case 5:
                  return Text("6");
                case 6:
                  return Text("7");
                case 7:
                  return Text("8");
                case 8:
                  return Text("9");
                case 9:
                  return Text("10");
                case 10:
                  return Text("11");
                case 11:
                  return Text("12");
                case 12:
                  return Text("13");
                case 13:
                  return Text("14");
                case 14:
                  return Text("15");
                case 15:
                  return Text("16");
                case 16:
                  return Text("17");
                case 17:
                  return Text("18");
                case 18:
                  return Text("19");
                case 19:
                  return Text("20");
                case 20:
                  return Text("21");
                case 21:
                  return Text("22");
                case 22:
                  return Text("23");
                case 23:
                  return Text("24");
                case 24:
                  return Text("25");
                case 25:
                  return Text("26");
                case 26:
                  return Text("27");
                case 27:
                  return Text("28");
                case 28:
                  return Text("29");
                case 29:
                  return Text("30");
                case 30:
                  return Text("31");
                default:
                  return Text("0");
              }
            },
            // getTextStyles: (value, context) => const TextStyle(
            //     color: Colur.txt_grey,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 12.4,
            //   ),
            interval: 5000),
        // margin: 15.0,
        axisNameSize: 10);
  }

  displayMonth() {
    switch (currentMonth) {
      case "01":
        return allMonths[0];
      case "02":
        return allMonths[1];
      case "03":
        return allMonths[2];
      case "04":
        return allMonths[3];
      case "05":
        return allMonths[4];
      case "06":
        return allMonths[5];
      case "07":
        return allMonths[6];
      case "08":
        return allMonths[7];
      case "09":
        return allMonths[8];
      case "10":
        return allMonths[9];
      case "11":
        return allMonths[10];
      case "12":
        return allMonths[11];
    }
  }

  totalAndAverage() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                Languages.of(context)!.txtTotal,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey),
              ),
              Text(
                isMonthSelected
                    ? totalStepsMonth!.toString()
                    : totalStepsWeek!.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colur.txt_white),
              )
            ],
          ),
          Column(
            children: [
              Text(
                Languages.of(context)!.txtAverage,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colur.txt_grey),
              ),
              Text(
                isMonthSelected
                    ? avgStepsMonth!.toStringAsFixed(2)
                    : avgStepsWeek!.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colur.txt_white),
              )
            ],
          )
        ],
      ),
    );
  }

  _selectedTextStyle() {
    return const TextStyle(
        color: Colur.txt_white, fontWeight: FontWeight.w400, fontSize: 14);
  }

  _unSelectedTextStyle() {
    return const TextStyle(
        color: Colur.txt_grey, fontWeight: FontWeight.w400, fontSize: 14);
  }

  List<BarChartGroupData> showingStepsGroups() {
    List<BarChartGroupData> list = [];

    if (isWeekSelected) {
      if (mapWeek.isNotEmpty) {
        for (int i = 0; i <= mapWeek.length - 1; i++) {
          list.add(makeBarChartGroupData(
              i, mapWeek.entries.toList()[i].value.toDouble(), weekColors[0]));
        }
      } else {
        for (int i = 0; i <= 7; i++) {
          list.add(makeBarChartGroupData(i, 0, weekColors[0]));
        }
      }
    } else {
      if (mapMonth.isNotEmpty) {
        for (int i = 0; i < mapMonth.length - 1; i++) {
          list.add(makeBarChartGroupData(
              i, mapMonth.entries.toList()[i].value.toDouble(), weekColors[0]));
        }
      } else {
        for (int i = 0; i <= daysInMonth!; i++) {
          list.add(makeBarChartGroupData(i, 0, weekColors[0]));
        }
      }
    }
    return list;
  }

  makeBarChartGroupData(int index, double steps, Color color) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          color: color,

          toY: steps + 0,

          fromY: 0, // fromY = 0
          // fromY: 10000,
          // colors: [Colur.green_gradient_color1, Colur.green_gradient_color2],
          width: 35,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      ],
    );
  }

  getChartDataOfStepsForMonth() async {
    List<String>? monthDates = [];
    var startDateofMonth = DateTime(currentDate.year, currentDate.month, 1);

    for (int i = 0; i <= daysInMonth!; i++) {
      monthDates.add(startDateofMonth.toString());
      var date = startDateofMonth.add(Duration(days: 1));
      startDateofMonth = date;
    }
    stepsDataMonth = await DataBaseHelper().getStepsForCurrentMonth();

    for (int i = 0; i <= monthDates.length - 1; i++) {
      bool isMatch = false;
      stepsDataMonth!.forEach((element) {
        if (element.stepDate == monthDates[i]) {
          isMatch = true;
          mapMonth.putIfAbsent(element.stepDate!, () => element.steps!);
        }
      });
      if (monthDates[i] == getDate(currentDate).toString()) {
        isMatch = true;
        mapMonth.putIfAbsent(monthDates[i], () => widget.currentStepCount!);
      }
      if (!isMatch) {
        mapMonth.putIfAbsent(monthDates[i], () => 0);
      }
    }
    setState(() {});
  }

  getTotalStepsMonth() async {
    var s = await DataBaseHelper().getTotalStepsForCurrentMonth();
    totalStepsMonth = s! + widget.currentStepCount!;

    avgStepsMonth =
        (totalStepsMonth! + widget.currentStepCount!) / daysInMonth!;
  }

  getChartDataOfStepsForWeek() async {
    allDays.clear();
    for (int i = 0; i <= 6; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - prefSelectedDay!))
          .add(Duration(days: i)));
      weekDates.add(currentWeekDates.toString());
      allDays.add(DateFormat('EEEE', getLocale().languageCode)
          .format(currentWeekDates));
    }
    stepsDataWeek = await DataBaseHelper().getStepsForCurrentWeek();
    for (int i = 0; i < weekDates.length; i++) {
      bool isMatch = false;
      stepsDataWeek!.forEach((element) {
        if (element.stepDate == weekDates[i]) {
          isMatch = true;
          mapWeek.putIfAbsent(element.stepDate!, () => element.steps!);
        }
      });
      if (weekDates[i] == getDate(currentDate).toString()) {
        isMatch = true;
        mapWeek.putIfAbsent(weekDates[i], () => widget.currentStepCount!);
      }
      if (!isMatch) {
        mapWeek.putIfAbsent(weekDates[i], () => 0);
      }
    }

    setState(() {});
  }

  getTotalStepsWeek() async {
    var s = await DataBaseHelper().getTotalStepsForCurrentWeek();
    totalStepsWeek = s! + widget.currentStepCount!;

    avgStepsWeek = (totalStepsWeek! + widget.currentStepCount!) / 7;
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }

  // buildWeekCircularIndicator(double fullHeight, String weekDay, double value) {
  //   return Column(
  //     children: [
  //       CircularProgressIndicator(
  //         strokeWidth: 5,
  //         value: value,
  //         valueColor: AlwaysStoppedAnimation(AppColors.primary),
  //         backgroundColor: Colors.white12,
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(top: fullHeight * 0.02),
  //         child: Text(
  //           weekDay,
  //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colur.txt_white),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
