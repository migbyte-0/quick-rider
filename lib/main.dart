import 'package:flutter/material.dart';
import 'package:quickrider/root/quickrider.dart';

import 'core/di/di.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  await di.sl.allReady();

  runApp(const QuickRider(initialRoute: '/'));
}
