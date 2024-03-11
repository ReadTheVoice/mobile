
class Transcript {
  String id;
  String data = "";
  String meetingId;
  String userId;
  DateTime lastUpdatedDate = DateTime.now();

  Transcript({required this.id, required this.meetingId, required userId });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transcript && other.meetingId == meetingId && other.userId == userId;
  }

  @override
  int get hashCode => data.hashCode * meetingId.hashCode * userId.hashCode * lastUpdatedDate.hashCode;

  @override
  String toString() {
    return "Transcript { id: $id, meetingId: $meetingId, userId: $userId, data: $data, lastUpdatedDate: $lastUpdatedDate }";
  }
}