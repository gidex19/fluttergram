// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, must_be_immutable, prefer_const_literals_to_create_immutables, unused_import, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttersend/models/user.dart';
import 'package:fluttersend/pages/edit_profile.dart';
import 'package:fluttersend/pages/home.dart';
import 'package:fluttersend/widgets/header.dart';
import 'package:fluttersend/widgets/post.dart';
import 'package:fluttersend/widgets/progress.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final googleSignIn =  GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
class Profile extends StatefulWidget {
  String? profileId;
  
  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

final String currentUserId = currentUser!.id;
bool isLoading = false;
int postCount = 0;
List<Post> posts = [];

@override
void initState(){
  super.initState();
  getProfilePosts();

}
  getProfilePosts() async{
    print("getting posts");
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await  postsRef.doc(widget.profileId).collection('usersPosts').orderBy('timestamp', descending: true).get();
    
    // postCount = snapshot.docs.length;
    // print("POSTCOUNT :$postCount");
    // posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    // print("LIST");
    // print(posts.first.postId);
    // print(posts.first.ownerId);
    // print(posts.first.username);
    // print(posts.first.location);
    // print(posts.first.description);
    // print(posts.first.mediaUrl);
    // print(posts.first.likes);
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();

    });
  }

Column buildCountColumn(String label, int count){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(count.toString(), style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black
      ),
      ),
      SizedBox(height: 7,),
    Text(label, style: TextStyle(
      fontSize: 16, color: Colors.black87
    ),)
    ],
  );
}

editProfile(){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(
    currentUserId: currentUserId )));
}

Container buildButton({required String label,  required function}){
  return Container(
    
    padding: EdgeInsets.only(top: 2),
    child: TextButton(onPressed:  function,
     child: Container(
       width: MediaQuery.of(context).size.width* 0.5,
       height: 30,
       alignment: Alignment.center,
       child: Text(label, style: TextStyle(color: Colors.white),),
       decoration: BoxDecoration(
         color: Theme.of(context).primaryColor,
         border: Border.all(
           color: Theme.of(context).primaryColor.withOpacity(0.3) 
         ),
         borderRadius: BorderRadius.circular(5)
       ),
     )),
  );
}

buildProfileButton(){
  bool isProfileOwner = currentUserId == widget.profileId;
  if(isProfileOwner){
    return buildButton(label: "Edit Profile", function: editProfile);
  }
  // return Center(
  //   child: ElevatedButton(
  //     style: ButtonStyle(

  //     ),
  //     onPressed: ()=>{},
  //     child: Text("Follow User"),),
  // );
}

buildProfileHeader(){
  
  return FutureBuilder (
    future: usersRef.doc(widget.profileId).get(),
    builder: (context, AsyncSnapshot snapshot){
      if(!snapshot.hasData){
        return circularProgress();
      }
      // snapshot.data.DocumentSnapshot();
      
      User user = User.fromDocument(snapshot.data);
      return Padding(padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider( user.photoUrl),
                  ),
                  Expanded(
                    
                    flex: 1,
                    child: Column(
                      
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("posts", 10),
                            buildCountColumn("followers", 8),
                            buildCountColumn("following", 6),
                          ],
                        ),
                        // SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildProfileButton(),
                          ],
                        )
                      ],
                    ))
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12),
                child: Text(user.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,

                ),),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4),
                child: Text(user.displayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontSize: 16,
                  
                ),),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 3),
                child: Text(user.bio),
              )
            ],
          ) ,
      );
      
    },
    
    );
}
buildProfilePosts(){
  if(isLoading){
    return circularProgress();
  }
  return Column(
    children: <Widget>[]
    // children: <Widget>[Center(child: Text("hello", style: TextStyle(fontSize: 20),),)],
    );
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: header(context, name: 'Profile'),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(height: 0,),
          buildProfilePosts(),
          
        ],
      )
      );
  }
}
