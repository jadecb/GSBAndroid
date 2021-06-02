import 'package:DemoMenu/src/model/appointment.dart';
import 'package:DemoMenu/src/screens/mainapp.dart';
import 'package:DemoMenu/src/screens/updateappointment.dart';
import 'package:DemoMenu/src/services/colors_service.dart';
import 'package:DemoMenu/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ShowAppointment extends StatefulWidget {
  final Appointment rdv;

  ShowAppointment({Key key, @required this.rdv}) : super(key: key);

  @override
  _ShowAppointmentState createState() => _ShowAppointmentState();
}

class _ShowAppointmentState extends State<ShowAppointment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Position position;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rendez vous',
        theme: ThemeData(accentColor: Colors.blue),
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Rendez vous'),
            leading: GestureDetector(
              //Retour menu on tap
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainApp()),
                );
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
            actions: [
              //Delete button
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () {
                        deleteRdv(FirebaseFirestore.instance,
                            FirebaseAuth.instance.currentUser, widget.rdv.id);
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.delete,
                      ))),
              //Edit button
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateAppointment(
                                    rdv: widget.rdv,
                                  )),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                      ))),
              //Location button
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Localisation"),
                                content: Text(
                                    "Souhaitez-vous localiser ce rendez-vous ?"),
                                actions: [
                                  FlatButton(
                                    child: Text("Oui"),
                                    onPressed: () async {
                                      //Display Snackbar and close the dialogAlert
                                      Navigator.of(context).pop();
                                      final snackBar = SnackBar(
                                          content:
                                              Text('Localisation enregistrée'));
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                      Position currentPosition =
                                          await Geolocator.getCurrentPosition();
                                      setState(() {
                                        addLocation(
                                            FirebaseFirestore.instance,
                                            FirebaseAuth.instance.currentUser,
                                            widget.rdv.id,
                                            currentPosition.latitude,
                                            currentPosition.longitude);
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Non"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Icon(
                        Icons.location_on,
                      )))
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  //Title row
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.label,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.rdv.title,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  //Description row
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  //Title row
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.circle,
                          color: getTypeColor(widget.rdv.type),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.rdv.type,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  //Description row
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.text_snippet),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.rdv.description,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  //Date row
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.date_range),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                            DateFormat("dd/MM/yyyy")
                                .format(widget.rdv.date.toDate()),
                            style: TextStyle(fontSize: 16)),
                      )
                    ],
                  ),
                ),
                //Localisation row
                Container(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                            widget.rdv.location != null
                                ? Icons.check_circle_rounded
                                : Icons.error_rounded,
                            color: widget.rdv.location != null
                                ? Colors.green
                                : Colors.red),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Localisation",
                            style: TextStyle(fontSize: 16)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void getLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }
}
