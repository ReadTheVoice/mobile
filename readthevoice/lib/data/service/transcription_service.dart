import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<File> createTempFile(String meetingTitle, String transcription) async {
  final tempDir = await getTemporaryDirectory();
  final tempFile = File(
      '${tempDir.path}/${meetingTitle.replaceAll(" ", "_")}_${DateTime.now().toString().replaceAll(" ", "_")}.txt');
  await tempFile.writeAsBytes(utf8.encode(transcription));
  return tempFile;
}

Future<void> shareTextFile(String meetingTitle, String transcription) async {
  final tempFile =
      await createTempFile(meetingTitle, transcription);
  await Share.shareXFiles([XFile(tempFile.path)]);
}

Future<void> downloadTextFile(String meetingTitle, String transcription, {Function? onSuccess}) async {
  final tempFile = await createTempFile(meetingTitle, transcription);
  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Please select an output file:',
    fileName: '${meetingTitle.replaceAll(" ", "_")}_${DateTime.now().toString().replaceAll(" ", "_")}.txt',
    allowedExtensions: ["txt"],
    bytes: tempFile.readAsBytesSync()
  );

  if(outputFile != null) {
    if(onSuccess != null) {
      onSuccess(outputFile);
    }
  }
  // if (outputFile == null) {
  //   // User canceled the picker
  // }
}
