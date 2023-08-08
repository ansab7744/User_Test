import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class customwidget extends StatelessWidget {
   customwidget({super.key,required this.photo,
   required this.name,required this.age
   });
   var photo;
  String name;
  String age;

  // String get photo => null;
  @override
  Widget build(BuildContext context) {
    print(name);
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 5),
      child: Container(
        height: 75,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 211, 223, 233)
          
        ),
        child: Row(
          children: [
            Column(
              children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 20),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50),),
                color: const Color.fromARGB(255, 177, 220, 255)
                // color: Colors.red
                ),
                child: ClipOval(child: Image(image: NetworkImage("${photo}"),fit: BoxFit.fill,)),
                        ),
            )
            ],),
            SizedBox(width: 20,height: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${name.toString()}",style: TextStyle(color: Colors.black,fontSize: 18),),
                  SizedBox(height: 8,),
                  Text("${age.toString()}",style: TextStyle(color: Colors.black,fontSize: 16),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}