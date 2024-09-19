import 'package:bonfire/bonfire.dart';
import 'package:bonfire_bloc/bonfire_bloc.dart';
import 'package:game_pig_king/game/king.dart';
import 'package:game_pig_king/utils/door_spritesheet.dart';

import '../controllers/map_controller_cubit.dart';

class Door extends GameDecoration
    with Sensor, BonfireBlocReader<MapControllerCubit> {
  final String targetMap;
  final Vector2 targetPosition;
  Door({
    required super.position,
    required this.targetMap,
    required this.targetPosition,
  }) : super.withSprite(
          sprite: DoorSpritesheet.idle,
          size: Vector2(46, 56),
        );

  @override
  void onContact(GameComponent component) {
    if (component is King) {
      component.doorInContacting = this;
    }
    super.onContact(component);
  }

  @override
  void onContactExit(GameComponent component) {
    if (component is King) {
      component.doorInContacting = null;
    }
    super.onContactExit(component);
  }

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(
      size: Vector2(16, 23),
      position: Vector2(15, 56 - 23),
    ));
    return super.onLoad();
  }

  @override
  int get priority => LayerPriority.MAP;

  Future<void> playEnter(Future<void> Function() runInDoorAnimation) async {
    final newSprite = await DoorSpritesheet.opened;

    await playSpriteAnimationOnce(
      DoorSpritesheet.opening,
      onStart: () async {
        sprite = newSprite;
      },
    );

    await runInDoorAnimation();

    bloc.changeMap(
      MapNavigate(
        map: GameMapEnum.fromString(targetMap),
        initialPlayerPosition: targetPosition,
      ),
    );
  }

  Future<void> playExit(Future<void> Function() runOutDoorAnimation) async {
    final closedSprite = await DoorSpritesheet.idle;
    final openedSprite = await DoorSpritesheet.opened;

    await playSpriteAnimationOnce(
      DoorSpritesheet.opening,
      onStart: () async {
        sprite = openedSprite;
      },
    );

    await runOutDoorAnimation();

    await playSpriteAnimationOnce(
      DoorSpritesheet.clossing,
      onStart: () async {
        sprite = closedSprite;
      },
    );
  }
}
