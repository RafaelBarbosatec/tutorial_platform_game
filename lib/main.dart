import 'package:flutter/material.dart';
import 'package:game_pig_king/game/game_route.dart';
import 'package:game_pig_king/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => const HomePage(),
        ...GameRoute.build,
      },
    );
  }
}
