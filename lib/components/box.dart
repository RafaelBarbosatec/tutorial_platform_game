import 'package:bonfire/bonfire.dart';
import 'package:game_pig_king/components/king.dart';

import '../utils/box_spritesheet.dart';
import 'box_piece.dart';

class Box extends GameDecoration
    with Movement, BlockMovementCollision, HandleForces {
  final bool destroyable;
  Box({
    required super.position,
    this.destroyable = false,
  }) : super.withSprite(
          size: Vector2(22, 16),
          sprite: BoxSpritesheet.idle,
        );

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: size,
        isSolid: true,
      ),
    );
    return super.onLoad();
  }

  bool alreadyDoDamage = false;

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    if (destroyable) {
      _throwPieces();
      if (other is King && !alreadyDoDamage) {
        alreadyDoDamage = true;
        other.handleAttack(AttackOriginEnum.ENEMY, 1, null);
      }
      removeFromParent();
    }
    return super.onBlockMovement(intersectionPoints, other);
  }

  void _throwPieces() {
    gameRef.add(
      BoxPiece(
        position: position,
        direction: Direction.upLeft,
        type: BoxPieceType.piece1,
      ),
    );
    gameRef.add(
      BoxPiece(
        position: position,
        direction: Direction.upLeft,
        type: BoxPieceType.piece2,
      ),
    );
    gameRef.add(
      BoxPiece(
        position: position,
        direction: Direction.upRight,
        type: BoxPieceType.piece3,
      ),
    );
    gameRef.add(
      BoxPiece(
        position: position,
        direction: Direction.upRight,
        type: BoxPieceType.piece4,
      ),
    );
  }
}
