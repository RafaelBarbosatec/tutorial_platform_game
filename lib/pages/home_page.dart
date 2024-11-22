import 'package:flutter/material.dart';
import 'package:game_pig_king/domain/game_stage.dart';
import 'package:game_pig_king/game/game_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GameRoute.open(context, GameStagesEnum.stage1);
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
