// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_field, avoid_print, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttersend/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? username;
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  submit(){
    final form = _formkey.currentState;
    if (form!.validate()){
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome $username!!!"));
      _scaffoldKey.currentState!.showSnackBar(snackbar); 
      print(username);
      Timer(
        Duration(seconds: 2), (){
        Navigator.pop(context, username);

        });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, name: "Create Username", removeBackButton: true),
      body: Container(
        child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
          child: Container(
            child: Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
              validator: (formValue){
                if(formValue!.trim().length <=3 || formValue.isEmpty ){
                  return "Too short, minimum of 4 characters";
                }
                else if (formValue.trim().length > 12){
                  return "Too long, maximum of 12 characters";
                }
                else{
                  return null;
                }
              },  
              onSaved: (formValue) => username = formValue!,
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                
                labelText: "Username",
                labelStyle: TextStyle(
                  fontSize: 15
                ),
                hintText: 'Enter at least five characters',
                hintStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                
              ),
            )),
          ),
          ),
          GestureDetector(
            onTap: submit,
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Center(
                child: Text('Submit', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ),
            ),
          )
        ],
        ),
      ),
    );
  }
}
