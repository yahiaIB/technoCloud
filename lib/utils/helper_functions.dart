import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:task/app/constants.dart';
import 'package:task/utils/preference_utils.dart';
import 'dart:io' as io;
import 'package:uuid/uuid.dart';

class HelperFunctions {

  static Future<String> saveImage(File file) async {
    await Firebase.initializeApp();
    firebase_storage.UploadTask uploadTask;
    String fileName = file.path.split("/").last;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref("images/$fileName");

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});

    uploadTask = ref.putFile(io.File(file.path), metadata);
    firebase_storage.UploadTask task= await Future.value(uploadTask);
    return  Constants.firebaseStorageUrl(task.snapshot.ref.name);
  }

  static createUniqueUserId(){
    var uuid = Uuid();
    return uuid.v1();
  }

  static getUserId(){
    var prefs = PreferenceUtils.getInstance();
    var userData = prefs.getData(PreferenceUtils.userId);
    return userData;
  }
}
