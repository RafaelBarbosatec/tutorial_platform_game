import 'package:bonfire/bonfire.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'map_controller_state.dart';

enum Map {
  map,
  map2;

  factory Map.fromString(String text) {
    return Map.values.firstWhere((e) => e.name == text);
  }
}

class MapNavigate extends Equatable {
  final Map map;
  final Vector2 initialPlayerPosition;

  const MapNavigate({
    required this.map,
    required this.initialPlayerPosition,
  });

  @override
  List<Object?> get props => [map, initialPlayerPosition];
}

class MapControllerCubit extends Cubit<MapControllerState> {
  MapControllerCubit()
      : super(
          MapControllerState(
            navigate: MapNavigate(
              map: Map.map,
              initialPlayerPosition: Vector2(3, 7),
            ),
          ),
        );

  void changeMap(MapNavigate map) {
    emit(MapControllerState(navigate: map));
  }
}
