import 'package:flutter/material.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';

void main() {
  AppModules().setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
