
class LoginPageState {
  bool valueChange;
  LoginPageState({required this.valueChange});
}

class LoginPageInitial extends LoginPageState {
  LoginPageInitial() : super(valueChange: true);
}