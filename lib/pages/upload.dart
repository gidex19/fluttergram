// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use, duplicate_ignore, prefer_const_literals_to_create_immutables, invalid_use_of_visible_for_testing_member, unused_import, prefer_typing_uninitialized_variables, must_be_immutable, prefer_const_constructors_in_immutables, avoid_print, sized_box_for_whitespace, unused_local_variable, library_prefixes, avoid_single_cascade_in_expression_statements



import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttersend/pages/home.dart';
import 'package:fluttersend/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Ima ;
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/user.dart';

class Upload extends StatefulWidget {
  
  final User? currentUser;
  Upload({this.currentUser});
  // Upload({
  //   // this.currentUser = currentUser;
  //   });
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController locationController  = TextEditingController();
  TextEditingController captionController  = TextEditingController();
  bool isUploading = false;
  String? mediaUrl;
  File? file;
  String postId = Uuid().v4();

  handleTakePhoto()async {
    Navigator.pop(context);
    PickedFile? pickedfile = await ImagePicker.platform.pickImage(source: ImageSource.camera, maxHeight: 680, maxWidth: 900);
    setState(() {
      file = File(pickedfile!.path);
    });
  }

  handleGalleryPicker()async{
    Navigator.pop(context);
    PickedFile? pickedfile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(pickedfile!.path);
    });
  }

  
  selectImage(parentContext){
    return showDialog(context: parentContext, 
      builder: (context){
        return SimpleDialog(
          title: Text("Create Post", style: TextStyle(color: Theme.of(context).primaryColor),),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          children: <Widget>[
            Divider(height: 3.0, indent: 20, endIndent: 20, thickness: 0.5, color: Theme.of(context).primaryColor,),
            SimpleDialogOption(
              child: Text("Photo With Camera",),
              onPressed: handleTakePhoto,

            ),
            SimpleDialogOption(
              child: Text("Photo With Gallery",),
              onPressed: handleGalleryPicker,

            ),
            SimpleDialogOption(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: ()=>{Navigator.pop(context)},

            ),
          ],
        );
      });
  }

  Container buildSplashScreen(){
    return Container(
      
      // color: Theme.of(context).acc,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: <Widget>[
          SvgPicture.asset('assets/images/upload.svg', height: 250,),
          Padding(padding: EdgeInsets.only(top: 20),
          // ignore: deprecated_member_use
          child: RaisedButton(
            onPressed: ()=>selectImage(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            color: Theme.of(context).accentColor,
            child: Text("Upload Post", style: TextStyle(
              fontSize: 14,
              color: Colors.white
            )),

             )),
        ]
      )
    );
  }

  clearImage(){
    setState(() {
      file = null;
    });
  }

  compressImage()async{
    print("compressing image running")
    final tempDir = await getTemporaryDirectory(); 
    final path = tempDir.path;
    Ima.Image? imageFile = Ima.decodeImage(file!.readAsBytesSync());
    final compressedImage =  File('$path/image_$postId.jpg')..writeAsBytesSync(Ima.encodeJpg(imageFile!, quality: 80));
    setState(() {
      file = compressedImage;
    });

    print("file: ${file}");
   }

  Future<String?> uploadImage(File? file) async{
    print("running the UPLOADIMAGE function");
    firebase_storage.UploadTask uploadTask =  storageRef.child("post_$postId.jpg").putFile(file!);
    
    firebase_storage.TaskSnapshot storageSnap =  await uploadTask.whenComplete(() async{
    print("rinning upload when complete bracket");
    print(uploadTask.snapshot);
    mediaUrl  =  await uploadTask.snapshot.ref.getDownloadURL();
    print('---------------------------------------');
    print("mediaUrl: $mediaUrl");
    });

    print("check value: $mediaUrl");
    print("upload function ended");
    return mediaUrl;
      
  }  

  createPostInFirestore({required String? mediaUrl, required String? location, required String? description}){
    postsRef.doc(widget.currentUser!.id).collection("usersPosts").doc(postId).set(
      {
        "postId": postId,
        "ownerId": widget.currentUser!.id,
        "username": widget.currentUser!.username,
        "mediaUrl": mediaUrl,
        "description": description,
        "location": location,
        "timestamp": timestamp,
        "likes": {},

      }
    );
  }

  handleSubmit() async{
    print("handlesubmit action called");
    setState(() {
      isUploading = true;

    });
    await compressImage();
    mediaUrl =  await uploadImage(file);
    createPostInFirestore(mediaUrl: mediaUrl, location: locationController.text, description: captionController.text);
    captionController.clear();
    locationController.clear();
    setState(() {
    postId = Uuid().v4();
    file = null;  
    isUploading = false;      
    });
  }

  getUserLocation()async{
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    
    Position position =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedAddress =  "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress; 

  }

  buildUploadForm(){
    // final ffile = File(file.path);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        leading: IconButton(onPressed: clearImage,
         icon: Icon(Icons.arrow_back, color: Colors.black,)),
        title: Text("Caption Post", style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: <Widget>[
          Center(
            child: RaisedButton(onPressed: isUploading? null: handleSubmit,
            // margin: EdgeInsets.only(right: 10),
              color: isUploading? Colors.grey: Theme.of(context).primaryColor,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
             child: Text("Post", style: TextStyle(color: Colors.white, fontSize: 16))),
          ),
          SizedBox(width: 10,)
        ],
        
      ),
      body: ListView(
        children: <Widget>[
          isUploading ?linearProgress(): Text(""),
          Container(
            // color: Colors.black,
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    
                    // color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file!))
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.currentUser!.photoUrl),
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  
                  hintText: "What's your caption?... ",
                  // border: InputBorder.none,

                ),
              ),
            ),
            
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.pin_drop, size: 35, color: Theme.of(context).accentColor,),
            title: Container(
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Enter Location..."
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 200,
            height: 80,
             child: Center(
               child: RaisedButton.icon(onPressed: getUserLocation,
               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24 ),
              //  color: Colors.grey,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
               icon: Icon(Icons.my_location),
                label: Text("Use Current Location")),
             )
          )
        ], 
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null?buildSplashScreen(): buildUploadForm(); 
    
  }
}
