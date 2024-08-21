import 'package:bonfire/bonfire.dart';
import 'package:game_pig_king/utils/king_spritesheet.dart';

import '../utils/dust_particle_builder.dart';

class King extends PlatformPlayer with HandleForces {
  bool moveEnabled = true;
  King({required super.position})
      : super(
          size: Vector2(78, 58),
          animation: PlatformAnimations(
            idleRight: KingSpritesheet.idle,
            runRight: KingSpritesheet.run,
            centerAnchor: Vector2(32, 30),
            jump: PlatformJumpAnimations(
              jumpUpRight: KingSpritesheet.jump,
              jumpDownRight: KingSpritesheet.fall,
            ),
            others: {
              'ground': KingSpritesheet.ground,
              'attack': KingSpritesheet.attack,
              'hit': KingSpritesheet.hit,
              'dead': KingSpritesheet.dead,
              'doorIn': KingSpritesheet.doorIn,
              'doorOut': KingSpritesheet.doorOut,
            },
          ),
        ) {
    mass = 2;
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN && event.id == 1) {
      jump(jumpSpeed: 200);
    }

    if (event.event == ActionEvent.DOWN && event.id == 2) {
      _execAttack();
    }
    super.onJoystickAction(event);
  }

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (moveEnabled) {
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
    stopMove(forceIdle: true);
    animation?.playOnceOther(
      'dead',
      runToTheEnd: true,
      useCompFlip: true,
      onFinish: removeFromParent,
    );
    super.onDie();
  }
}
