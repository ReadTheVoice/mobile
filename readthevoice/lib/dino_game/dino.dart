import 'package:flutter/material.dart';
import 'package:readthevoice/dino_game/game-constants.dart';
import 'package:readthevoice/dino_game/game-object.dart';
import 'package:readthevoice/dino_game/sprite.dart';

List<Sprite> dino = [
  Sprite(
      imagePath: "assets/images/dino-game/dino/dino_1.png",
      imageWidth: 88,
      imageHeight: 94),
  Sprite(
      imagePath: "assets/images/dino-game/dino/dino_2.png",
      imageWidth: 88,
      imageHeight: 94),
  Sprite(
      imagePath: "assets/images/dino-game/dino/dino_3.png",
      imageWidth: 88,
      imageHeight: 94),
  Sprite(
      imagePath: "assets/images/dino-game/dino/dino_4.png",
      imageWidth: 88,
      imageHeight: 94),
  Sprite(
      imagePath: "assets/images/dino-game/dino/dino_5.png",
      imageWidth: 88,
      imageHeight: 94),
  Sprite(
      imagePath: "assets/images/dino-game/dino/dino_6.png",
      imageWidth: 88,
      imageHeight: 94),
];

enum DinoState {
  jumping,
  running,
  dead,
}

class Dino extends GameObject {
  Sprite currentSprite = dino[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;

  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 2 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    currentSprite = dino[(elapsedTime.inMilliseconds / 100).floor() % 2 + 2];

    double elapsedTimeSeconds = (elapsedTime - lastUpdate).inMilliseconds / 1000;

    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= GRAVITY_PPSS * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      // velY = 900;
      velY = 1000;
      // velY = 650;
    }
  }

  void die() {
    currentSprite = dino[5];
    state = DinoState.dead;
  }
}
