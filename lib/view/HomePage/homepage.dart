import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_project/view/HomePage/cubit/home_page_cubit.dart';
import 'package:olx_project/view/HomePage/cubit/home_page_state.dart';
import 'package:olx_project/view/detailpage.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // File? images;
  TextEditingController namectr=TextEditingController();
  TextEditingController agectr=TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool flag=true;
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
                  final homeCubit = context.read<HomeCubit>();

          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(left: 30, top: 90),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter Your",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 5, 71, 125)),
                          ),
                          Text(
                            "Details",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 5, 71, 125)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100, top: 30),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Select Image From!"),
                                    actions: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              style: const ButtonStyle(),
                                              onPressed: () async {
                                                    XFile? file = await homeCubit.pictures
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        Navigator.pop(context);
                                        homeCubit.setImage(file != null
                                            ? File(file.path)
                                            : null);
                                              },
                                              child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          "assets/gallery_icon.png")))),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          ElevatedButton(
                                                   style: const ButtonStyle(),

                                              onPressed: () async {
                                               XFile? file1 = await homeCubit.pictures
                                            .pickImage(
                                                source: ImageSource.camera);
                                        Navigator.pop(context);
                                        homeCubit.setImage(file1 != null
                                            ? File(file1.path)
                                            : null);
                                              },
                                              child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          "assets/camera_icon.png"))))
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                  color: state.images == null
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                                child: state.images == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Colors.white,
                                      )
                                    : ClipOval(
                                        child: Image.file(
                                        state.images!,
                                        fit: BoxFit.fill,
                                      )),
                              ),
                              //
                            ),
                            const Positioned(
                              right: 0,
                              bottom: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Container(
                          height: 50,
                          child: TextFormField(
                            controller: namectr,
                            decoration: const InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Container(
                          height: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: agectr,
                            decoration: const InputDecoration(
                                hintText: "Age",
                                hintStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    //  state.isUploading==false?
                      InkWell(
                        onTap: () async {
                        // context.read<HomeCubit>().setLoading(false);
                          state.name=namectr.text;
                          state.age=agectr.text;
                          // state.images=
                          await homeCubit.uploadData(context);
                        // context.read<HomeCubit>().setLoading(true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Container(
                            height: 45,
                            // width: 325,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Color.fromARGB(255, 34, 34, 34)),
                            child: const Center(
                                child:Text(
                              "Upload",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            )
                            ),
                          ),
                        ),
                      ),
                      
                      // :Center(child: CircularProgressIndicator()
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () =>homeCubit.logout(context),
                        child: Container(
                          height: 45,
                          width: 100,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: Color.fromARGB(255, 225, 216, 223)),
                          child: const Center(
                              child: Text(
                            "Log out",
                            style: TextStyle(
                                color: Color.fromARGB(255, 7, 101, 179),
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  DetailPage(),
                )),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromARGB(255, 153, 199, 238)),
                  child: const Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ));
        },
      ),
    );
  }
}
