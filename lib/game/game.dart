import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_pig_king/components/door.dart';
import 'package:game_pig_king/components/king.dart';
import 'package:game_pig_king/components/stage_game_controller.dart';
import 'package:game_pig_king/controllers/map_controller_state.dart';
import 'package:game_pig_king/domain/game_stage.dart';

import '../components/box.dart';
import '../components/empty_component.dart';
import '../components/pig_box.dart';
import '../components/pig_normal.dart';
import '../controllers/map_controller_cubit.dart';
import '../widgets/live_bar_widget.dart';

class Game extends StatelessWidget {
  static const tileSize = 32.0;

  final GameStagesEnum stage;
  const Game({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final stageData = stage.getStageData();

    return BlocProvider(
      create: (context) => MapControllerCubit(
        initialMap: stageData.initialMap,
        initialPlayerPosition: stageData.initialPlayerPosition,
      ),
      child: Scaffold(
        body: BlocBuilder<MapControllerCubit, MapControllerState>(
          builder: (context, state) {
            return BonfireWidget(
              key: Key(state.navigate.map),
              map: WorldMapByTiled(
                WorldMapReader.fromAsset('map/${state.navigate.map}.tmj'),
                objectsBuilder: {
                  'pig': (p) => _buildPig(
                        p,
                        context.read<MapControllerCubit>(),
                      ),
                  'door': (properties) => Door(
                        position: properties.position,
                        targetMap: properties.others['map'],
                        targetPosition: _getVector2FromString(
                          properties.others['position'],
                        ),
                      ),
                  'box': (p) => Box(
                        position: p.position,
                      ),
                  'pig_box': (p) => _buildBoxPig(
                        p,
                        context.read<MapControllerCubit>(),
                      ),
                },
              ),
              playerControllers: [
                Keyboard(),
                Joystick(
                  directional: JoystickDirectional(),
                  actions: [
                    JoystickAction(
                      actionId: 1,
                    ),
                    JoystickAction(
                      actionId: 2,
                      margin: const EdgeInsets.only(
                        bottom: 50,
                        right: 120,
                      ),
                      color: Colors.red,
                    )
                  ],
                )
              ],
              components: [
                StageGameController(
                  stage: stageData,
                )
              ],
              player: King(
                position: state.navigate.initialPlayerPosition * tileSize,
                animatedDoorOut: state.navigate.animateDoorOut,
                currentLife: state.playerLife,
              ),
              cameraConfig: CameraConfig(
                zoom: getZoomFromMaxVisibleTile(context, tileSize, 10),
              ),
              backgroundColor: const Color(0xFF3f3851),
              globalForces: [
                GravityForce2D(),
              ],
              overlayBuilderMap: {
                LiveBarWidget.name: (context, game) => LiveBarWidget(
                      game: game,
                    ),
              },
              initialActiveOverlays: const [LiveBarWidget.name],
            );
          },
        ),
      ),
    );
  }

  GameComponent _buildPig(properties, MapControllerCubit controller) {
    final state = controller.getEnemyState(properties.id ?? 0);
    if (state == null) {
      return PigNormal(
        position: properties.position,
        id: properties.id ?? 0,
      );
    } else {
      if (state.life <= 0) {
        return EmptyComponent();
      }
      return PigNormal(
        position: state.position,
        id: properties.id ?? 0,
        currentLife: state.life,
      );
    }
  }

  GameComponent _buildBoxPig(properties, MapControllerCubit controller) {
    final state = controller.getEnemyState(properties.id ?? 0);
    if (state == null) {
      return PigBox(
        position: properties.position,
        id: properties.id ?? 0,
      );
    } else {
      if (state.life <= 0) {
        return EmptyComponent();
      }
      return PigBox(
        position: state.position,
        id: properties.id ?? 0,
        cutSceneExecuted: state.cutSceneExecuted,
      );
    }
  }

  Vector2 _getVector2FromString(String text) {
    final parts = text.split(',');
    return Vector2(
      (double.tryParse(parts[0]) ?? 0),
      (double.tryParse(parts[1]) ?? 0),
    );
  }
}
