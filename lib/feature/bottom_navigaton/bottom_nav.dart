import 'package:app/feature/screens/home/home_page.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  // Các màn hình tương ứng với các tab
  final List<Widget> _screens = [
    const HomePage(),
    const Text('Tìm kiếm'),
    const Text('Tôi'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật giá trị _selectedIndex
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Màn hình ứng dụng chính
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _screens,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CrystalNavigationBar(
                enableFloatingNavBar: true,
                currentIndex: _selectedIndex, // Chỉ mục tab hiện tại
                unselectedItemColor: Colors.white70,
                backgroundColor: Colors.black.withOpacity(0.3),
                onTap: _onItemTapped, // Xử lý sự kiện khi tab được chọn
                items: [
                  // Home
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
                  // Profile
                  CrystalNavigationBarItem(
                    icon: IconlyBold.moreSquare,
                    unselectedIcon: IconlyLight.moreSquare,
                    selectedColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}