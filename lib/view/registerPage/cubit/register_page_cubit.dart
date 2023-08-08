import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_page_state.dart';


enum RegisterState { phoneInput, otpInput }

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState.phoneInput);

  void showPhoneInput() => emit(RegisterState.phoneInput);
  void showOtpInput() => emit(RegisterState.otpInput);
}
