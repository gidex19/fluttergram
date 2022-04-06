// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables, must_be_immutable, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttersend/models/user.dart';
import 'package:fluttersend/pages/home.dart';
import 'package:fluttersend/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  var searchResultsFuture;
  handleSearch(String query){
   Future<QuerySnapshot>? users =  usersRef.where("username", isGreaterThanOrEqualTo : query).get();
   
   setState(() {
     
   searchResultsFuture = users;
   });
  }
  buildSearchResults(){
    print("------------------------");
    print(searchResultsFuture);
    return FutureBuilder( 
      future: searchResultsFuture,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        // int dataLength = snapshot.data!.docs.length;
        print("calculated the datalength");
        
        
        if(!snapshot.hasData){
          circularProgress();
        }
        if (snapshot.connectionState == ConnectionState.waiting){
            return linearProgress();
          }
        
        List<UserResult> searchResultsList = [];
        snapshot.data!.docs.forEach((snapshotItem) {
          User user = User.fromDocument(snapshotItem);
          UserResult searchResult = UserResult(user);
          searchResultsList.add(searchResult);
         });
         return Container(
           decoration: BoxDecoration(
            //  color: Colors.grey.withOpacity(0.2),
             gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor,]
            )
           ),
           child: ListView(
             children: searchResultsList,
           ),
         );  

      });
  }
  clearSearch(){
    // print("22222222222222222222222222222222222222222");
    // print(searchController.value.text);
    searchController.clear();
  }


  AppBar buildSearchHeader(){
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: "Search User",
          filled: true,
          prefixIcon: Icon(
            Icons.account_circle,
            color: Theme.of(context).primaryColor,
            size: 30,
        ),
        suffixIcon: IconButton(onPressed: clearSearch, icon: Icon(Icons.clear, size: 26, ),
    )
        ),
        onFieldSubmitted: handleSearch,
      )
    );
  }

  buildNoContent(){
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor,]
            )
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
  
            SvgPicture.asset('assets/images/searchnew.svg', 
            height: orientation == Orientation.portrait? 300: 170),
            
            SizedBox(height: orientation == Orientation.portrait? 20: 0 ,),
            Center(
              child: Text("Search Users", style: TextStyle(
                fontFamily: "Signatra",
                fontWeight: FontWeight.bold,
                fontSize: orientation == Orientation.portrait? 40: 28 ,
                color: Colors.white

              ),),
            )
          ]
        )
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSearchHeader(),
      body: searchResultsFuture ==null?buildNoContent(): buildSearchResults(), 
    );
  }
}

class UserResult extends StatelessWidget {
  var user;
  UserResult(this.user);


  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor.withOpacity(0.7),
      color: Colors.blueGrey.withOpacity(0.6),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap:() => {},
            child: ListTile(
              
              leading: Container(
                height: 50,
                width: 50,
                
                child: CircleAvatar(
                  
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  backgroundImage:  CachedNetworkImageProvider(user.photoUrl),
                  foregroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
              ),
              title: Text(user.displayName, style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
                ),
              subtitle: Text(user.username, style: TextStyle(
                color: Colors.white
              ),
              ) 

            ),
            
            ),
            Divider(
              height: 3.0,
              color: Colors.white54,
            )
          
        ],
      ),
    );
  }
}