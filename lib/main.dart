import 'package:flutter/material.dart';
import 'package:quickrider/root/quickrider.dart';

import 'core/services/secure_storage.dart';
import 'services/onboarding_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize your dependencies

  runApp(const QuickRider(initialRoute: '/'));
}
