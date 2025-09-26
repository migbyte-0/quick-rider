import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:quickrider/services/logger_services.dart'; // Use your existing logger

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final AppLogger logger; // Inject your logger

  NetworkInfoImpl(this.connectivity,
      {required this.logger}); // Update constructor

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    final bool connected = connectivityResult != ConnectivityResult.none;
    logger.d('NetworkInfo: Is connected? $connected'); // Use your logger
    return connected;
  }
}
