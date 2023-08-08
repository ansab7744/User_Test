import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:olx_project/view/loginPage/cubit/login_page_cubit.dart';
import 'package:olx_project/view/loginPage/cubit/login_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage/homepage.dart';
import '../registerPage/mobilenumberpage.dart';
import '../registerpage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final button = GlobalKey<FormState>();

  TextEditingController mailctr = TextEditingController();

  TextEditingController passwordctr = TextEditingController();

  verify(BuildContext context, String email, String password) {
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              )));
    } catch (e) {
      print("error$e");
    }
  }

  Future<UserCredential> signWithgoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    // SharedPreferences shref = await SharedPreferences.getInstance();
    //shref.setString('user', googleuser!.email);
    print('>>>>>>>${googleuser?.email}');
    GoogleSignInAuthentication? googleAuth = await googleuser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCred.user!.email);
    final spref = await SharedPreferences.getInstance();
    spref.setString('email', userCred.user!.email ?? 'qwert');

    return userCred;
  }

  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginPageCubit(context),
      child: BlocBuilder<LoginPageCubit, LoginPageState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 115, left: 30, right: 40),
              child: SingleChildScrollView(
                child: Form(
                  key: button,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                      const Text("Make it Work,make it right, make it fast"),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "pls enter a valid mail";
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: mailctr,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline_outlined),
                            hintText: "E-Mail",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordctr,
                        validator: (value) {
                          if (value!.length < 8 || value.length > 8) {
                            return "At least 8 charecters";
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint),
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  // setState(() {
                         context.read<LoginPageCubit>().setValue(false);

                                    _passwordVisible = !_passwordVisible;
                                  // });
                        context.read<LoginPageCubit>().setValue(true);

                                },
                                icon: _passwordVisible
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          verify(context, mailctr.text, passwordctr.text);
                        },
                        child: Container(
                          height: 45,
                          // width: 320,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromARGB(255, 34, 34, 34)),
                          child: Center(
                              child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 148),
                        child: Text(
                          "OR",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          UserCredential userCredential =
                              await signWithgoogle();
                        },
                        child: Container(
                          height: 50,
                          // width: 320,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: const Color.fromARGB(255, 231, 238, 244),
                              border: Border.all(color: Colors.black)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 25,
                                  child: Image(
                                      image: AssetImage(
                                          "assets/google_icon.png"))),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Login With Google",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        )),
                        child: Container(
                          height: 50,
                          // width: 320,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: const Color.fromARGB(255, 231, 238, 244),
                              border: Border.all(color: Colors.black)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 25,
                                  child: Image(
                                    image: AssetImage(
                                      "assets/mobile_icon.png",
                                    ),
                                    color: Color.fromARGB(255, 2, 99, 179),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Login With Phone",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 45),
                        child: Row(
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => registerpage(),
                              )),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
