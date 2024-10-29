import 'dart:math';

import 'package:bonfire/bonfire.dart';

import '../utils/box_spritesheet.dart';

enum BoxPieceType { piece1, piece2, piece3, piece4 }

class BoxPiece extends GameDecoration
    with Movement, BlockMovementCollision, HandleForces, ElasticCollision {
  BoxPiece({
    required super.position,
    required BoxPieceType type,
    required Direction direction,
  }) : super.withSprite(
          size: Vector2(10, 10),
          sprite: _getSprite(type),
        ) {
    speed = 100 * Random().nextDouble() + 100;
    moveFromDirection(direction);
    addForce(
      ResistanceForce2D(
        id: 'resistence',
        value: Vector2(5, 0),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (checkInterval('remove', 4000, dt, firstCheckIsTrue: false)) {
      _initRemove();
    }
  }

  static _getSprite(BoxPieceType type) {
    switch (type) {
      case BoxPieceType.piece1:
        return BoxSpritesheet.getPiece1();
      case BoxPieceType.piece2:
        return BoxSpritesheet.getPiece2();
      case BoxPieceType.piece3:
        return BoxSpritesheet.getPiece3();
      case BoxPieceType.piece4:
        return BoxSpritesheet.getPiece3();
    }
  }

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    if (other is BoxPiece) {
      return false;
    }
    return super.onBlockMovement(intersectionPoints, other);
  }

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(size: size));
    return super.onLoad();
  }

  void _initRemove() {
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.7),
        onComplete: removeFromParent,
      ),
    );
  }
}
