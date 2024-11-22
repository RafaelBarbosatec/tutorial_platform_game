import 'package:bonfire/bonfire.dart';

class GameStage {
  final GameStagesEnum stage;
  final String initialMap;
  final Vector2 initialPlayerPosition;
  final int countEnemiesDeadObjective;

  GameStage({
    required this.stage,
    required this.initialMap,
    required this.initialPlayerPosition,
    required this.countEnemiesDeadObjective,
  });
}

enum GameStagesEnum {
  stage1,
  stage2;

  GameStage getStageData() {
    switch (this) {
      case GameStagesEnum.stage1:
        return GameStage(
          stage: this,
          initialMap: 'map',
          countEnemiesDeadObjective: 1,
          initialPlayerPosition: Vector2(3, 7),
        );
      case GameStagesEnum.stage2:
        return GameStage(
          stage: this,
          initialMap: 'map',
          countEnemiesDeadObjective: 1,
          initialPlayerPosition: Vector2(3, 7),
        );
    }
  }
}
