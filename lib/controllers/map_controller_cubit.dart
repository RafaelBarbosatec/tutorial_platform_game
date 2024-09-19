import 'package:bonfire/bonfire.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_pig_king/domain/entities/enemy_state.dart';

import '../utils/my_game_enemy.dart';
import 'map_controller_state.dart';

enum GameMapEnum {
  map,
  map2;

  factory GameMapEnum.fromString(String text) {
    return GameMapEnum.values.firstWhere((e) => e.name == text);
  }
}

class MapNavigate extends Equatable {
  final GameMapEnum map;
  final Vector2 initialPlayerPosition;
  final bool animateDoorOut;

  const MapNavigate({
    required this.map,
    required this.initialPlayerPosition,
    this.animateDoorOut = true,
  });

  @override
  List<Object?> get props => [
        map,
        initialPlayerPosition,
        animateDoorOut,
      ];
}

class MapControllerCubit extends Cubit<MapControllerState> {
  final Map<String, Map<int, EnemyState>> _enemiesStates = {};

  MapControllerCubit()
      : super(
          MapControllerState(
            navigate: MapNavigate(
              map: GameMapEnum.map,
              initialPlayerPosition: Vector2(3, 7),
              animateDoorOut: false,
            ),
          ),
        );

  void changeMap(MapNavigate map) {
    emit(MapControllerState(navigate: map));
  }

  void updateEnemyState(MyEnemyGame enemy) {
    if (_enemiesStates[state.navigate.map.name] == null) {
      _enemiesStates[state.navigate.map.name] = {};
    }

    final map = _enemiesStates[state.navigate.map.name]!;

    if (map.containsKey(enemy.id)) {
      final enemyState = map[enemy.id]!;
      enemyState.life = enemy.life;
      enemyState.position = enemy.position;
    } else {
      map[enemy.id] = EnemyState(
        id: enemy.id,
        position: enemy.position,
        life: enemy.life,
      );
    }
  }

  EnemyState? getEnemyState(int id) {
    if (_enemiesStates[state.navigate.map.name] == null) {
      _enemiesStates[state.navigate.map.name] = {};
    }
    final map = _enemiesStates[state.navigate.map.name]!;
    return map[id];
  }
}
