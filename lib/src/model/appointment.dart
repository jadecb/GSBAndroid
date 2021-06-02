import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String title;
  String description;
  Timestamp date;
  String id;
  LinkedHashMap<String, dynamic> location;
  String type;

  Appointment(
      {this.title,
      this.description,
      this.date,
      this.id,
      this.location,
      this.type});

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Appointment(
        title: data["title"] ?? null,
        description: data["description"] ?? null,
        date: data["date"] ?? null,
        id: data["id"] ?? null,
        location: data["location"] ?? null,
        type: data["type"] ?? null);
  }

  Map<String, dynamic> toMap(Appointment appointment) {
    return {
      'title': appointment.title,
      'description': appointment.description,
      'date': appointment.date,
      'id': appointment.id,
      'type': appointment.type,
      'location': appointment.location
    };
  }
}
