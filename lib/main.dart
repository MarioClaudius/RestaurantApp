import 'package:flutter/material.dart';
import 'package:restaurant_app/static/navigation_route.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant App",
      initialRoute: NavigationRoute.homeRoute.name,
      routes: {
        NavigationRoute.homeRoute.name: (context) => const Center(),
        NavigationRoute.detailRoute.name: (context) => const SizedBox()
      },
    );
  }
}
