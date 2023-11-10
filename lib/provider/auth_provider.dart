import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_models.dart';
import '../view/screen/home_page.dart';
import '../widget/snackBar.dart';

class AuthProvider extends ChangeNotifier {

  bool _isSignedWithEmail = false;
  bool _isSignedIn = false;
  bool _isLoading = false;
  String _uid ='';
  UserModel? _userModel;
  UserModel get userModel => _userModel!;


  final  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final  FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  final  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static   GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future signInWithGoogle(BuildContext context) async {
    try{
      final account =  await _googleSignIn.signIn();
      final googleKeyId = await account!.authentication;
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (context) => HomePage()),
              (route) => false
      );
      _isSignedWithEmail = true;
      notifyListeners();
      return account;

    }catch(e){
      print('Error en: $e');
      return null;
    }
  }

  Future<void> storeDataWithGoogle(BuildContext context) async {
    final account = await signInWithGoogle(context);
    if (account != null) {
      File image = File(account.photoUrl.toString().trim());

      UserModel userModel = UserModel(
        name: account.displayName.toString().trim(),
        email: account.email.toString().trim(),
        profilePic: account.photoUrl.toString().trim(),
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
        uid: account.id.toString().trim(),
      );
      _userModel = userModel;
      print(userModel.toMap());

      final SharedPreferences sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool("isSignedInWithEmail", true);
      _isSignedWithEmail = true;
      notifyListeners();
      try {
        _uid = account.id.toString().trim();
        //uploading to db
        await _firebaseFireStore.collection("user").doc(_uid).set(userModel.toMap()).then((value) {
          saveUserDataToSP().then((value) => setSignIn().then((value)
          => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false)));
          _isLoading= false;
          notifyListeners();
        });
      } on FirebaseAuthException catch (e){
        showSnackBar(context, e.message.toString());
        _isLoading= false;
        notifyListeners();
      }
    }
  }

  Future setSignIn () async{
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool("is_signed", true);
    _isSignedIn = true;
    notifyListeners();
  }
  // Future <String> storeFileToStorage(String ref, File file)  async {
  //   UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
  //   TaskSnapshot snapshot =  await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }
  //

  Future saveUserDataToSP() async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    print('SP: ${userModel.toMap()}');
    await sharedPref.setString('user_model', jsonEncode(userModel.toMap()));
  }
}
