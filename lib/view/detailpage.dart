// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:olx_project/widget/customwidget.dart';

// class DetailPage extends StatelessWidget {
//   const DetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           foregroundColor: Colors.black,
//           //
//           title: Text(
//             "Users",
//             style: TextStyle(
//                 color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
//           )
//           //   ],
//           // ),
//           ),
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection("col").snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               // int totallength=snapshot.data!.docs.length;
//               var data = snapshot.data!.docs;
//               return Column(
//                 children: [
//                   Expanded(
//                       child: ListView.separated(
//                           itemBuilder: (context, index) {
//                             return customwidget(
//                               photo: data[index]["images"],
//                               name: data[index]["Name"].toString(),
//                               age: data[index]["Age"].toString(),
//                             );
//                           },
//                           separatorBuilder: (context, index) => Divider(
//                                 color: Colors.transparent,
//                               ),
//                           itemCount: data.length))
//                 ],
//               );
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Text(snapshot.hasError.toString());
//             } else {
//               Center(
//                 child: Text("center"),
//               );
//             }
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:olx_project/widget/customwidget.dart';

// class DetailPage extends StatefulWidget {
//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   late ScrollController _scrollController;
//   late QueryDocumentSnapshot<Object?> _lastDocument;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _lastDocument = null as QueryDocumentSnapshot<Object?>;
//     _loadData();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       _loadData();
//     }
//   }

//   Future<void> _loadData() async {
//     if (!_isLoading) {
//       setState(() {
//         _isLoading = true;
//       });

//       QuerySnapshot<Map<String, dynamic>> querySnapshot;

//       if (_lastDocument == null) {
//         querySnapshot = await FirebaseFirestore.instance
//             .collection("col")
//             .orderBy("Name")
//             .limit(10)
//             .get();
//       } else {
//         querySnapshot = await FirebaseFirestore.instance
//             .collection("col")
//             .orderBy("Name")
//             .startAfterDocument(_lastDocument)
//             .limit(10)
//             .get();
//       }

//       if (querySnapshot.docs.isNotEmpty) {
//         _lastDocument = querySnapshot.docs.last;
//       }

//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         title: Text(
//           "Users",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("col").snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(snapshot.error.toString()),
//             );
//           } else if (snapshot.hasData) {
//             var data = snapshot.data!.docs;
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount: data.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index < data.length) {
//                         return customwidget(
//                           photo: data[index]["images"],
//                           name: data[index]["Name"].toString(),
//                           age: data[index]["Age"].toString(),
//                         );
//                       } else if (_isLoading) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       } else {
//                         return SizedBox.shrink();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx_project/widget/customwidget.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ScrollController _scrollController;
  QueryDocumentSnapshot? _lastDocument;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _lastDocument = null;
    _loadData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (_lastDocument == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection("col")
            .orderBy("Name")
            .limit(10)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection("col")
            .orderBy("Name")
            .startAfterDocument(_lastDocument!)
            .limit(10)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          "Users",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("col").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(color: Colors.transparent,),
                    controller: _scrollController,
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      if (index < data.length) {
                        return customwidget(
                          photo: data[index]["images"],
                          name: data[index]["Name"].toString(),
                          age: data[index]["Age"].toString(),
                        );
                      } else if (_isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
