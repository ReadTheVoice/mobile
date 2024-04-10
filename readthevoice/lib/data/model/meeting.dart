import 'package:easy_localization/easy_localization.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/data/constants.dart';

// flutter packages pub run build_runner build
// dart run build_runner build
enum MeetingStatus {
  createdNotStarted,
  started,
  ended;

  String get title {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return tr("meeting_status_created"); // Has not yet started
      case MeetingStatus.started:
        return tr("meeting_status_started");
      case MeetingStatus.ended:
        return tr("meeting_status_ended");
      default:
        return "None";
    }
  }

  Color get backgroundColor {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return Colors.grey; // Has not yet started
      case MeetingStatus.started:
        return Colors.green;
      case MeetingStatus.ended:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (this) {
      case MeetingStatus.createdNotStarted:
        return Colors.black; // Has not yet started
      case MeetingStatus.started:
        return Colors.white;
      case MeetingStatus.ended:
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}

@Entity(tableName: MEETING_TABLE_NAME)
class Meeting {
  @PrimaryKey()
  final String id;

  final int creationDateAtMillis;
  final String title;
  final String userId;
  final String? userName;

  bool? autoDeletion;
  int? autoDeletionDateAtMillis;
  int? scheduledDateAtMillis;
  int? endDateAtMillis;

  MeetingStatus status;
  String description;
  String transcription;
  bool isTranscriptAccessibleAfter;
  bool favorite;
  bool archived;

  Meeting(
      {required this.id,
      required this.title,
      required this.creationDateAtMillis,
      required this.userId,
      this.autoDeletionDateAtMillis,
      this.scheduledDateAtMillis,
      this.endDateAtMillis,
      this.transcription = "",
      this.description = "",
      this.userName,
      this.status = MeetingStatus.createdNotStarted,
      this.autoDeletion = false,
      this.isTranscriptAccessibleAfter = true,
      this.favorite = false,
      this.archived = false});

  static Meeting example(String id) {
    return Meeting(
        id: id,
        title: "Title of $id",
        creationDateAtMillis: DateTime.now().millisecondsSinceEpoch,
        userId: "",
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut fringilla dolor. Integer dignissim id ipsum id rutrum. Fusce facilisis arcu aliquam gravida pretium. In vulputate, mauris non rhoncus laoreet, orci dolor venenatis nulla, vitae dignissim metus diam ac turpis. Vivamus ut odio vitae arcu lacinia sagittis eget in sapien. Fusce quis accumsan magna. Proin consectetur gravida sapien vel malesuada. Phasellus vel luctus arcu. Quisque consequat placerat nisl non tincidunt. Integer dui massa, venenatis et molestie eget, porttitor eget ligula. Sed ac pulvinar elit. \nCurabitur dictum tortor non neque sagittis placerat. Integer dolor augue, faucibus vel mi ac, ultricies malesuada risus. Donec ut vulputate nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mollis dui nec porta euismod. Sed consectetur ac enim in imperdiet. Mauris leo tellus, dictum sit amet turpis ut, ultrices consectetur sapien. Fusce rhoncus, ex a vehicula elementum, lorem turpis sollicitudin dui, ut suscipit sem nisi in mi. Vivamus finibus ornare lorem a tristique. Mauris a euismod nisl. Maecenas sodales consectetur sapien, ac malesuada dolor cursus et. In lobortis nisl eu consequat porttitor. Aenean id nibh ornare, mollis erat eget, cursus quam. In hac habitasse platea dictumst. Phasellus consectetur orci at aliquet consequat. \nNam turpis tortor, finibus et interdum sed, semper a nulla. Nulla faucibus, turpis a consectetur ultrices, arcu ante dignissim ante, nec ultrices massa lacus et justo. Nulla rhoncus arcu vel tellus tristique, in placerat est lobortis. Donec quam velit, finibus ac faucibus eu, facilisis quis purus. Suspendisse laoreet aliquam risus, sed viverra orci. Vestibulum eget velit in tortor semper pellentesque et non est. Nam in mollis sem, iaculis scelerisque ipsum. Nunc dictum nulla ut felis gravida, non dictum elit aliquet. Phasellus sodales lacus nunc, vel tincidunt dui commodo vel. Morbi nec quam faucibus, pulvinar turpis nec, maximus metus. Nunc pulvinar nisi non nunc pulvinar elementum.",
        transcription:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut fringilla dolor. Integer dignissim id ipsum id rutrum. Fusce facilisis arcu aliquam gravida pretium. In vulputate, mauris non rhoncus laoreet, orci dolor venenatis nulla, vitae dignissim metus diam ac turpis. Vivamus ut odio vitae arcu lacinia sagittis eget in sapien. Fusce quis accumsan magna. Proin consectetur gravida sapien vel malesuada. Phasellus vel luctus arcu. Quisque consequat placerat nisl non tincidunt. Integer dui massa, venenatis et molestie eget, porttitor eget ligula. Sed ac pulvinar elit. \nCurabitur dictum tortor non neque sagittis placerat. Integer dolor augue, faucibus vel mi ac, ultricies malesuada risus. Donec ut vulputate nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mollis dui nec porta euismod. Sed consectetur ac enim in imperdiet. Mauris leo tellus, dictum sit amet turpis ut, ultrices consectetur sapien. Fusce rhoncus, ex a vehicula elementum, lorem turpis sollicitudin dui, ut suscipit sem nisi in mi. Vivamus finibus ornare lorem a tristique. Mauris a euismod nisl. Maecenas sodales consectetur sapien, ac malesuada dolor cursus et. In lobortis nisl eu consequat porttitor. Aenean id nibh ornare, mollis erat eget, cursus quam. In hac habitasse platea dictumst. Phasellus consectetur orci at aliquet consequat. \nNam turpis tortor, finibus et interdum sed, semper a nulla. Nulla faucibus, turpis a consectetur ultrices, arcu ante dignissim ante, nec ultrices massa lacus et justo. Nulla rhoncus arcu vel tellus tristique, in placerat est lobortis. Donec quam velit, finibus ac faucibus eu, facilisis quis purus. Suspendisse laoreet aliquam risus, sed viverra orci. Vestibulum eget velit in tortor semper pellentesque et non est. Nam in mollis sem, iaculis scelerisque ipsum. Nunc dictum nulla ut felis gravida, non dictum elit aliquet. Phasellus sodales lacus nunc, vel tincidunt dui commodo vel. Morbi nec quam faucibus, pulvinar turpis nec, maximus metus. Nunc pulvinar nisi non nunc pulvinar elementum."
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut fringilla dolor. Integer dignissim id ipsum id rutrum. Fusce facilisis arcu aliquam gravida pretium. In vulputate, mauris non rhoncus laoreet, orci dolor venenatis nulla, vitae dignissim metus diam ac turpis. Vivamus ut odio vitae arcu lacinia sagittis eget in sapien. Fusce quis accumsan magna. Proin consectetur gravida sapien vel malesuada. Phasellus vel luctus arcu. Quisque consequat placerat nisl non tincidunt. Integer dui massa, venenatis et molestie eget, porttitor eget ligula. Sed ac pulvinar elit. \nCurabitur dictum tortor non neque sagittis placerat. Integer dolor augue, faucibus vel mi ac, ultricies malesuada risus. Donec ut vulputate nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mollis dui nec porta euismod. Sed consectetur ac enim in imperdiet. Mauris leo tellus, dictum sit amet turpis ut, ultrices consectetur sapien. Fusce rhoncus, ex a vehicula elementum, lorem turpis sollicitudin dui, ut suscipit sem nisi in mi. Vivamus finibus ornare lorem a tristique. Mauris a euismod nisl. Maecenas sodales consectetur sapien, ac malesuada dolor cursus et. In lobortis nisl eu consequat porttitor. Aenean id nibh ornare, mollis erat eget, cursus quam. In hac habitasse platea dictumst. Phasellus consectetur orci at aliquet consequat. \nNam turpis tortor, finibus et interdum sed, semper a nulla. Nulla faucibus, turpis a consectetur ultrices, arcu ante dignissim ante, nec ultrices massa lacus et justo. Nulla rhoncus arcu vel tellus tristique, in placerat est lobortis. Donec quam velit, finibus ac faucibus eu, facilisis quis purus. Suspendisse laoreet aliquam risus, sed viverra orci. Vestibulum eget velit in tortor semper pellentesque et non est. Nam in mollis sem, iaculis scelerisque ipsum. Nunc dictum nulla ut felis gravida, non dictum elit aliquet. Phasellus sodales lacus nunc, vel tincidunt dui commodo vel. Morbi nec quam faucibus, pulvinar turpis nec, maximus metus. Nunc pulvinar nisi non nunc pulvinar elementum.",
        status: MeetingStatus.ended);
  }
}
