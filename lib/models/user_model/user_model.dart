class UserModel {
  String uid;
  String displayName;
  String email;
  String photoUrl;

  bool isAuthDataAvailable() {
    return this.uid != null && this.displayName != null && this.email != null && this.photoUrl != null;
  }

  UserModel({this.email, this.displayName, this.photoUrl, this.uid});
}