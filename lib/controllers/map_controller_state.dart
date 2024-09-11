import 'package:equatable/equatable.dart';

import 'map_controller_cubit.dart';

class MapControllerState extends Equatable {
  final MapNavigate navigate;

  const MapControllerState({required this.navigate});

  @override
  List<Object?> get props => [navigate];
}
