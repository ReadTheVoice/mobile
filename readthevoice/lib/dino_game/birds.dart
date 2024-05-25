import 'package:flutter/material.dart';
import 'package:readthevoice/dino_game/game-constants.dart';
import 'package:readthevoice/dino_game/game-object.dart';
import 'package:readthevoice/dino_game/sprite.dart';

List<Sprite> birdFrames = [
  Sprite(
      imagePath: "assets/images/dino-game/bird/bird_1.png",
      imageHeight: 80,
      imageWidth: 92),
  Sprite(
      imagePath: "assets/images/dino-game/bird/bird_2.png",
      imageHeight: 80,
      imageWidth: 92),
];

class Ptera extends GameObject {
  // this is a logical location which is translated to pixel coordinates
  final Offset worldLocation;
  int frame = 0;

  Ptera({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
        (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO,
        4 / 7 * screenSize.height -
            birdFrames[frame].imageHeight -
            worldLocation.dy,
        birdFrames[frame].imageWidth.toDouble(),
        birdFrames[frame].imageHeight.toDouble());
  }

  @override
  Widget render() {
    return Image.asset(
      birdFrames[frame].imagePath,
      gaplessPlayback: true,
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    frame = (elapsedTime.inMilliseconds / 200).floor() % 2;
  }
}
