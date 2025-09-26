import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickrider/core/constants/app_colors.dart';

import '../presentation_exports.dart';
import '../widgets/search_places_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Load map data when the screen initializes - now using the correct cubit method
    context.read<MapsCubit>().getAndSetCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    final state = context.read<MapsCubit>().state;
    // Ensure we are only animating if the state is MapsLoaded and has a location
    if (state is MapsLoaded && state.currentLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(state.currentLocation!, 14.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapsCubit, MapsState>(
        // Corrected Cubit and State types
        listener: (context, state) {
          if (state is MapsLoaded && state.currentLocation != null) {
            // Corrected state type
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(state.currentLocation!, 14.0),
            );
          } else if (state is MapsError) {
            // Corrected state type
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MapsLoading || state is MapsInitial) {
            // Corrected state types
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapsError) {
            // Corrected state type
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context
                        .read<MapsCubit>()
                        .getAndSetCurrentLocation(), // Corrected Cubit and method
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is MapsLoaded) {
            // Corrected state type
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: state.currentLocation ??
                        const LatLng(0,
                            0), // Provide a default if currentLocation is null
                    zoom: 14.0,
                  ),
                  markers: state.markers, // Now available in MapsState
                  circles: state.circles, // Now available in MapsState
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
                // Search bar at the top
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SearchPlacesBottomSheet(
                          mapCubit:
                              context.read<MapsCubit>(), // Corrected Cubit type
                          currentLocation: state.currentLocation!,
                          currentLocationName: state.pickupAddress ??
                              'Your Current Location', // Use pickupAddress if set
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0,
                                0.1), // Corrected deprecated withOpacity
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10.w),
                          Expanded(
                            // Added Expanded to prevent text overflow
                            child: Text(
                              (state.destinationAddress != null &&
                                      state.destinationAddress!.isNotEmpty)
                                  ? state
                                      .destinationAddress! // Show destination if selected
                                  : 'Where are you going?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.grey),
                              overflow: TextOverflow
                                  .ellipsis, // Add overflow handling
                            ),
                          ),
                          SizedBox(width: 10.w), // Added space for spinner
                          if (state.isSearching) // Now using the getter
                            const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Floating action button for current location
                Positioned(
                  bottom: 120.h,
                  right: 20.w,
                  child: FloatingActionButton(
                    heroTag: 'map_location_button',
                    mini: true,
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      context
                          .read<MapsCubit>()
                          .getAndSetCurrentLocation(); // Corrected Cubit and method
                    },
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
                // Floating action button for refreshing nearby drivers
                Positioned(
                  bottom: 180.h,
                  right: 20.w,
                  child: FloatingActionButton(
                    heroTag: 'map_refresh_drivers_button',
                    mini: true,
                    backgroundColor: AppColors.secondary,
                    onPressed: () {
                      context
                          .read<MapsCubit>()
                          .refreshNearbyDrivers(); // Corrected Cubit and method
                    },
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
