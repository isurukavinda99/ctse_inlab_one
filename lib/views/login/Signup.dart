import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widget/PaddingBox.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'User userName',
                ),
              ),
              PaddingBox(),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              PaddingBox(),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              PaddingBox(),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                ),
              ),
              PaddingBox(),
              ElevatedButton(
                  onPressed: () async {
                    var userName = usernameController.text.trim();
                    var email = emailController.text.trim();
                    var password = passwordController.text.trim();
                    var confirmPassword = confirmPasswordController.text.trim();

                    if (userName.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      print("Please fill required fields");
                      return;
                    }

                    if (password != confirmPassword) {
                      print("Passwords does not match");
                      return;
                    }

                    try {
                      FirebaseAuth auth = FirebaseAuth.instance;

                      UserCredential userCredential =
                          await auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      if (userCredential.user != null) {
                        // store user information in Firestore database

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;

                        String userId = userCredential.user!.uid;

                        firestore.collection('users').doc(userId).set({
                          'userId': userId,
                          'userName': userName,
                          'email': email,
                          'password': password,
                        });

                        Navigator.of(context).pop();
                      } else {}
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        print("Email is already in exist");
                      } else if (e.code == 'weak-password') {
                        print("Password is weak");
                      }
                    } catch (e) {
                      print("Connection error");
                    }
                  },
                  child: Text('Sign Up')),
              PaddingBox(),
            ],
          ),
        ),
      ),
    );
  }
}
