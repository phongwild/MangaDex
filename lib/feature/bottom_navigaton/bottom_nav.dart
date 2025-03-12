import 'package:app/feature/screens/home/home_page.dart';
import 'package:app/feature/screens/search/search_page.dart';
import 'package:app/feature/screens/user/user_page.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();
  DateTime? lastBackPressTime; // Lưu thời điểm nhấn back gần nhất
  final List<Widget> _screens = [
    const HomePage(),
    const SearchPage(),
    const UserPage(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index; // Cập nhật giá trị của ValueNotifier
    _pageController.jumpToPage(index);
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      showToast('Nhấn lần nữa để thoát!!');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _screens,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedIndex,
                builder: (context, index, child) {
                  return CrystalNavigationBar(
                    enableFloatingNavBar: true,
                    currentIndex: index,
                    unselectedItemColor: Colors.white70,
                    backgroundColor: Colors.black.withOpacity(0.3),
                    onTap: _onItemTapped,
                    items: [
                      CrystalNavigationBarItem(
                        icon: IconlyBold.home,
                        unselectedIcon: IconlyLight.home,
                        selectedColor: Colors.white,
                      ),
                      CrystalNavigationBarItem(
                        icon: IconlyBold.search,
                        unselectedIcon: IconlyLight.search,
                        selectedColor: Colors.white,
                      ),
                      CrystalNavigationBarItem(
                        icon: IconlyBold.moreSquare,
                        unselectedIcon: IconlyLight.moreSquare,
                        selectedColor: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
