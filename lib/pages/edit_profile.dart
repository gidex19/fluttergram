// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, must_be_immutable, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_field, prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersend/models/user.dart';
import 'package:fluttersend/pages/home.dart';
import 'package:fluttersend/widgets/progress.dart';
// import 'package:google_sign_in/google_sign_in.dart';


// final googleSignIn = GoogleSignIn();

class EditProfile extends StatefulWidget {
  String? currentUserId;

  EditProfile({ this.currentUserId });
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  User? user;
  bool isLoading = false;
  bool _bioFormValid = true;
  bool _displayNameFormValid = true;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState(){

    super.initState();
    getUser();
  }

  getUser()async{
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot doc =  await usersRef.doc(widget.currentUserId).get();
    user =  User.fromDocument(doc);
    displayNameController.text = user!.displayName;
    bioController.text = user!.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 12),
        child: Text('Display Name', style: TextStyle(color: Colors.grey,),),),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            errorText: _displayNameFormValid ? null: "display name is too short" ,
            hintText: 'Update Display Name'
          ), 
        )
      ],
    );
  }

  Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 12),
        child: Text('User Bio', style: TextStyle(color: Colors.grey,),),),
        TextField(
          
          maxLines: 3,
          controller: bioController,
          decoration: InputDecoration(
            hintText: 'Update Bio',
            errorText: _bioFormValid? null: "Bio is too long. Maximum of 100 characters",
            // errorStyle: TextStyle()
          )
        )
      ],
    );
  }


updateUserProfile(){
  setState(() {
    displayNameController.text.trim().length < 3 || 
    displayNameController.text.isEmpty ? _displayNameFormValid = false : _displayNameFormValid = true;

        bioController.text.trim().length > 100 ? _bioFormValid = false : _bioFormValid =  true;
  });

  if (_displayNameFormValid && _bioFormValid){
    usersRef.doc(widget.currentUserId).update({
      "displayName": displayNameController.text,
      "bio": bioController.text
    });
    SnackBar snackBar = SnackBar(content: Text("Profile Updated"),);
    _scaffoldkey.currentState!.showSnackBar(snackBar);
  }
}

logout() async{
    // setState(() {
      
    // });
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Home() ));
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        
        title: Text("Edit Profile", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          IconButton(onPressed:()=> Navigator.pop(context),
          icon: Icon(Icons.done, size: 30,  color: Colors.green,) )
        ],
      ),
      body: isLoading? circularProgress(): ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 15, bottom: 8),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(user!.photoUrl),
                ),),
                Padding(padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    buildDisplayNameField(),
                    buildBioField(),

                  ],
                ),),
                RaisedButton(onPressed: updateUserProfile,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  
                ),
                child: Text('Update Profile', style: TextStyle(color: Theme.of(context).primaryColor),),),
                
                RaisedButton(onPressed: logout,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  
                ), color: Colors.red,
                child: Text('      Logout      ', style: TextStyle(color: Colors.white),),),
                // Center(
                //   child: IconButton(onPressed: ()=>{}, icon: Icon(Icons.logout)),
                // ),
                // FlatButton.icon(onPressed: ()=>{},  , icon: Icon(Icons.logout, color: Colors.white,),
                //  label: Text('Logout', style: TextStyle(color: Colors.white),), color: Colors.red,)

            ],)
          )
        ]
      ) ,
    );
  }
}
