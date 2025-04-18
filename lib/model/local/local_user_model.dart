import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
part 'local_user_model.g.dart';

@HiveType(typeId: 0)
class LocalUserModel {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? photoUrl;

  LocalUserModel({this.name, this.email, this.photoUrl});

  factory LocalUserModel.fromFirebaseUser(User? user) {
    return LocalUserModel(
      name: user?.displayName,
      email: user?.email,
      photoUrl: user?.photoURL,
    );
  }
}
