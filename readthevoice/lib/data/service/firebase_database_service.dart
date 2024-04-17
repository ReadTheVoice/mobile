import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:readthevoice/data/constants.dart';
import 'package:readthevoice/data/firebase_model/meeting_model.dart';
import 'package:readthevoice/data/firebase_model/user_model.dart';

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

  Future<UserModel?> getMeetingCreator(String userId) async {
    var docSnapshot = await userCollectionReference.doc(userId).get();

    if (docSnapshot.exists) {
      final dynamic data = docSnapshot.data();

      if (data != null) {
        return UserModel(
            id: userId,
            firstName: "${data["firstName"]}",
            lastName: "${data["lastName"]}");
      }
    }

    return null;
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
