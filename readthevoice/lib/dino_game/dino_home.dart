import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/dino_game/cactus.dart';
import 'package:readthevoice/dino_game/cloud.dart';
import 'package:readthevoice/dino_game/dino.dart';
import 'package:readthevoice/dino_game/game-object.dart';
import 'package:readthevoice/dino_game/ground.dart';

class DinoHome extends StatefulWidget {
  const DinoHome({super.key});

  @override
  State<DinoHome> createState() => _DinoHomeState();
}

class _DinoHomeState extends State<DinoHome>
    with SingleTickerProviderStateMixin {
  Dino dino = Dino();
  double runDistance = 0;
  double runVelocity = 30;

  AnimationController? worldController;
  Duration lastUpdateCall = const Duration();

  List<Cactus> cacti = [Cactus(worldLocation: const Offset(200, 0))];

  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  @override
  void initState() {
    super.initState();

    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController?.addListener(_update);
    worldController?.forward();
  }

  void _die() {
    setState(() {
      worldController?.stop();
      dino.die();
    });
  }

  _update() {
    Duration worldControllerLastElapsedDuration =
        worldController?.lastElapsedDuration ?? const Duration();
    dino.update(lastUpdateCall, worldControllerLastElapsedDuration);

    double elapsedTimeSeconds =
        (worldControllerLastElapsedDuration - lastUpdateCall).inMilliseconds /
            1000;

    runDistance += runVelocity * elapsedTimeSeconds;

    Size screenSize = MediaQuery.of(context).size;

    Rect dinoRect = dino.getRect(screenSize, runDistance);
    for (Cactus cactus in cacti) {
      Rect obstacleRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(obstacleRect)) {
        _die();
      }

      if (obstacleRect.right < 0) {
        setState(() {
          cacti.remove(cactus);
          cacti.add(Cactus(
              worldLocation:
                  Offset(runDistance + Random().nextInt(100) + 50, 0)));
        });
      }
    }

    for (Ground groundLet in ground) {
      if (groundLet.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          ground.remove(groundLet);
          ground.add(Ground(
              worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0)));
        });
      }
    }

    for (Cloud cloud in clouds) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          clouds.remove(cloud);
          clouds.add(Cloud(
              worldLocation: Offset(
                  clouds.last.worldLocation.dx + Random().nextInt(100) + 50,
                  Random().nextInt(40) - 20.0)));
        });
      }
    }

    lastUpdateCall = worldControllerLastElapsedDuration;
  }

  @override
  void dispose() {
    worldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      children.add(AnimatedBuilder(
          animation: worldController!,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          }));
    }

    children.add(Positioned(
        bottom: 10,
        child: SizedBox(
          child: Text(
            "${tr("play_dino_score_text")}: ${runDistance.round()}",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20),
          ),
        )));

    return Scaffold(
      appBar: AppBar(
        title: const Text("app_name").tr(),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dino.jump();
        },
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}
