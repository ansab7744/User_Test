import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'login_page_state.dart';


class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit(this.context) : super(LoginPageInitial()){
    
  }
  final BuildContext context;

  void setValue(bool value) {
    emit(LoginPageState(
        valueChange: value)); // Set the boolean value and emit the new state
  }
}
