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
  final ValueNotifier<bool> _isNavVisible = ValueNotifier<bool>(true);
  DateTime? lastBackPressTime; // Lưu thời điểm nhấn back gần nhất
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomePage(),
      const SearchPage(),
      UserPage(isNavVisible: _isNavVisible),
    ];
  }

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
            ValueListenableBuilder(
              valueListenable: _selectedIndex,
              builder: (context, i, _) {
                return PageView(
                  controller: _pageController,
                  physics: (i == 0 || i == 1)
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  onPageChanged: (index) {
                    _selectedIndex.value = index;
                    if (index == 0 || index == 1) {
                      _isNavVisible.value = true;
                    }
                    if (index == 2) {
                      // _isNavVisible.value = false;
                    }
                  },
                  children: _screens,
                );
              },
            ),
            _bottomNav()
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isNavVisible,
        builder: (context, isVisible, _) {
          return AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            offset: isVisible ? Offset.zero : const Offset(0, 1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isVisible ? 1.0 : 0.0,
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
          );
        },
      ),
    );
  }
}
