import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickrider/core/constants/app_colors.dart';
import 'package:quickrider/core/constants/app_assets.dart';
import 'package:quickrider/core/constants/app_text_style.dart';
import 'package:quickrider/l10n/app_localizations.dart';
// Import ScreenUtil

// Define a GlobalKey for your NavBar
final GlobalKey<QuickRideBottomNavBarState> quickRideNavBarKey =
    GlobalKey<QuickRideBottomNavBarState>();

class QuickRideBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const QuickRideBottomNavBar({
    super.key, // Use the provided key
    required this.selectedIndex,
    required this.onItemTapped,
  }); // Pass the key to super

  @override
  State<QuickRideBottomNavBar> createState() => QuickRideBottomNavBarState();
}

class QuickRideBottomNavBarState extends State<QuickRideBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Make these methods public so they can be called via the GlobalKey
  Animation<double> get animation => _animation;

  void showCustomBottomSheet() {
    // Made public
    // Animate the icon to its 'open' state
    _animationController.forward();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildBottomSheetItem(
                        icon: Icons.home,
                        label: l10n.home,
                        onTap: () {
                          Navigator.pop(context);
                          print('Settings tapped');
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.history,
                        label: l10n.history,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/payment');
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.verified_user,
                        label: l10n.profile,
                        onTap: () {
                          Navigator.pop(context);
                          print('Logout tapped');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _animationController.reverse();
    });
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28.w, color: AppColors.primary),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.descriptionText.copyWith(color: Colors.black87),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(
            iconPath: AppAssets.homeIcon,
            label: l10n.home,
            index: 0,
          ),
          _buildNavItem(
            iconPath: AppAssets.user,
            label: l10n.rideHistory,
            index: 1,
          ),
          SizedBox(width: 48.w),
          _buildNavItem(
            iconPath: AppAssets.user,
            label: l10n.profile,
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final bool isSelected = widget.selectedIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onItemTapped(index),
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                iconPath,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : Colors.grey[600]!,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: AppTextStyles.textStyle12().copyWith(
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
