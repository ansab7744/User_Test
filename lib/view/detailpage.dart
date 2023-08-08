import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_project/widget/customwidget.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          // 
          title: Text(
            "Users",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          )
          //   ],
          // ),
          ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("col").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return customwidget(
                              photo: data[index]["images"],
                              name: data[index]["Name"].toString(),
                              age: data[index]["Age"].toString(),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.transparent,
                              ),
                          itemCount: data.length))
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.hasError.toString());
            } else {
              Center(
                child: Text("center"),
              );
            }
            return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}
