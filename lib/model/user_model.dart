import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String? uid;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.uid,
  });

  // Factory to create from Firebase User
  factory UserModel.fromFirebaseUser(User? user) {
    return UserModel(
      name: user?.displayName,
      email: user?.email,
      photoUrl: user?.photoURL,
      uid: user?.uid,
    );
  }
}
