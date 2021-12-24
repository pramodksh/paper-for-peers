class AdminModel {
  final String adminId;
  final String displayName;
  final String email;
  final String photoUrl;
  final List<String> fcmTokenList;

  const AdminModel({
    required this.adminId,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.fcmTokenList,
  });

  static String fcmTokenListLabel = "fcm_token_list";

  factory AdminModel.getAdminByFirestoreMap({
    required Map<String, dynamic> map,
    required String adminId,
  }) {
    return AdminModel(
      adminId: adminId,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      fcmTokenList: map[fcmTokenListLabel] == null ? [] : List<String>.from(map[fcmTokenListLabel]),
    );
  }
}