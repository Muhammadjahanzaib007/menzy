import 'package:flutter/material.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:menzy/View/NFT/nft_market_screen.dart';
import 'package:menzy/View/Steps/step_history.dart';

import '../../utils/App-Colors.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({this.oldCount});
  final int? oldCount;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  String? title;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(),
      StepHistory(),
      NFTMarketScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 82,
        child: Column(
          children: [
            Divider(
              thickness: 2,
              color: AppColors.blueDark,
            ),
            BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: AppColors.background,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Transform.scale(
                      scale: 0.7,
                      child: Image.asset(
                        'assets/images/home.png',
                        color: _selectedIndex == 0
                            ? AppColors.primary
                            : Color.fromARGB(255, 236, 234, 234),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.scale(
                      scale: 0.7,
                      child: Image.asset(
                        'assets/images/history.png',
                        color: _selectedIndex == 1
                            ? AppColors.primary
                            : Color.fromARGB(255, 236, 234, 234),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Transform.scale(
                      scale: 0.6,
                      child: Image.asset(
                        'assets/images/nft.png',
                        color: _selectedIndex == 2
                            ? AppColors.primary
                            : Color.fromARGB(255, 236, 234, 234),
                      ),
                    ),
                    label: '',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                // selectedItemColor: AppColors.primary,
                // unselectedItemColor: AppColors.whiteDarkSplash,
                selectedIconTheme: IconThemeData(color: AppColors.primary),
                unselectedIconTheme: IconThemeData(color: AppColors.lightGrey),
                onTap: _onItemTapped,
                elevation: 0),
          ],
        ),
      ),
    );
  }
}
