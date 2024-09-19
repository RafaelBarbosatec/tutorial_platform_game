import 'package:bonfire/bonfire.dart';
import 'package:bonfire_bloc/bonfire_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:game_pig_king/controllers/map_controller_cubit.dart';
import 'package:game_pig_king/game/king.dart';

import '../main.dart';
import '../utils/my_game_enemy.dart';
import '../utils/pig_spritesheet.dart';

class Pig extends PlatformEnemy
    with
        HandleForces,
        UseLifeBar,
        RandomMovement,
        MyEnemyGame,
        BonfireBlocReader<MapControllerCubit> {
  Pig({
    required super.position,
    required int id,
    double? currentLife,
  }) : super(
          size: Vector2(34, 28),
          animation: PigSpritesheet.animations,
          speed: 40,
        ) {
    if (currentLife != null) {
      updateLife(currentLife);
    }

    this.id = id;
    setupLifeBar(
      borderRadius: BorderRadius.circular(50),
      barLifeDrawPosition: BarLifeDrawPosition.bottom,
      offset: Vector2(0, -1),
    );
    mass = 2;
  }

  @override
  void update(double dt) {
    if (!isDead && jumpingState != JumpingStateEnum.down) {
      final player = gameRef.player;
      if ((player as King?)?.moveEnabled == true) {
        seeAndMoveToPlayer(
          movementAxis: MovementAxis.horizontal,
          radiusVision: Game.tileSize * 2,
          closePlayer: _closePlayer,
          notObserved: () {
            runRandomMovement(
              dt,
              speed: speed / 2,
              directions: RandomMovementDirections.horizontally,
            );
            return false;
          },
        );
      }
    }
    super.update(dt);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2.all(14),
        position: Vector2(10, 8.5),
      ),
    );
    return super.onLoad();
  }

  @override
  void onReceiveDamage(AttackOriginEnum attacker, double damage, identify) {
    animation?.playOnceOther(
      'hit',
      runToTheEnd: true,
      useCompFlip: true,
    );
    super.onReceiveDamage(attacker, damage, identify);
  }

  @override
  void onDie() {
    super.onDie();
    stopMove();
    animation?.playOnceOther(
      'dead',
      runToTheEnd: true,
      useCompFlip: true,
      onFinish: removeFromParent,
    );
    bloc.updateEnemyState(this);
  }

  Future<void> _closePlayer(Player player) async {
    if (checkInterval('execAttack', 1000, dtUpdate)) {
      animation?.playOnceOther(
        'attack',
        runToTheEnd: true,
        useCompFlip: true,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      simpleAttackMeleeByDirection(
        direction: directionThatPlayerIs(),
        damage: 10,
        size: size / 2,
        attackFrom: AttackOriginEnum.ENEMY,
        withPush: false,
      );
    }
  }

  @override
  void onRemoveLife(double life) {
    super.onRemoveLife(life);
    bloc.updateEnemyState(this);
  }

  @override
  void onMove(
    double speed,
    Vector2 displacement,
    Direction direction,
    double angle,
  ) {
    super.onMove(speed, displacement, direction, angle);
    bloc.updateEnemyState(this);
  }
}
