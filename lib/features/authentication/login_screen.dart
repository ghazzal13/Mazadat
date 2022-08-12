import 'package:auction_clean_architecture/features/authentication/singup_screen.dart';
import 'package:auction_clean_architecture/layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../core/app_theme.dart';
import '../../core/widgets/reuse_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  bool _isLoading = false;
  var isPassword = true;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
  }

  String messageEmail = '/';
  String messagePassword = '/';
  Future loginUser({email, password}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ManagementLayout()),
            (route) => false);
      });
      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        messageEmail = 'No user found for that email.';
        setState(() {
          // print('No user found for that email.');
        });
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        setState(() {
          messagePassword = 'Wrong password provided for that user.';
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  var hight = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                    height: 300,
                    child: Image(
                      image: AssetImage('asset/image/mazadat_1.png'),
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  height: 20,
                ),
                reuseFormField(
                  controller: _email,
                  type: TextInputType.emailAddress,
                  validate:
                      ValidationBuilder(requiredMessage: 'can not be emity')
                          .email()
                          .add((_) {
                    if (messageEmail != '/') {
                      return messageEmail;
                    }
                    return null;
                  }).build(),
                  label: 'email',
                  prefix: Icons.email,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                reuseFormField(
                  controller: _password,
                  type: TextInputType.text,
                  validate:
                      ValidationBuilder(requiredMessage: 'can not be emity')
                          .minLength(6)
                          .add((_) {
                    if (messagePassword != '/') {
                      return messagePassword;
                    }
                    return null;
                  }).build(),
                  label: 'password',
                  textInputAction: TextInputAction.done,
                  prefix: Icons.password,
                ),
                const SizedBox(
                  height: 40,
                ),
                FloatingActionButton.extended(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      await loginUser(
                          email: _email.text, password: _password.text);
                    }
                  },
                  label: !_isLoading
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: (Colors.white),
                        ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Dont have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SingUpScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
