import 'package:DemoMenu/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddRdv extends StatefulWidget {
  @override
  _AddRdvState createState() => _AddRdvState();
}

class _AddRdvState extends State<AddRdv> {
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _value = "Type";

  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Ajouter un rendez-vous',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Titre du rendez-vous',
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
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
                  FocusScope.of(context).requestFocus(new FocusNode());
                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  _dateController.text = DateFormat("dd/MM/yyyy").format(date);
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton(
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("Type de RDV"),
                      value: "Type",
                    ),
                    DropdownMenuItem(
                      child: Text("Présentation"),
                      value: "Présentation",
                    ),
                    DropdownMenuItem(
                      child: Text("Formation"),
                      value: "Formation",
                    ),
                    DropdownMenuItem(
                      child: Text("Autre"),
                      value: "Autre",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        appendRdv(
                            firestoreInstance,
                            FirebaseAuth.instance.currentUser,
                            _value,
                            _descriptionController.text,
                            _titleController.text,
                            DateFormat("dd/MM/yyyy")
                                .parse(_dateController.text));
                      });
                      clearFields(_descriptionController, _titleController,
                          _dateController);
                      //Show snackbar at bottom when appointments is added
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Rendez-vous ajouté"),
                      ));
                    }
                  },
                  child: Text('Valider'))
            ])),
      ),
    );
  }

  //Clear fiels from appointments form
  void clearFields(
      TextEditingController descriptionController,
      TextEditingController titleController,
      TextEditingController dateController) {
    descriptionController.clear();
    titleController.clear();
    dateController.clear();
    _value = "Type";
  }
}
