import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_pig_king/game/king.dart';

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
    return Scaffold(
      body: BonfireWidget(
        map: WorldMapByTiled(WorldMapReader.fromAsset('map/map.tmj')),
        playerControllers: [
          Joystick(
            directional: JoystickDirectional(),
            actions: [
              JoystickAction(
                actionId: 1,

              )
            ],
          )
        ],
        player: King(
          position: Vector2(tileSize * 3, 5 * tileSize),
        ),
        cameraConfig: CameraConfig(
          zoom: getZoomFromMaxVisibleTile(context, tileSize, 15),
        ),
        backgroundColor: const Color(0xFF3f3851),
        globalForces: [
          GravityForce2D(
            value: Vector2(0, 1000)
          ),
        ],
      ),
    );
  }
}
