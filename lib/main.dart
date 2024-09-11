import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_pig_king/controllers/map_controller_state.dart';
import 'package:game_pig_king/game/door.dart';
import 'package:game_pig_king/game/king.dart';

import 'controllers/map_controller_cubit.dart';
import 'game/pig.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Game(),
    );
  }
}

class Game extends StatelessWidget {
  static const tileSize = 32.0;
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: MapControllerCubit(),
      child: Scaffold(
        body: BlocBuilder<MapControllerCubit, MapControllerState>(
          builder: (context, state) {
            return BonfireWidget(
              key: Key(state.navigate.map.name),
              map: WorldMapByTiled(
                WorldMapReader.fromAsset('map/${state.navigate.map.name}.tmj'),
                objectsBuilder: {
                  'pig': (properties) => Pig(
                        position: properties.position,
                      ),
                  'door': (properties) => Door(
                        position: properties.position,
                        targetMap: properties.others['map'],
                        targetPosition: _getVector2FromString(
                          properties.others['position'],
                        ),
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
              player: King(
                position: state.navigate.initialPlayerPosition * tileSize,
              ),
              cameraConfig: CameraConfig(
                zoom: getZoomFromMaxVisibleTile(context, tileSize, 10),
              ),
              backgroundColor: const Color(0xFF3f3851),
              globalForces: [
                GravityForce2D(),
              ],
            );
          },
        ),
      ),
    );
  }

  Vector2 _getVector2FromString(String text) {
    final parts = text.split(',');
    return Vector2(
      (double.tryParse(parts[0]) ?? 0) * tileSize,
      (double.tryParse(parts[1]) ?? 0) * tileSize,
    );
  }
}
