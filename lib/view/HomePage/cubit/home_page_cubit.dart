import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../loginPage/loginpage.dart';
import '../homepage.dart';
import 'home_page_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ImagePicker pictures = ImagePicker();

  HomeCubit()
      : super(HomeState(
          images: null,
          name: '',
          age: '',
     isUploading: false,

        ));

  void setImage(File? image) {
    emit(state.copyWith(images: image));
  }
  

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setAge(String age) {
    emit(state.copyWith(age: age));
  }
 void setLoading(bool isLoading) {
    emit(state.copyWith(isUploading: isLoading));
  }
  void clearInputs() {
    emit(state.copyWith(name: '', age: ''));
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) =>
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage())));
    } catch (e) {
      print("error $e");
    }
  }

 Future<void> uploadData(BuildContext context) async {
    if (state.name.isNotEmpty && state.age.isNotEmpty && state.images != null) {
      try {

        var imagestore = FirebaseStorage.instance
            .ref()
            .child("images${state.name}");
        await imagestore.putFile(state.images!);

        String imageurl = await imagestore.getDownloadURL();
        print("Image URL: $imageurl");

        await FirebaseFirestore.instance.collection("col").add({
          "images": imageurl,
          "Name": state.name,
          "Age": state.age,
        });

        clearInputs();
        // setLoading(false);
ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Success ")),
      );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        setLoading(false);
        print("Error: $e");
      }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing data ")),
      );
      debugPrint("Error: Missing data");
    }
  }
}