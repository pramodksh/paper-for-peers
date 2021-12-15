class AdminModel {
  final String adminId;
  final String displayName;
  final String email;
  final String photoUrl;
  final String fcmToken;

  const AdminModel({
    required this.adminId,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.adminId,
      'displayName': this.displayName,
      'email': this.email,
      'photoUrl': this.photoUrl,
      'fcmToken': this.fcmToken,
    };
  }

  factory AdminModel.getAdminByFirestoreMap({
    required Map<String, dynamic> map,
    required String adminId,
  }) {
    return AdminModel(
      adminId: adminId,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      fcmToken: map['fcm_token'] as String,
    );
  }
}