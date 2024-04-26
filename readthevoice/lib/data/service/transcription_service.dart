import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

Future<File> createTempFile(String meetingTitle, String transcription) async {
  final tempDir = await getTemporaryDirectory();
  final tempFile = File(
      '${tempDir.path}/${meetingTitle.replaceAll(" ", "_")}_${DateTime.now().toString().replaceAll(" ", "_")}.txt');

  String textToSend = "\t$meetingTitle \n\n$transcription";
  await tempFile.writeAsBytes(utf8.encode(textToSend));
  return tempFile;
}

Future<void> shareTextFile(String meetingTitle, String transcription) async {
  final tempFile = await createTempFile(meetingTitle, transcription);
  await Share.shareXFiles([XFile(tempFile.path)]);
}

Future<void> shareQrCode(
    String meetingTitle, String data, Color color, Function onError,
    {String? logoPath}) async {
  final qrCode = QrCode.fromData(
    data: data,
    errorCorrectLevel: QrErrorCorrectLevel.H,
  );

  final qrImage = QrImage(qrCode);
  final qrImageBytes = await qrImage.toImageAsBytes(
    size: 512,
    format: ImageByteFormat.png,
    decoration: PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(color: color),
      image: PrettyQrDecorationImage(
        image: AssetImage(logoPath ?? 'assets/logos/logo_new.png'),
      ),
    ),
  );

  if (qrImageBytes == null) {
    onError();
  } else {
    final tempDir = await getTemporaryDirectory();
    final buffer = qrImageBytes.buffer;
    final tempFile = await File(
            '${tempDir.path}/${meetingTitle.replaceAll(" ", "_")}_qr_code.png')
        .writeAsBytes(buffer.asUint8List(
            qrImageBytes.offsetInBytes, qrImageBytes.lengthInBytes));

    await Share.shareXFiles([XFile(tempFile.path)]);
  }
}

Future<void> downloadTextFile(String meetingTitle, String transcription,
    {Function? onSuccess, Function? onCanceled}) async {
  final tempFile = await createTempFile(meetingTitle, transcription);
  String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName:
          '${meetingTitle.replaceAll(" ", "_")}_${DateTime.now().toString().replaceAll(" ", "_")}.txt',
      allowedExtensions: ["txt"],
      bytes: tempFile.readAsBytesSync());

  if (outputFile != null) {
    if (onSuccess != null) {
      onSuccess(outputFile);
    }
  }
  // if (outputFile == null) {
  //   // User canceled the picker
  // }
}
