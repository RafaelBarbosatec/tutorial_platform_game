import 'package:bonfire/bonfire.dart';

class EnemyState {
  int id;
  Vector2 position;
  double life;
  bool cutSceneExecuted;

  EnemyState({
    required this.id,
    required this.position,
    required this.life,
    this.cutSceneExecuted = false,
  });
}
