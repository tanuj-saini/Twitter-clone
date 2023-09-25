import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter/features/auth/login.dart';

final StorageMethodProvider=Provider((ref) => StorageMethod(storage: FirebaseStorage.instance));
class StorageMethod {
  final FirebaseStorage storage ;

  StorageMethod({required this.storage});

  
  
  Future<String> uploadFile({required String uid,required BuildContext context,

     required String childname , required File? file}) async {
    try{
   final ref=  await storage.ref().child(childname).child(uid);

UploadTask uploadTask=ref.putFile(file!);
final snapShot=await uploadTask;
return await snapShot.ref.getDownloadURL();
    }on FirebaseException catch(e){
     return  showSnackBar(e.message!, context);
    }
}}
