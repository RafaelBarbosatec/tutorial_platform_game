import 'package:bonfire/bonfire.dart';

abstract class PigSpritesheet {
  static Future<SpriteAnimation> get idle => _flipSpriteSheet(
        path: 'pig/idle.png',
        size: Vector2(34, 28),
        amout: 11,
      );

  static Future<SpriteAnimation> get run => _flipSpriteSheet(
        path: 'pig/run.png',
        size: Vector2(34, 28),
        amout: 6,
      );

  static Future<SpriteAnimation> get hit => _flipSpriteSheet(
        path: 'pig/hit.png',
        size: Vector2(34, 28),
        amout: 2,
      );

  static Future<SpriteAnimation> get dead => _flipSpriteSheet(
        path: 'pig/dead.png',
        size: Vector2(34, 28),
        amout: 4,
      );

  static Future<SpriteAnimation> get attack => _flipSpriteSheet(
        path: 'pig/attack.png',
        size: Vector2(34, 28),
        amout: 5,
      );

  static Future<SpriteAnimation> getPickingBox() {
    return Flame.images.load("pig_box/picking_box.png").then((image) async {
      final flipped = await image.flipAnimation(
        size: Vector2(26, 30),
        count: 5,
      );
      return SpriteAnimation.fromFrameData(
        flipped,
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(26, 30),
        ),
      );
    });
  }

  static Future<SpriteAnimation> getIdleBox() {
    return Flame.images.load("pig_box/idle.png").then((image) async {
      final flipped = await image.flipAnimation(
        size: Vector2(26, 30),
        count: 9,
      );
      return SpriteAnimation.fromFrameData(
        flipped,
        SpriteAnimationData.sequenced(
          amount: 9,
          stepTime: 0.1,
          textureSize: Vector2(26, 30),
        ),
      );
    });
  }

  static Future<SpriteAnimation> getRunBox() {
    return Flame.images.load("pig_box/run.png").then((image) async {
      final flipped = await image.flipAnimation(
        size: Vector2(26, 30),
        count: 6,
      );
      return SpriteAnimation.fromFrameData(
        flipped,
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: Vector2(26, 30),
        ),
      );
    });
  }

  static Future<SpriteAnimation> getThrowingBox() {
    return Flame.images.load("pig_box/throwing_box.png").then((image) async {
      final flipped = await image.flipAnimation(
        size: Vector2(26, 30),
        count: 5,
      );
      return SpriteAnimation.fromFrameData(
        flipped,
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(26, 30),
        ),
      );
    });
  }

  static PlatformAnimations get animations => PlatformAnimations(
        idleRight: idle,
        runRight: run,
        others: {
          'hit': hit,
          'dead': dead,
          'attack': attack,
        },
        centerAnchor: Vector2(14, 19),
      );

  static Future<SpriteAnimation> _flipSpriteSheet({
    required String path,
    required Vector2 size,
    required amout,
  }) async {
    Image image = await Flame.images.load(path);

    image = await image.flipAnimation(
      size: size,
      count: amout,
    );

    return image.getAnimation(size: size, amount: amout);
  }
}
