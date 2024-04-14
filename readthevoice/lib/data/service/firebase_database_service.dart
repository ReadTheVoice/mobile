import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/firebase_model/user_model.dart';

import '../model/meeting.dart';

class FirebaseDatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseDatabase realtimeDb = FirebaseDatabase.instance;

  late CollectionReference meetingCollectionReference;
  late CollectionReference userCollectionReference;
  late DatabaseReference transcriptDatabaseReference;

  FirebaseDatabaseService() {
    meetingCollectionReference = firestore.collection(MEETING_COLLECTION);
    userCollectionReference = firestore.collection(USER_COLLECTION);
    transcriptDatabaseReference = realtimeDb.ref(TRANSCRIPT_COLLECTION);
  }

  // https://github.com/firebase/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore/example/lib/main.dart
  Future<UserModel?> getMeetingCreator(String userId) async {
    var docSnapshot = await userCollectionReference.doc(userId).get();

    if (docSnapshot.exists) {
      final dynamic data = docSnapshot.data();

      if (data != null) {
        // {lastName: LE HEURT-FINOT, firstName: Gaëtan, email: gaetan.glh@orange.fr}
        return UserModel(
            id: userId,
            firstName: "${data["firstName"]}",
            lastName: "${data["lastName"]}");
      }
    }

    return null;
  }

  // Stream meeting transcription
  Future<Stream<QuerySnapshot>> streamMeetings() async {
    return meetingCollectionReference
        .orderBy("field", descending: true)
        .snapshots();
  }

  Future<MeetingModel?> getMeetingModel(String meetingId) async {
    var docSnapshot = await meetingCollectionReference.doc(meetingId).get();
    if (docSnapshot.exists) {
      final dynamic data = docSnapshot.data();
      if (data != null) {
        Map<String, dynamic> mappedData = data as Map<String, dynamic>;
        return MeetingModel.fromFirebase(meetingId, mappedData);
      }
    }

    return null;
  }

  Future<Meeting?> getMeeting(String meetingId) async {
    return (await getMeetingModel(meetingId))?.toMeeting();

    // var docSnapshot = await meetingCollectionReference.doc(meetingId).get();
    // if (docSnapshot.exists) {
    //   final dynamic data = docSnapshot.data();
    //
    //   if (data != null) {
    //     // {createdAt: Timestamp(seconds=1710342183, nanoseconds=275000000), creator: 0AZouh2I45hyDPNvwXPy81mSDPp2, endDate: null, deletionDate: null, isTranscriptAccessibleAfter: true, name: bonjour, description: Je n'ai pas d'idée, scheduledDate: Timestamp(seconds=1710342060, nanoseconds=0), isFinished: false}
    //
    //     Map<String, dynamic> mappedData = data as Map<String, dynamic>;
    //     MeetingModel fbMeeting = MeetingModel.fromFirebase(meetingId, mappedData);
    //     return fbMeeting.toMeeting();
    //   }
    // }
    //
    // return null;
  }

  // Stream meeting transcription
  Future<Stream<DatabaseEvent>> streamMeetingTranscription(
      String meetingId) async {
    return transcriptDatabaseReference.child(meetingId).onValue;
  }

  // Stream meeting transcription
  Future<String?> getMeetingTranscription(String meetingId) async {
    final transcript =
        await transcriptDatabaseReference.child(meetingId).once();
    if (transcript.snapshot.exists) {
      dynamic data = transcript.snapshot.value;
      return data["data"];
    }

    return null;
  }
}
