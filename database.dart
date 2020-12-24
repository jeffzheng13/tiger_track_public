import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(
      // ignore: non_constant_identifier_names
      String Bus, String displayName, String email, String uid) async {
    return await userCollection.document(uid).setData({
      'Bus': Bus,
      'displayName': displayName,
    });
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
