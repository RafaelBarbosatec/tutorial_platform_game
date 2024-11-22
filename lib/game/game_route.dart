import 'package:flutter/material.dart';
import 'package:game_pig_king/domain/game_stage.dart';
import 'package:game_pig_king/game/game.dart';

abstract class GameRoute {
  static String rounteName = '/game';
  static Map<String, Widget Function(BuildContext context)> build = {
    rounteName: (context) => Game(
          stage: ModalRoute.of(context)?.settings.arguments as GameStagesEnum,
        )
  };

  static open(BuildContext context, GameStagesEnum stage,
      {bool replace = false}) {
    if (replace) {
      Navigator.of(context).pushReplacementNamed(rounteName, arguments: stage);
    } else {
      Navigator.of(context).pushNamed(rounteName, arguments: stage);
    }
  }
}
