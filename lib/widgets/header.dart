// ignore_for_file: unused_import, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';

AppBar header(context, {required String name, bool removeBackButton=false}){
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false: true,
    title: Text(
      name,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Signatra",
        fontSize: 30.0
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}