import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menzy/Utils/App-TextStyle.dart';
import 'package:menzy/utils/App-Colors.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key});
  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  String? _selecteSale;
  String? _selectChain;

  List<String> salesItem = [
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
  List title = [
    'Genesis kakira',
    'ZEED Run',
    'Lavern Laboy',
    'Frosty Glare',
    'Future of Polygon X',
    'East Phyllisport',
    'Genesis kakira',
    'ZEED Run',
    'Lavern Laboy',
    'Frosty Glare',
  ];
  List subtitle = [
    'Kristin Watson',
    'Kakira #5233',
    'Kristin Watson',
    'Marvin McKinney',
    'Marjorie',
    'Perperzon',
    'Kakira #5233',
    'Kristin Watson',
    'Marvin McKinney',
    'Marjorie',
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
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset('assets/images/sale.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Sales',
                            style: AppTextStyle.mediumWhite14,
                          ),
                        ],
                      ), // Not necessary for Option 1
                      value: _selecteSale,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selecteSale = newValue.toString();
                          },
                        );
                      },
                      items: salesItem.map(
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
                    itemCount: title.length,
                    itemBuilder: ((context, index) => Column(
                          children: [
                            ExpansionTile(
                              backgroundColor: AppColors.blueDark,
                              collapsedIconColor: AppColors.white,
                              iconColor: AppColors.white,
                              title: Row(
                                children: [
                                  const SizedBox(
                                    width: 0,
                                  ),
                                  Container(
                                    width: 37,
                                    height: 57,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/male_profile.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title[index],
                                        style: AppTextStyle.boldWhite14,
                                      ),
                                      Text(
                                        subtitle[index],
                                        style: AppTextStyle.regularWhite10,
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        '11,3%',
                                        style: TextStyle(
                                          color: Color(0xff27AE60),
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(
                                                'assets/images/favourite.png'),
                                            const Text(
                                              '31.5',
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      const Text(
                                        '6 Minutes ago',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
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
                                            'USD Price',
                                            style: TextStyle(
                                                color: Color(0xff5C72B0),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            '\$19K',
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
                                            'Quantity',
                                            style: TextStyle(
                                                color: Color(0xff5C72B0),
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            '14.9K',
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
                                            'floor price',
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
                                                '16,4',
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
                                            'traded',
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
                                                '26,4',
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
