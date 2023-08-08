import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olx_project/view/loginPage/cubit/login_page_cubit.dart';
import 'package:olx_project/view/loginPage/cubit/login_page_state.dart';

import 'HomePage/homepage.dart';
import 'loginPage/loginpage.dart';

class registerpage extends StatelessWidget {
  registerpage({super.key});

  TextEditingController mailctr = TextEditingController();

  TextEditingController passwordctr = TextEditingController();

  auth({
    required email,
    required password,
   required BuildContext context,
  }) {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString())
          .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              )));
    } catch (e) {
      print("error $e");
    }
  }

  final button = GlobalKey<FormState>();

  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginPageCubit(context),
      child: BlocBuilder<LoginPageCubit, LoginPageState>(
        builder: (context, state) {
          return Scaffold(
              body: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 80),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Form(
                        key: button,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Tell Us About You !",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                "Make it Work,make it right, make it fast",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: mailctr,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "pls enter a valid mail";
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.mail_outline_outlined),
                                    hintText: "E-Mail",
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: passwordctr,
                                validator: (value) {
                                  if (value!.length < 8 || value.length > 8) {
                                    return "At least 8 charecters";
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.fingerprint),
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          // setState(() {
                                          //   _passwordVisible = !_passwordVisible;
                                          // });
                                          context
                                              .read<LoginPageCubit>()
                                              .setValue(false);

                                          _passwordVisible = !_passwordVisible;
                                          // });
                                          context
                                              .read<LoginPageCubit>()
                                              .setValue(true);
                                        },
                                        icon: _passwordVisible
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 45,
                                // width: 320,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Color.fromARGB(255, 34, 34, 34)),
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    auth(
                                      context: context,
                                        email: mailctr.text,
                                        password: passwordctr.text);
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Row(
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      )),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                  )));
        },
      ),
    );
  }
}
