import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void appendRdv(FirebaseFirestore firestoreInstance, User firebaseUser,
    String type, String description, String title, DateTime date) {
  firestoreInstance
      .collection("rdvs")
      .doc(firebaseUser.uid)
      .collection("rdvList")
      .add({
    "type": type,
    "title": title,
    "description": description,
    "date": date
  }).then((value) {
    firestoreInstance
        .collection("rdvs")
        .doc(firebaseUser.uid)
        .collection("rdvList")
        .doc(value.id)
        .update({'id': value.id});
  });
}

void deleteRdv(
    FirebaseFirestore firestoreInstance, User firebaseUser, String id) {
  firestoreInstance
      .collection("rdvs")
      .doc(firebaseUser.uid)
      .collection("rdvList")
      .doc(id)
      .delete();
}

void addLocation(FirebaseFirestore firestoreInstance, User firebaseUser,
    String appointmentId, double latitude, double longitude) {
  firestoreInstance
      .collection("rdvs")
      .doc(firebaseUser.uid)
      .collection("rdvList")
      .doc(appointmentId)
      .update({
    'location': {'latitude': latitude, 'longitude': longitude}
  });
}
