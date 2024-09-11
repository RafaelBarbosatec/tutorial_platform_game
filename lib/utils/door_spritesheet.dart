import 'package:bonfire/bonfire.dart';

abstract class DoorSpritesheet {
  static Future<Sprite> get idle => Sprite.load('door/idle.png');
  static Future<Sprite> get opened => Sprite.load('door/opened.png');

  static Future<SpriteAnimation> get clossing => SpriteAnimation.load(
        'door/closing.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(46, 56),
        ),
      );

  static Future<SpriteAnimation> get opening => SpriteAnimation.load(
        'door/opening.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(46, 56),
        ),
      );
}
