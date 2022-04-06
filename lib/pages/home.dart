
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, import_of_legacy_library_into_null_safe, deprecated_member_use, unused_import, unused_element, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersend/models/user.dart';
import 'package:fluttersend/pages/pages.dart';
import 'package:fluttersend/pages/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();
firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection("users");
final postsRef = FirebaseFirestore.instance.collection("posts");
final timestamp = DateTime.now();
var currentUser;


class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;
  // google listener
  
  @override
  // a function that runs each time a state is changes
  void initState(){
    super.initState();
    pageController = PageController(

    );
    // detects when a user signs in....listens for a change in user and performs a function
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (error){
      print('error when signin in $error');
    }
    );

    // reauthenticate user when app reopens
    googleSignIn.signInSilently(suppressErrors: false).
    then((account){
      handleSignIn(account);
    }).catchError((error){
      print(error);
    });
  }

@override
// ignore: must_call_super
void dispose(){
  pageController.dispose();
  super.dispose();
}

handleSignIn( account)async{
  print("handle sign in method called");
    if (account!= null){
      print("account doesnt exist in db..calling cyifs");
        // print('user signed in: $account');
        await createUserInFirestore();
        setState(() {
          isAuth = true;
        });
      }
    else{
        print('user not signed In: $account');
        setState(() {
          isAuth = false;
        });
      }

  }

  
createUserInFirestore() async{
  final GoogleSignInAccount? user = googleSignIn.currentUser;
  DocumentSnapshot doc =  await usersRef.doc(user!.id).get();                       
  if(!doc.exists){
    print("this user does nt exist in db");
    final username = await Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccount()));
    print('my username value gotten back: ');
    print(username);
    usersRef.doc(user.id).set(
      {
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      }
    );

  doc = await usersRef.doc(user.id).get();
  }
  currentUser = User.fromDocument(doc);
  print(currentUser);
  print(currentUser.username);
}  
  // a function that handles changing the value of the page index---triggers when a bottom page is changed
  
  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex =  pageIndex;
    });
  }

  onTap(int pageIndex){
    pageController.animateToPage(
      pageIndex, 
      duration: Duration(milliseconds: 300), 
      curve: Curves.easeInOut);
  }

  login(){
    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }

  buildAuthScreen() {
    return Scaffold(
      body: PageView(
        
        children: <Widget>[
          // Timeline(),
          RaisedButton(onPressed: logout,
          child: Text('Log out')),
          ActivityFeed(),
          Upload(currentUser:currentUser),
          Search(),
          Profile(profileId: currentUser!.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        
        // physics: NeverScrollableScrollPhysics(),

      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon( Icons.whatshot_sharp)),
          BottomNavigationBarItem(icon: Icon( Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon( Icons.photo_camera, size: 35,)),
          BottomNavigationBarItem(icon: Icon( Icons.search)),
          BottomNavigationBarItem(icon: Icon( Icons.account_circle))
          ],

      ),
    ); 
    // RaisedButton(onPressed: logout,
    // child: Text('Log out'),);
  }

  Scaffold buildUnAuthScreen() { 
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight, end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor,]
            )
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Flutter Chats', style: 
          TextStyle(fontFamily: "Signatra", fontSize: 70, color: Colors.white),
          ),
          GestureDetector(
            // behavior: HitTestBehavior.translucent,
            onTap: () => login(),
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/google_signin_button.png'),
                  fit: BoxFit.cover 
                  )
              ),
            ),
          )
        ],
      ),
    ),
  );
  }
  @override
  Widget build(BuildContext context) {
    return isAuth? buildAuthScreen() : buildUnAuthScreen() ;
  }
}



