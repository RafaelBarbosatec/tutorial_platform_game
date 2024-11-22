import 'package:bonfire/bonfire.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_pig_king/domain/entities/enemy_state.dart';

import '../utils/my_game_enemy.dart';
import 'map_controller_state.dart';

class MapNavigate extends Equatable {
  final String map;
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

  MapControllerCubit({
    required String initialMap,
    required Vector2 initialPlayerPosition,
  }) : super(
          MapControllerState(
            navigate: MapNavigate(
              map: initialMap,
              initialPlayerPosition: initialPlayerPosition,
              animateDoorOut: false,
            ),
          ),
        );

  void changeMap(MapNavigate map) {
    emit(state.copyWith(navigate: map));
  }

  void updateEnemyState(MyEnemyGame enemy) {
    if (_enemiesStates[state.navigate.map] == null) {
      _enemiesStates[state.navigate.map] = {};
    }

    final map = _enemiesStates[state.navigate.map]!;

    if (map.containsKey(enemy.id)) {
      final enemyState = map[enemy.id]!;
      enemyState.life = enemy.life;
      enemyState.position = enemy.position;
    } else {
      map[enemy.id] = EnemyState(
        id: enemy.id,
        position: enemy.position,
        life: enemy.life,
        cutSceneExecuted: enemy.cutSceneExecuted,
      );
    }
  }

  EnemyState? getEnemyState(int id) {
    if (_enemiesStates[state.navigate.map] == null) {
      _enemiesStates[state.navigate.map] = {};
    }
    final map = _enemiesStates[state.navigate.map]!;
    return map[id];
  }

  void updatePlayerLife(double life) {
    emit(state.copyWith(playerLife: life));
  }

  int countEnemiesDead() {
    int enemiesDead = 0;

    for (var states in _enemiesStates.values) {
      for (var enemy in states.values) {
        if (enemy.life <= 0) {
          enemiesDead++;
        }
      }
    }
    return enemiesDead;
  }
}
