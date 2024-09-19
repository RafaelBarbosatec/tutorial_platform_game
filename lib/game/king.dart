import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:game_pig_king/utils/king_spritesheet.dart';

import '../utils/dust_particle_builder.dart';
import 'door.dart';

class King extends PlatformPlayer with HandleForces {
  bool moveEnabled = true;
  Door? doorInContacting;
  final bool animatedDoorOut;
  King({
    required super.position,
    this.animatedDoorOut = false,
  }) : super(
          size: Vector2(78, 58),
          animation: KingSpritesheet.animations,
        ) {
    mass = 2;
    opacity = animatedDoorOut ? 0 : 1;
    handleForcesEnabled = false;
    moveEnabled = false;
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (moveEnabled) {
      if (event.event == ActionEvent.DOWN &&
          (event.id == 1 || event.id == LogicalKeyboardKey.space)) {
        jump(jumpSpeed: 200);
      }

      if (event.event == ActionEvent.DOWN &&
          (event.id == 2 || event.id == LogicalKeyboardKey.keyZ)) {
        _execAttack();
      }
    }
    super.onJoystickAction(event);
  }

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (moveEnabled) {
      if (event.directional == JoystickMoveDirectional.MOVE_UP &&
          doorInContacting != null) {
        _enterDoor(doorInContacting!);
      }

      super.onJoystickChangeDirectional(event);
    }
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2.all(15),
        position: Vector2(31, 28),
      ),
    );
    return super.onLoad();
  }

  @override
  void onMove(
    double speed,
    Vector2 displacement,
    Direction direction,
    double angle,
  ) {
    if (direction.isHorizontal) {
      if (checkInterval('smoke_animation', 300, dtUpdate)) {
        if (direction.isRightSide) {
          showSmoke(SmokeDirection.left);
        } else {
          showSmoke(SmokeDirection.right);
        }
      }
    }
    super.onMove(speed, displacement, direction, angle);
  }

  @override
  void onJump(JumpingStateEnum state) {
    if (state == JumpingStateEnum.idle) {
      animation?.playOnceOther(
        'ground',
        runToTheEnd: true,
        useCompFlip: true,
      );

      showSmoke(SmokeDirection.center);
    }
    super.onJump(state);
  }

  void _execAttack() {
    animation?.playOnceOther(
      'attack',
      runToTheEnd: true,
      useCompFlip: true,
    );
    simpleAttackMelee(
      damage: 20,
      direction: lastDirectionHorizontal,
      marginFromCenter: 15,
      size: Vector2.all(32),
    );
  }

  void showSmoke(SmokeDirection direction) {
    final x = rectCollision.center.dx;
    final y = rectCollision.bottom;
    gameRef.add(
      DustParticleBuilder().build(
        priority: priority,
        position: Vector2(x, y),
        direction: direction,
      ),
    );
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
    moveEnabled = false;
    stopMove();
    animation?.playOnceOther(
      'dead',
      runToTheEnd: true,
      useCompFlip: true,
      onFinish: removeFromParent,
    );
    super.onDie();
  }

  void _enterDoor(Door doorInContacting) {
    moveEnabled = false;
    doorInContacting.playEnter(
      () async {
        await animation?.playOnceOther(
          'doorIn',
          onFinish: () {
            opacity = 0.0;
          },
        );
      },
    );
  }

  @override
  void onMount() {
    super.onMount();
    if (animatedDoorOut) {
      _playDoorOut();
    } else {
      _enabledForces();
    }
  }

  void _playDoorOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    doorInContacting?.playExit(
      () async {
        await animation?.playOnceOther(
          'doorOut',
          runToTheEnd: true,
          useCompFlip: true,
          onStart: () {
            opacity = 1;
          },
          onFinish: () {
            moveEnabled = true;
            handleForcesEnabled = true;
          },
        );
      },
    );
  }

  void _enabledForces() async {
    await Future.delayed(const Duration(milliseconds: 100));
    handleForcesEnabled = true;
    moveEnabled = true;
  }
}
