import 'package:flutter/material.dart';
import 'package:readthevoice/dino_game/game-constants.dart';
import 'package:readthevoice/dino_game/game-object.dart';
import 'package:readthevoice/dino_game/sprite.dart';

Sprite cloudSprite = Sprite(
    imagePath: "assets/images/dino-game/cloud.png", imageWidth: 92, imageHeight: 27);

class Cloud extends GameObject {
  final Offset worldLocation;

  Cloud({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * WORLD_TO_PIXEL_RATIO / 5,
      screenSize.height / 5 - cloudSprite.imageHeight - worldLocation.dy,
      cloudSprite.imageWidth.toDouble(),
      cloudSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(cloudSprite.imagePath);
  }
}
