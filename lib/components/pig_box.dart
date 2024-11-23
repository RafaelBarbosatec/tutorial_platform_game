import 'package:bonfire/bonfire.dart';
import 'package:game_pig_king/components/box.dart';
import 'package:game_pig_king/components/king.dart';
import 'package:game_pig_king/game/game.dart';

import '../utils/pig_spritesheet.dart';
import 'pig_base.dart';

class PigBox extends PigBase {
  SimpleDirectionAnimation get nextBaseAnimation => PlatformAnimations(
        idleRight: PigSpritesheet.getIdleBox(),
        runRight: PigSpritesheet.getRunBox(),
      ).toSimpleDirectionAnimation();

  bool runningScene = false;

  Vector2 get pigBoxSize => Vector2(26, 30);

  RectangleHitbox get pigBoxHitbox => RectangleHitbox(
        size: Vector2.all(Game.tileSize / 2),
        position: Vector2(width / 6, height / 2.2),
      );

  PigBox({
    required super.position,
    bool cutSceneExecuted = false,
    required int id,
  }) : super(id: 10000) {
    findingPlayer = false;
    this.id = id;
    this.cutSceneExecuted = cutSceneExecuted;
    setupVision(
      checkWithRaycast: false,
    );
  }

  @override
  void update(double dt) {
    seePlayer(
      observed: (player) {
        if (!runningScene) {
          _startScene(player);
        }
      },
      radiusVision: Game.tileSize * 5,
    );
    super.update(dt);
  }

  void _startScene(Player player) {
    runningScene = true;
    if (cutSceneExecuted) {
      return;
    }
    cutSceneExecuted = true;
    (player as King).moveEnabled = false;
    (player).stopMove();
    bloc.updateEnemyState(this);

    gameRef.startScene(
      [
        CameraSceneAction.target(this),
        MoveWhileSceneAction(
          component: this,
          whileThis: (game) {
            final canMove = !collidingWith(game.query<Box>().first);
            if (!canMove) {
              game.query<Box>().first.removeFromParent();
            }
            return canMove;
          },
          doThis: (move) => move.moveRight(),
        ),
        AwaitSceneAction(wait: _playPickBox),
        MoveWhileSceneAction(
          component: this,
          whileThis: (_) => position.x > Game.tileSize * 11,
          doThis: (move) => move.moveLeft(),
        ),
        AwaitSceneAction(wait: _playThrowBox),
        CameraSceneAction.target(gameRef.player),
      ],
    );
  }

  Future<void> _playPickBox() async {
    await animation?.playOnce(
      PigSpritesheet.getPickingBox(),
      runToTheEnd: true,
      offset: Vector2(0, 5),
      onStart: () {
        size = pigBoxSize;
        _updateHitbox(pigBoxHitbox);
      },
      onFinish: () async {
        await replaceAnimation(
          nextBaseAnimation,
          doIdle: true,
        );
      },
    );
  }

  void _updateHitbox(ShapeHitbox hitbox) {
    children.query<ShapeHitbox>().forEach((element) {
      element.removeFromParent();
    });
    add(hitbox);
  }

  Future<void> _playThrowBox() async {
    animation?.playOnce(
      PigSpritesheet.getThrowingBox(),
      runToTheEnd: true,
      useCompFlip: true,
      onFinish: () {
        _updateHitbox(baseHitbox);
        size = PigBase.sizeBase;
        replaceAnimation(
          baseAnimation,
          doIdle: true,
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 300));
    _throwBox();
    (gameRef.player as King).moveEnabled = true;
  }

  void _throwBox() {
    gameRef.add(
      Box(
        position: position.translated(0, size.y / -3),
        destroyable: true,
      )..moveUpLeft(speed: 100),
    );
  }
}
