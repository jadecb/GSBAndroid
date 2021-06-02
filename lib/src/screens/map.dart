import 'package:DemoMenu/src/model/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  List<Marker> _markers = <Marker>[];
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  List<Appointment> listAppointment = [];
  String errorMessage;

  @override
  void initState() {
    super.initState();
    getRdvStream();
  }

  @override
  Widget build(BuildContext context) {
    listAppointment.forEach((element) {
      if (element.location != null) {
        _markers.add(Marker(
            markerId: MarkerId(element.title),
            position: LatLng(
                element.location['latitude'], element.location['longitude']),
            infoWindow: InfoWindow(title: element.title)));
      }
    });
    return Container(
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(45.6755767, 4.7827183), zoom: 6),
        zoomGesturesEnabled: true,
        markers: Set<Marker>.of(_markers),
      ),
    );
  }

  void getRdvStream() {
    firestoreInstance
        .collection("rdvs")
        .doc(firebaseAuth.currentUser.uid)
        .collection("rdvList")
        .snapshots()
        .listen((event) {
      if (event != null) {
        setState(() {
          listAppointment =
              event.docs.map((e) => Appointment.fromFirestore(e)).toList();
        });
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }
}
