import 'package:flutter/material.dart';
import 'package:readthevoice/theme/theme.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ThemeProvider with ChangeNotifier {
  File fileData = File('');

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<File> initFile() async {
    final Directory tempDir = await getApplicationDocumentsDirectory();
    final File file = File('${tempDir.path}/settings.json');
    return file;
  }

  Future<void> initTheme() async {
    fileData = await initFile();

    if (await fileData.exists()) {
      Map<String, dynamic> data = json.decode(await fileData.readAsString());
      String theme = data['theme'];

      themeData = theme == 'lightMode' ? lightMode : darkMode;
    } else {
      Map<String, dynamic> donnees = {'theme': 'lightMode'};
      await fileData.writeAsString(json.encode(donnees));
    }
  }

  void saveSettings(int index) async {
    fileData = await initFile();

    if (await fileData.exists()) {
      Map<String, dynamic> donnees = {
        'theme': index == 0 ? 'lightMode' : 'darkMode',
      };
      await fileData.writeAsString(json.encode(donnees));
    }
  }

  void toggleTheme(int index) async {
    saveSettings(index);

    themeData = index == 0 ? lightMode : darkMode;
  }
}
