// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_declarations, unused_local_variable, avoid_unnecessary_containers, unused_element




import 'package:flutter/material.dart';
import 'package:fluttersend/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/header.dart';

// final usersRef = FirebaseFirestore.instance.collection('users');
// final _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    // getUsersAndBuild();
    print("timeline page just loadded");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, name: 'Flutter Chat', removeBackButton: true),
      // body: circularProgress(),
      // body: Container(
      //   child: ListView(
      //     children: users.map((user) => Text(user['username'])).toList(),)
      // )
      body: Text('Timeline Page'),
    );
  }

}
  