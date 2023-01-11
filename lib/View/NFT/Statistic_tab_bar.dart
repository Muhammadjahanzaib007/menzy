
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menzy/Utils/App-Colors.dart';
import 'package:menzy/View/NFT/activity.dart';
import 'package:menzy/View/NFT/ranking.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class StatisticTabBar extends StatefulWidget {
  const StatisticTabBar({Key? key});

  @override
  State<StatisticTabBar> createState() => _StatisticTabBarState();
}

class _StatisticTabBarState extends State<StatisticTabBar>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(
      iconMargin: EdgeInsets.only(bottom: 10),
      text: 'Rankings',
      icon: Icon(
        FontAwesomeIcons.chartBar,
        size: 15,
      ),
    ),
    const Tab(
      iconMargin: EdgeInsets.only(bottom: 10),
      text: 'Activity',
      icon: Icon(
        Icons.local_activity,
        size: 15,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 1,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              size: 16,
              color: AppColors.white,
            ),
          ),
          toolbarHeight: 40,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,

          title: Text(
            'Statistic',
            style: AppTextStyle.boldWhite16,
          ),
          centerTitle: true,
          // ignore: prefer_const_literals_to_create_immutables

          // ignore: prefer_const_literals_to_create_immutables
          bottom: TabBar(
            labelColor: AppColors.white,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
            unselectedLabelColor: AppColors.blueDark,
            splashBorderRadius: BorderRadius.circular(10),
            indicatorColor: const Color(0xffF178B6),
            labelPadding: EdgeInsets.zero,

            // ignore: prefer_const_literals_to_create_immutables

            tabs: myTabs,
          ),
        ),
        body:  TabBarView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Rankings(),
            Activity(),
          ],
        ),
      ),
    );
  }
}
