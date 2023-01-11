import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menzy/Utils/App-Colors.dart';
import 'package:menzy/utils/App-TextStyle.dart';

class Rankings extends StatefulWidget {
  const Rankings({Key? key});

  @override
  State<Rankings> createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  String? _selecteRankings;
  String? _selectChain;
  List numbring = [
    '#1',
    '#2',
    '#3',
    '#4',
    '#5',
    '#6',
    '#7',
    '#8',
    '#9',
    '#10',
  ];
  List<String> rankingsItem = [
    "\$10 M to 30 M",
    "\$20 M to 40 M",
    "\$30 M to 50 M",
    "\$40 M to 60 M",
  ];
  List chainItems = [
    "1",
    "2",
    "3",
    "4",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.blueDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      dropdownColor: AppColors.background,
                      icon: const Icon(
                        FontAwesomeIcons.chevronDown,
                        size: 10,
                        color: AppColors.blueDark,
                      ),
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/category.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'All Categories',
                            style: AppTextStyle.mediumWhite14,
                          ),
                        ],
                      ), // Not necessary for Option 1
                      value: _selecteRankings,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selecteRankings = newValue.toString();
                          },
                        );
                      },
                      items: rankingsItem.map(
                        (filterItems) {
                          return DropdownMenuItem(
                            value: filterItems,
                            child: Text(
                              filterItems,
                              style: AppTextStyle.regularWhite14,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.blueDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      dropdownColor: AppColors.background,
                      icon: const Icon(
                        FontAwesomeIcons.chevronDown,
                        size: 10,
                        color: AppColors.blueDark,
                      ),
                      isExpanded: true,
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/link.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'All Chains',
                            style: AppTextStyle.mediumWhite14,
                          ),
                        ],
                      ), // Not necessary for Option 1
                      value: _selectChain,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selectChain = newValue.toString();
                          },
                        );
                      },
                      items: chainItems.map(
                        (filterItems) {
                          return DropdownMenuItem(
                            value: filterItems,
                            child: Text(
                              filterItems,
                              style: AppTextStyle.regularWhite14,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Theme(
              data: ThemeData(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent),
              child: SizedBox(
                height: Get.height - 226,
                child: ListView.builder(
                    itemCount: numbring.length,
                    itemBuilder: ((context, index) => Column(
                          children: [
                            ExpansionTile(
                              backgroundColor: AppColors.blueDark,
                              collapsedIconColor: AppColors.white,
                              iconColor: AppColors.white,
                              title: Row(
                                children: [
                                  Text(
                                    numbring[index],
                                    style: AppTextStyle.regularWhite12,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                      'assets/images/male_profile.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Perperzon',
                                    style: AppTextStyle.boldWhite14,
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 65,
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 7),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: AppColors.white, width: 1),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                            'assets/images/favourite.png'),
                                        Text(
                                          '31.5',
                                          style: AppTextStyle.regularWhite10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(
                                    thickness: 1,
                                    height: 2,
                                    color: Color(0xff5C72B0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          const Text(
                                            '24h%',
                                            style: TextStyle(
                                                color: Color(0xff5C72B0),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            '11,3%',
                                            style: TextStyle(
                                                color: Color(0xff27AE60),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          const Text(
                                            'Floor Price',
                                            style: TextStyle(
                                                color: Color(0xff5C72B0),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                  'assets/images/favourite.png'),
                                              const Text(
                                                '3.421 ',
                                                style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          const Text(
                                            'Owner',
                                            style: TextStyle(
                                                color: Color(0xff5C72B0),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            '70k',
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          const Text(
                                            'Items',
                                            style: TextStyle(
                                                color: Color(0xff5C72B0),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            '9,1k',
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                              height: 2,
                              color: AppColors.blueDark,
                            ),
                          ],
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
