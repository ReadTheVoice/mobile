class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  
  const UserModel({required this.id, required this.firstName, required this.lastName});

  static UserModel example() {
    return const UserModel(id: "", firstName: "", lastName: "");
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }
}