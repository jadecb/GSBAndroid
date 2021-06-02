import 'package:DemoMenu/src/screens/showappointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:DemoMenu/src/model/appointment.dart';

class UpdateAppointment extends StatefulWidget {
  final Appointment rdv;
  const UpdateAppointment({Key key, @required this.rdv}) : super(key: key);

  @override
  _UpdateAppointmentState createState() => _UpdateAppointmentState();
}

class _UpdateAppointmentState extends State<UpdateAppointment> {
  final firestoreInstance = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(text: widget.rdv.title);
    final _dateController =
        TextEditingController(text: widget.rdv.date.toString());
    final _descriptionController =
        TextEditingController(text: widget.rdv.description);
    return MaterialApp(
        title: 'Rendez-vous',
        theme: ThemeData(accentColor: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Modifier Rendez-vous'),
            leading: GestureDetector(
              //Retour menu on tap
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                                labelText: 'Titre du rendez-vous',
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Pas de titre défini';
                              }
                              return null;
                            }),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Description',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                          maxLines: 5,
                          minLines: 3,
                        ),
                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Date',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                          onTap: () async {
                            DateTime date = DateTime(1900);
                            // Below line stops keyboard from appearing
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            _dateController.text = date.day.toString() +
                                '-' +
                                date.month.toString() +
                                '-' +
                                date.year.toString();
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  var firebaseUser =
                                      FirebaseAuth.instance.currentUser;
                                  firestoreInstance
                                      .collection("rdvs")
                                      .doc(firebaseUser.uid)
                                      .collection("rdvList")
                                      .doc(widget.rdv.id)
                                      .update({
                                    'title': _titleController.text,
                                    'description': _descriptionController.text,
                                    'date': _dateController.text
                                  });
                                  widget.rdv.title = _titleController.text;
                                  //widget.rdv.description =
                                  //    _descriptionController.text;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowAppointment(
                                              rdv: widget.rdv,
                                            )),
                                  );
                                });
                              }
                            },
                            child: Text('Modifier'))
                      ])),
            ),
          ),
        ));
  }
}
