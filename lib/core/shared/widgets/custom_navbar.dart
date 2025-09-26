import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

import 'package:quickrider/core/constants/app_colors.dart';
// Import your custom nav bar

import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickrider/core/constants/app_assets.dart';
import 'package:quickrider/core/constants/app_text_style.dart';

// Import your custom nav bar

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
      backgroundColor:
          Colors.transparent, // Make background transparent for custom shape
      barrierColor: Colors.black54, // Dim the background
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          // Use StatefulBuilder to manage bottom sheet's own state if needed
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 200.h, // Adjust height as needed
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Handle for dragging down
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
                        // --- UPDATED BOTTOM SHEET ITEMS ---
                        _buildBottomSheetItem(
                          icon: Icons.home_outlined, // Home icon
                          label: l10n.home,
                          onTap: () {
                            Navigator.pop(context); // Close sheet
                            widget
                                .onItemTapped(0); // Navigate to Home (index 0)
                          },
                        ),
                        _buildBottomSheetItem(
                          icon: Icons.history, // History icon
                          label: l10n.history,
                          onTap: () {
                            Navigator.pop(context); // Close sheet
                            widget.onItemTapped(
                                1); // Navigate to History (index 1)
                          },
                        ),
                        _buildBottomSheetItem(
                          icon: Icons.person_outline, // Profile icon
                          label: l10n.profile,
                          onTap: () {
                            Navigator.pop(context); // Close sheet
                            widget.onItemTapped(
                                2); // Navigate to Profile (index 2)
                          },
                        ),
                        // --- END UPDATED BOTTOM SHEET ITEMS ---
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Animate the icon back to its 'closed' state when bottom sheet is dismissed
      _animationController.reverse();
    });
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    // Removed SingleChildScrollView here as it's not needed for a single Column
    return Column(
      // This is the Column for the bottom sheet items
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
          maxLines: 1, // Ensure text stays on one line
          overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
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
            iconPath: AppAssets.homeIcon, // Assuming SVG assets for nav items
            label: l10n.home,
            index: 0,
          ),
          _buildNavItem(
            iconPath: AppAssets
                .user, // Example for history (replace with history icon)
            label: l10n.history,
            index: 1,
          ),
          // Spacer for the animated icon / floating action button
          SizedBox(width: 48.w),
          _buildNavItem(
            iconPath: AppAssets
                .user, // Example for profile (replace with profile icon)
            label: l10n.profile,
            index: 2,
          ),
          // If you have a 4th item, add it here
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
      // Use Material for InkWell splash effect
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onItemTapped(index),
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w, vertical: 4.h), // **Reduced vertical padding**
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                iconPath,
                width: 22.w, // **Reduced width**
                height: 22.h, // **Reduced height**
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : Colors.grey[600]!,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 2.h), // **Reduced height**
              Text(
                label,
                style: AppTextStyles.textStyle12().copyWith(
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize:
                      10.sp, // **Explicitly set or ensure small font size**
                ),
                maxLines: 1, // **Added to ensure single line**
                overflow:
                    TextOverflow.ellipsis, // **Added for overflow handling**
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Define a GlobalKey for your NavBar
