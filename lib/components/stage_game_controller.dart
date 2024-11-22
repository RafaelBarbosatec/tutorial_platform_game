import 'package:bonfire/bonfire.dart';
import 'package:bonfire_bloc/bonfire_bloc.dart';
import 'package:flutter/material.dart';
import 'package:game_pig_king/controllers/map_controller_cubit.dart';
import 'package:game_pig_king/domain/game_stage.dart';
import 'package:game_pig_king/game/game_route.dart';

class StageGameController extends GameComponent
    with BonfireBlocReader<MapControllerCubit> {
  final GameStage stage;

  StageGameController({required this.stage});

  bool gameOver = false;
  bool winner = false;

  @override
  void update(double dt) {
    if (checkInterval('check_objectives', 2000, dt)) {
      _checkGame();
    }
    super.update(dt);
  }

  void _checkGame() {
    final count = bloc.countEnemiesDead();
    if (count >= stage.countEnemiesDeadObjective && !winner) {
      winner = true;
      gameRef.player?.stopMove();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Parabêns'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  GameRoute.open(
                    context,
                    GameStagesEnum.values[stage.stage.index + 1],
                    replace: true,
                  );
                },
                child: const Text('Próxima fase'),
              )
            ],
          );
        },
      );
    }

    if (gameRef.player?.isDead == true && !gameOver) {
      gameOver = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Game over'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  GameRoute.open(
                    context,
                    stage.stage,
                    replace: true,
                  );
                },
                child: const Text('Tentar novamente'),
              )
            ],
          );
        },
      );
    }
  }
}
