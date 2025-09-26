import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil for .w, .h, .r
import '../../../l10n/app_localizations.dart';

import 'package:quickrider/core/constants/app_colors.dart';
import 'package:quickrider/core/shared/widgets/quick_ride_bottom_nav_bar.dart'; // Import your custom nav bar

import 'package:quickrider/features/profile/presentation/screens/profile_screen.dart';

import 'features/map/presentation/screens/map_screens.dart'; // Assuming you have this

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // A list of widgets/screens for your bottom navigation
    final List<Widget> widgetOptions = <Widget>[
      const MapScreen(), // Your Map Screen is now the Home tab
      const Center(
          child: Text(
              'History Screen Content')), // Replace with actual HistoryScreen
      const ProfileScreen(), // Replace with your actual ProfileScreen
    ];

    return Scaffold(
      extendBody: true,
      body: widgetOptions.elementAt(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          quickRideNavBarKey.currentState?.showCustomBottomSheet();
        },
        shape: const CircleBorder(),
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: quickRideNavBarKey.currentState?.animation ??
              const AlwaysStoppedAnimation(0.0),
          color: Colors.white,
          size: 28.w,
        ),
      ),
      bottomNavigationBar: QuickRideBottomNavBar(
        key: quickRideNavBarKey,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
