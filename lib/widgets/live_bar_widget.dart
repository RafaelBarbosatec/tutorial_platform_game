import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_pig_king/controllers/map_controller_cubit.dart';
import 'package:game_pig_king/controllers/map_controller_state.dart';

class LiveBarWidget extends StatelessWidget {
  static const name = 'live_bar';
  final BonfireGameInterface game;
  const LiveBarWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          SizedBox(
            width: 130,
            height: 230,
            child: SpriteWidget.asset(
              path: 'interface/live_bar.png',
            ),
          ),
          BlocBuilder<MapControllerCubit, MapControllerState>(
              builder: (_, state) {
            final life = state.playerLife;

            return Padding(
              padding: const EdgeInsets.only(
                left: 30,
                top: 23.5,
              ),
              child: Row(
                children: [
                  AnimatedOpacity(
                    duration: Durations.medium2,
                    opacity: life >= 1 ? 1 : 0,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Transform.scale(
                        scale: 2,
                        child: SpriteAnimationWidget.asset(
                          path: 'interface/small_heart_idle.png',
                          anchor: Anchor.center,
                          data: SpriteAnimationData.sequenced(
                            amount: 8,
                            stepTime: 0.1,
                            textureSize: Vector2(18, 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  AnimatedOpacity(
                    duration: Durations.medium2,
                    opacity: life >= 2 ? 1 : 0,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Transform.scale(
                        scale: 2,
                        child: SpriteAnimationWidget.asset(
                          path: 'interface/small_heart_idle.png',
                          anchor: Anchor.center,
                          data: SpriteAnimationData.sequenced(
                            amount: 8,
                            stepTime: 0.1,
                            textureSize: Vector2(18, 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  AnimatedOpacity(
                    duration: Durations.medium2,
                    opacity: life >= 3 ? 1 : 0,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Transform.scale(
                        scale: 2,
                        child: SpriteAnimationWidget.asset(
                          path: 'interface/small_heart_idle.png',
                          anchor: Anchor.center,
                          data: SpriteAnimationData.sequenced(
                            amount: 8,
                            stepTime: 0.1,
                            textureSize: Vector2(18, 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
