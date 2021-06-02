import 'package:DemoMenu/src/model/appointment.dart';
import 'package:DemoMenu/src/screens/showappointment.dart';
import 'package:DemoMenu/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:DemoMenu/src/services/colors_service.dart';

class Rdv extends StatefulWidget {
  @override
  _RdvState createState() => _RdvState();
}

class _RdvState extends State<Rdv> {
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  List<Appointment> listAppointment = [];
  String errorMessage;
  bool aVenir = false;
  int _radioOrder = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getRdvStream();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                padding: EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).accentColor),
                child: Row(
                  children: [
                    Radio(
                        activeColor: Colors.black,
                        value: 0,
                        groupValue: _radioOrder,
                        onChanged: handleRadioChange),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            handleRadioChange(0);
                          });
                        },
                        child: Text('Tous')),
                  ],
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).accentColor),
                child: Row(
                  children: [
                    Radio(
                        activeColor: Colors.black,
                        value: 1,
                        groupValue: _radioOrder,
                        onChanged: handleRadioChange),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            handleRadioChange(1);
                          });
                        },
                        child: Text('A venir')),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Rendez-vous',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (errorMessage != null) ...[
            SizedBox(
              height: 8,
            ),
            Text(errorMessage ?? 'Erreur')
          ] else if (listAppointment != null) ...[
            ListView.builder(
              itemCount: listAppointment.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  //When tap on card the window changes
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowAppointment(
                                rdv: listAppointment[index],
                              )),
                    );
                    print(listAppointment[index]);
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    //Delete when slided to the left
                    onDismissed: (direction) {
                      if (mounted)
                        setState(() {
                          deleteRdv(firestoreInstance, firebaseAuth.currentUser,
                              listAppointment[index].id);
                          listAppointment.removeAt(index);
                        });
                    },
                    direction: DismissDirection.endToStart,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 100.0,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      topLeft: Radius.circular(5)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://image.freepik.com/free-vector/appointment-booking-with-smartphone-man_23-2148576384.jpg"))),
                            ),
                            Container(
                              height: 100,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      listAppointment[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                      child: Container(
                                        width: 260,
                                        child: Text(
                                          DateFormat("dd/MM/yyyy").format(
                                              listAppointment[index]
                                                  .date
                                                  .toDate()),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 48, 48, 54)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.label,
                                            color: getTypeColor(
                                                listAppointment[index].type),
                                            size: 16.0,
                                          ),
                                          Container(
                                            width: 260,
                                            child: Text(
                                              listAppointment[index].type ??
                                                  "Aucun",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 48, 48, 54)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ] else ...[
            Center(
              child: CircularProgressIndicator(),
            )
          ]
        ]),
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

  void getRdvToComeStream() {
    firestoreInstance
        .collection("rdvs")
        .doc(firebaseAuth.currentUser.uid)
        .collection("rdvList")
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
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

  void handleRadioChange(int value) {
    setState(() {
      _radioOrder = value;
      switch (_radioOrder) {
        case 0:
          getRdvStream();
          break;
        case 1:
          getRdvToComeStream();
          break;
      }
    });
  }
}
