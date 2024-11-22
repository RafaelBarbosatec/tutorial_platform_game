// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'map_controller_cubit.dart';

class MapControllerState extends Equatable {
  final MapNavigate navigate;
  final double playerLife;

  const MapControllerState({required this.navigate, this.playerLife = 3});

  @override
  List<Object?> get props => [navigate, playerLife];

  MapControllerState copyWith({
    MapNavigate? navigate,
    double? playerLife,
  }) {
    return MapControllerState(
      navigate: navigate ?? this.navigate,
      playerLife: playerLife ?? this.playerLife,
    );
  }
}
