import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

enum SmokeDirection {
  left,
  right,
  center;
}

class DustParticleBuilder {
  final Tween<double> noiseLeft = Tween(begin: -0.5, end: -1);
  final Tween<double> noiseRight = Tween(begin: 0.5, end: 1);
  final Tween<double> noiseCenter = Tween(begin: -1, end: 1);
  final Tween<double> noiseY = Tween(begin: 0, end: -1);
  final Tween<double> fade = Tween(begin: 0.2, end: 0.6);
  final random = Random();

  ParticleSystemComponent build({
    required int priority,
    required Vector2 position,
    required SmokeDirection direction,
  }) {
    return ParticleSystemComponent(
      priority: priority,
      position: position,
      particle: Particle.generate(
        count: 10,
        lifespan: 0.8,
        applyLifespanToChildren: true,
        generator: (i) {
          double speedX;
          switch (direction) {
            case SmokeDirection.left:
              speedX = noiseLeft.transform(random.nextDouble());
              break;
            case SmokeDirection.right:
              speedX = noiseRight.transform(random.nextDouble());
              break;
            case SmokeDirection.center:
              speedX = noiseCenter.transform(random.nextDouble());
              break;
          }
          var speed = Vector2(
                speedX,
                noiseY.transform(random.nextDouble()),
              ) *
              (5 + i.toDouble());
          return AcceleratedParticle(
            position: speed / 4,
            speed: speed,
            child: CircleParticle(
              radius: 1.5,
              paint: Paint()
                ..color = Colors.white
                    .withOpacity(fade.transform(random.nextDouble())),
            ),
          );
        },
      ),
    );
  }
}
