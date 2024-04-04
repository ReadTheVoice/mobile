enum AppThemeMode { light, dark }

enum AvailableScreens {
  main,
  home,
  favoriteMeetings,
  archivedMeetings,
  settings,
  aboutUs,
  meeting,
  transcriptionStream
}

extension DateTimeStringConversion on int {
  String toDateTimeString() {
    // TODO Proceed with correct manipulations
    return DateTime.fromMillisecondsSinceEpoch(this)
        .toString();
  }
}
