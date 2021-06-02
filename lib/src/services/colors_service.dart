import 'package:flutter/material.dart';

MaterialColor getTypeColor(String type) {
  switch (type) {
    case "Formation":
      return Colors.blue;
    case "Présentation":
      return Colors.yellow;
    case "Autre":
      return Colors.purple;
    default:
      return Colors.teal;
  }
}
