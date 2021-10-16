import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/model/users_entity.dart';
import 'package:task/utils/helper_functions.dart';
import 'package:task/utils/preference_utils.dart';

class UserRepository {

  getUserLocal(){
    var prefs = PreferenceUtils.getInstance();
    var userData = prefs.getData(PreferenceUtils.userKey);
    if(userData != null){
      return User().fromJson(jsonDecode(userData));
    }
    return userData;
  }

  Future<User> createUser(XFile image, name) async {
    try{
      var userImage =  await HelperFunctions.saveImage(File(image.path));
      var userId = HelperFunctions.createUniqueUserId();
      var data = {"image":userImage ,"name":name,"id": userId };
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference userRef = db.collection('users').doc("$userId");
      await userRef.set(data);
      var userSnapShot = await userRef.get();
      var userData = userSnapShot.data() as Map<String, dynamic>;
      _saveUserToLocalData(userData);
      return User().fromJson(userData);
    }catch(e){
      print(e);
      rethrow;
    }
  }

  _saveUserToLocalData(userData){
    var prefs = PreferenceUtils.getInstance();
    prefs.saveStringData(PreferenceUtils.userId, userData["id"]);
    prefs.saveStringData(PreferenceUtils.userKey, jsonEncode(userData));
  }

  Future<List<User>> getUsers() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try{
      var usersRef = await db.collection('users').get();
      return usersRef.docs.map<User>((e) => User().fromJson(e.data())).toList();
    }catch(e){
      rethrow;
    }
  }

}
