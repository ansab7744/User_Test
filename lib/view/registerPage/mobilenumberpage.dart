import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../HomePage/homepage.dart';
import 'cubit/register_page_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: _RegisterScreenContent(),
    );
  }
}

class _RegisterScreenContent extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  String otpPin = " ";
  String countryDial = "+1";
  String verID = " ";

  Color blue = const Color(0xff8cccff);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        bottom = MediaQuery.of(context).viewInsets.bottom;

        return WillPopScope(
          onWillPop: () {
            context.read<RegisterCubit>().showPhoneInput();
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight / 4,
                          right: screenWidth / 9,
                          left: screenWidth / 10),
                      child: Column(
                        children: [
                          Text(
                            "Enter your mobile number",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 13,
                            ),
                          ),
                          Text(
                            '''We have  to sent verification code to 
                  your mobile number!''',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: screenWidth / 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      height: bottom > 0 ? screenHeight : screenHeight / 2,
                      width: screenWidth,
                      color: Colors.white,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth / 12,
                          right: screenWidth / 12,
                          top: bottom > 0 ? screenHeight / 14 : 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state == RegisterState.phoneInput
                                ? _stateRegister(context)
                                : _stateOTP(context),
                            InkWell(
                              onTap: () {
                                if (state == RegisterState.phoneInput) {
                                  if (phoneController.text.isEmpty) {
                                    _showSnackBarText(
                                        context, "Phone number is still empty!");
                                  } else {
                                    _verifyPhone(
                                        context, countryDial + phoneController.text);
                                  }
                                } else {
                                  if (otpPin.length >= 6) {
                                    _verifyOTP(context);
                                  } else {
                                    _showSnackBarText(context, "Enter OTP correctly!");
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                width: screenWidth,
                                margin:
                                    EdgeInsets.only(bottom: screenHeight / 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    "Send otp",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBarText(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void _verifyPhone(BuildContext context, String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 100),
      verificationCompleted: (PhoneAuthCredential credential) {
        _showSnackBarText(context, "Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackBarText(context, "Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        _showSnackBarText(context, "OTP Sent!");
        verID = verificationId;
        print('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${verificationId}');
        context.read<RegisterCubit>().showOtpInput();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _showSnackBarText(context, "Timeout!");
      },
    );
  }

  Future<void> _verifyOTP(BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    )
        .whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      print('${verID}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    });
  }

  Widget _stateRegister(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Phone number",
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        IntlPhoneField(
          controller: phoneController,
          showCountryFlag: false,
          showDropdownIcon: false,
          initialValue: countryDial,
          onCountryChanged: (country) {
            countryDial = "+" + country.dialCode;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _stateOTP(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: countryDial + phoneController.text,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nEnter the code here and we can continue!",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            otpPin = value;
          },
          pinTheme: PinTheme(
            activeColor: blue,
            selectedColor: blue,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    context.read<RegisterCubit>().showPhoneInput();
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
