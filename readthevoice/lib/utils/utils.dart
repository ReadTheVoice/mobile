enum AppThemeMode { light, dark }

enum AvailableScreens { main, home, favoriteMeetings, archivedMeetings, settings, aboutUs, meeting, transcriptionStream }

int fromDateTimeToMillis(DateTime date) => date.millisecondsSinceEpoch;
DateTime fromMillisToDateTime(int millis) => DateTime.fromMillisecondsSinceEpoch(millis);

