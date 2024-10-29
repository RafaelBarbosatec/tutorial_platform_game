import 'package:bonfire/bonfire.dart';

abstract class KingSpritesheet {
  static Future<SpriteAnimation> get idle => SpriteAnimation.load(
        'king/idle.png',
        SpriteAnimationData.sequenced(
          amount: 11,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get run => SpriteAnimation.load(
        'king/run.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get jump => SpriteAnimation.load(
        'king/jump.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get fall => SpriteAnimation.load(
        'king/fall.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get ground => SpriteAnimation.load(
        'king/ground.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get attack => SpriteAnimation.load(
        'king/attack.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get hit => SpriteAnimation.load(
        'king/hit.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get dead => SpriteAnimation.load(
        'king/dead.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get doorIn => SpriteAnimation.load(
        'king/door_in.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static Future<SpriteAnimation> get doorOut => SpriteAnimation.load(
        'king/door_out.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2(78, 58),
        ),
      );

  static PlatformAnimations get animations => PlatformAnimations(
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
      );
}
