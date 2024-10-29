import 'package:bonfire/bonfire.dart';

class BoxSpritesheet {
  static Future<Sprite> get idle => Sprite.load('box/idle.png');

  static Future<Sprite> getPiece1() {
    return Sprite.load('box/piece1.png');
  }

  static Future<Sprite> getPiece2() {
    return Sprite.load('box/piece2.png');
  }

  static Future<Sprite> getPiece3() {
    return Sprite.load('box/piece3.png');
  }

  static Future<Sprite> getPiece4() {
    return Sprite.load('box/piece4.png');
  }
}
