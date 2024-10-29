import 'package:bonfire/bonfire.dart';
import 'package:flutter/painting.dart';
import 'package:game_pig_king/components/pig_base.dart';

class PigNormal extends PigBase with UseLifeBar {
  PigNormal({
    required super.position,
    required super.id,
    double? currentLife,
  }) {
    id = id;
    setupLifeBar(
      borderRadius: BorderRadius.circular(50),
      barLifeDrawPosition: BarLifeDrawPosition.bottom,
      offset: Vector2(0, -1),
    );
    if (currentLife != null) {
      updateLife(currentLife);
    }
  }
}
