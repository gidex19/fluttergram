
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, no_logic_in_create_state, unnecessary_this, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersend/models/user.dart';
import 'package:fluttersend/pages/home.dart';
import 'package:fluttersend/widgets/progress.dart';

class Post extends StatefulWidget {
  final String? postId;  
  final String? ownerId;  
  final String? username;  
  final String? location;  
  final String? description;  
  final String? mediaUrl;  
  final dynamic likes;  

  Post({
    this.postId,
    this.ownerId, 
    this.username, 
    this.location, 
    this.description, 
    this.mediaUrl, 
    this.likes,
    
  });

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'], 
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],);
  } 

  int getLikeCount(likes){
    if(likes == null){
      return 0;
    }
    int count = 0;
    likes.value.forEach((val){
      if(val ==true){
        count+=1;
      }
    });
    return count;
  }

  @override
  State<Post> createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username, 
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    likeCount: getLikeCount(this.likes)
    
  );
}

class _PostState extends State<Post> {
  final String? postId;  
  final String? ownerId;  
  final String? username;  
  final String? location;  
  final String? description;  
  final String? mediaUrl;  
  Map? likes;
  int? likeCount; 


  _PostState({
    this.postId,
    this.ownerId, 
    this.username, 
    this.location, 
    this.description, 
    this.mediaUrl, 
    this.likes,
    this.likeCount
    
  });
  buildPostHeader(){
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,

          ),
          title: GestureDetector(
            onTap: () {
              
            },
            child: Text(user.username, style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,

            ),
            ),
          ),
          subtitle: Text(location!),
          trailing: IconButton(onPressed: (){}, icon: Icon(Icons.more_vert) ),
        );

      }
      );
  }
  buildPostImage(){
    return GestureDetector(
      onDoubleTap: () {
        
      },
      child: Stack(
        children: <Widget>[
          Image.network(mediaUrl!)
        ],
      ),
    );
  }
  buildPostFooter(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40, left: 20)),
            GestureDetector(
              onTap: (){ },
              child: Icon(
                Icons.favorite_border, size: 28, color: Colors.pink,)),
            Padding(padding: EdgeInsets.only(top: 40, left: 20)),
            GestureDetector(
              onTap: (){ },
              child: Icon(
                Icons.chat, size: 28, color: Colors.blue[900],)
                ),
            // IconButton(onPressed: (){}, icon: Icon(Icons.chat))
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text('$likeCount', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold) ,),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(username!, 
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold) ,),
            ),
            Expanded(child: Text(description!))
          ],
        )
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
      
    );
  }
}
