import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState {
   File? images;
   String name;
   String age;
      bool isUploading;


  HomeState({
    required this.images,
    required this.name,
    required this.age,
    required this.isUploading
  });

  HomeState copyWith({
    File? images,
    String? name,
    String? age,
    bool? isUploading,
  }) {
    return HomeState(
      images: images ?? this.images,
      name: name ?? this.name,
      age: age ?? this.age,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}