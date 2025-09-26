import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/app_colors.dart'; // Ensure this path is correct

import '../cubits/map_cubit.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/constants/app_text_style.dart';

import '../cubits/map_state.dart'; // Explicitly import map_state.dart

class SearchPlacesBottomSheet extends StatefulWidget {
  final MapsCubit mapCubit;
  final LatLng currentLocation;
  final String currentLocationName;

  const SearchPlacesBottomSheet({
    super.key,
    required this.mapCubit,
    required this.currentLocation,
    required this.currentLocationName,
  });

  @override
  State<SearchPlacesBottomSheet> createState() =>
      _SearchPlacesBottomSheetState();
}

class _SearchPlacesBottomSheetState extends State<SearchPlacesBottomSheet> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize pickup with the current location name from widget
    _pickupController.text = widget.currentLocationName;

    // Listen to focus changes for rebuilding the UI (e.g., icon colors)
    _pickupFocusNode.addListener(() {
      setState(() {});
    });
    _destinationFocusNode.addListener(() {
      setState(() {});
      // When destination field gets focus, ensure it's cleared if it was pre-filled
      // and update the Cubit state to clear selected destination and search results.
      if (_destinationFocusNode.hasFocus) {
        // Only clear if the user is about to type a new destination
        // and there's a selected destination currently.
        if (widget.mapCubit.state.destinationAddress != null &&
            _destinationController.text ==
                widget.mapCubit.state.destinationAddress) {
          _destinationController.clear();
          widget.mapCubit
              .clearDestinationSelection(); // Clears destination related state
        }
        // Also, if the current view is not already searching, set it to searchingDestination
        // if user focuses on the destination input.
        if (widget.mapCubit.state.currentView !=
            MapScreenView.searchingDestination) {
          widget.mapCubit.emit(MapsLoaded.fromState(widget.mapCubit.state)
              .copyWith(currentView: MapScreenView.searchingDestination));
        }
      }
    });

    // Listen to cubit state changes to update destination controller if a place is selected
    // This handles cases where a place is selected and you want to show its name in the field.
    widget.mapCubit.stream.listen((state) {
      if (state.destinationAddress != null &&
          _destinationController.text != state.destinationAddress) {
        _destinationController.text = state.destinationAddress!;
        // After selecting, unfocus the destination field
        _destinationFocusNode.unfocus();
        // Potentially close the bottom sheet here if desired
        // Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required Color focusedColor,
    IconData? prefixIcon,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      style: AppTextStyles.textStyle14().copyWith(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.textStyle14().copyWith(color: Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon,
                color: focusNode.hasFocus ? focusedColor : Colors.grey)
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: focusedColor, width: 2.w),
        ),
        suffixIcon: controller.text.isNotEmpty && !readOnly
            ? IconButton(
                icon: Icon(Icons.clear, size: 20.w, color: Colors.grey),
                onPressed: () {
                  controller.clear();
                  if (controller == _destinationController) {
                    widget.mapCubit
                        .clearDestinationSelection(); // Use the correct method
                  }
                  setState(() {}); // Rebuild to update suffixIcon visibility
                },
              )
            : null,
      ),
      onChanged: (value) {
        if (!readOnly) {
          widget.mapCubit.searchPlaces(value); // Only pass the query
          setState(() {}); // Rebuild to update suffixIcon visibility
        }
      },
      onTap: () {
        if (readOnly) {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.9.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildSearchField(
                  controller: _pickupController,
                  focusNode: _pickupFocusNode,
                  hintText: 'Pickup Location',
                  focusedColor: AppColors.secondary,
                  prefixIcon: Icons.my_location,
                  readOnly:
                      true, // Pickup is usually fixed or set by map interaction
                ),
                SizedBox(height: 15.h),
                _buildSearchField(
                  controller: _destinationController,
                  focusNode: _destinationFocusNode,
                  hintText: 'Where are you going?',
                  focusedColor: AppColors.primary,
                  prefixIcon: Icons.location_on,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: BlocBuilder<MapsCubit, MapsState>(
              // Use MapsCubit and MapsState
              bloc: widget.mapCubit,
              builder: (context, state) {
                // Show loading indicator if searching or if the overall state is loading
                if (state.isSearching || state is MapsLoading) {
                  // Check isSearching from base state
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MapsError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: AppTextStyles.textStyle14()
                          .copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                // If it's a loaded state and we have search results
                else if (state.searchResults.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, index) {
                      final place = state.searchResults[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on,
                            color: AppColors.primary),
                        title: Text(place.name,
                            style: AppTextStyles.textStyle16()),
                        subtitle: Text(place.address,
                            style:
                                AppTextStyles.textStyle12(color: Colors.grey)),
                        onTap: () {
                          widget.mapCubit.selectDestinationPlace(
                              place); // Correct method name
                          // Navigator.pop(context); // Pop the bottom sheet after selection
                        },
                      );
                    },
                  );
                }
                // If destination controller has text, but no search results
                else if (_destinationController.text.isNotEmpty &&
                    state.searchResults.isEmpty &&
                    !state.isSearching) {
                  return Center(
                    child: Text(
                      'No results found for "${_destinationController.text}"',
                      style: AppTextStyles.textStyle14()
                          .copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink(); // Default empty state
              },
            ),
          ),
        ],
      ),
    );
  }
}
