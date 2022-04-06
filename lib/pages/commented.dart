

// getUsersAndBuild()async{
//     QuerySnapshot snapshot = await usersRef.get();
//     setState(() {
//       users = snapshot.docs;
//     });

//   }




// // a function for perfoming more complex queries on the cloud firestore database
//   complexQuery() async{
//     QuerySnapshot snapshot =await usersRef.where("username", isEqualTo: "yemi")
//     .where("postsCount", isGreaterThan: 1).get();
//     snapshot.docs.forEach((element) {
//       print("complex query data");
//       print(element.data());
//      });
//     // also can query using orderby:
//     // .orderBy("postsCount", descending: true).get();
//     // to limit the number of items returned we use: .limit(2);
//   }




// getUserById() async{
//     final String iD = "OXrQJI9l5qRJjpauWba4";
//     // "EnjAOIUjR0CifSS44Tpp";
    
//     // OXrQJI9l5qRJjpauWba4
//     final DocumentSnapshot myDocument = await usersRef.doc(iD).get();
//       print("getting id document");
//       print(myDocument.data());
//   }




// Future<void> getData() async {
//     // Get docs from collection reference
//     QuerySnapshot querySnapshot = await usersRef.get();
//     querySnapshot.docs.forEach((doc) {
//       print('printing querysnapshots');
//       print(doc.data());
//       print(doc.id);
//     });
//     // new vwesrion uses id not documentID
//     // new version uses get not getDocuments

//     // Get data from docs and convert map to List
//     // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//     // print("printing data");
//     // print(allData);
// }














// body: StreamBuilder(
//         stream: _usersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot ){
//           if(snapshot.hasError){
//             return Text("Something went wrong");
//           }

//           if (snapshot.connectionState == ConnectionState.waiting){
//             return linearProgress();
//           }
//           // if (snapshot.connectionState == ConnectionState.done){
//           // final List<Text> builtitem =  snapshot.data!.docs.map((item) => Text(item['username'])).toList();
            
//           // return Container(
//           //   child: ListView(
//           //     children: builtitem,
//           //   ),
//           // );
//           // }

//           return Container(
            
//             child: ListView(
//               children: snapshot.data!.docs.map((item) => Text(item['username'])).toList()
//             ),
//           );
//         }







// logout(){
  //   print('signed out');
  //   googleSignIn.signOut();
  // }

  // @override
  // void initState() {
  //   // addUser();
  //   // updateUser();
  //   // updateUserImage();
  //   super.initState();
  // }


  // Future<void> addUser(){
  //   return usersRef.add(
  //     {'username': 'Gandia',
  //      'isAdmin': true,
  //      'postsCount': 2}
  //   ).then((value) => print("user added to database")).catchError((onError)=> print("an error occured"));
  // }



  // Future<void> updateUser(){
  //   return usersRef.doc("OXrQJI9l5qRJjpauWba4").update(
  //     {'username': 'Felixio',
  //      'isAdmin': true,
  //      'postsCount': 2}
  //   ).then((value) => print("User update")).catchError((onError)=> print("an error occured"));
  // }



//   Future<void> updateUserImage() {
//   return rootBundle
//     .load('assets/images/google_signin_button.png')
//     .then((bytes) => bytes.buffer.asUint8List())
//     .then((avatar) {
//       return usersRef
//         .doc('OXrQJI9l5qRJjpauWba4')
//         .update({'info.avatar': Blob(avatar)});
//       })
//     .then((value) => print("User Updated"))
//     .catchError((error) => print("Failed to update user: $error"));
// }
