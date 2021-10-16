import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task/styles/custom_assets.dart';
import 'package:task/viewmodels/authentication_model.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  TextEditingController _fullNameController = TextEditingController();
  XFile? _userImage;

  pickUserImage() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(file != null){
        setState(() {
          _userImage = file;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  createUser(AuthenticationViewModel authModel) async{
    if(_fullNameController.text.trim().length == 0){
      showSnackBar('You should enter your name');
    }
    if(_userImage == null){
      showSnackBar('You should enter your image');
    }
    try{
      await authModel.createUser(_userImage , _fullNameController.text.trim());
    }catch(e){
      showSnackBar('error has happened');
    }
  }

  showSnackBar(text){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You should enter your name')));
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image = AssetImage(CustomAssets.userPlaceHolder);
    if (_userImage != null) {
      image = FileImage(File(_userImage!.path));
    }
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userImage != null ? Container() : Container(),
            GestureDetector(
              onTap: pickUserImage,
              child: Container(
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.width * .4,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: image, fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full name*',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Consumer<AuthenticationViewModel>(
              builder: (_, authModel, child) => authModel.busy
                  ? const CircularProgressIndicator()
                  : RaisedButton(
                      onPressed:() => createUser(authModel),
                      color: Colors.blueAccent,
                      child: const Text(
                        "Join Chat App",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
