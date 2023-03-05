import 'package:ctse_inlab_one/views/login/Signup.dart';
import 'package:ctse_inlab_one/views/app/home.dart';
import 'package:ctse_inlab_one/widget/PaddingBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailValidationController = TextEditingController();
  var passwordValidationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join with us'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: emailValidationController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            PaddingBox(),
            TextField(
              controller: passwordValidationController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            PaddingBox(),
            ElevatedButton(
                onPressed: () async {
                  var email = emailValidationController.text.trim();
                  var password = passwordValidationController.text.trim();
                  if (email.isEmpty || password.isEmpty) {
                    // show error toast
                    print("please fill email and password");
                    return;
                  }

                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;

                    UserCredential userCredential =
                    await auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (userCredential.user != null) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return Home();
                          }));
                    }
                  } on FirebaseAuthException catch (e) {

                    if (e.code == 'user-not-found') {
                      print("User not found");
                    } else if (e.code == 'wrong-password') {
                      print("Wrong password");
                    }
                  } catch (e) {
                    print('Connection error');
                  }
                },
                child: Text('Login')),
            PaddingBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('User not registed'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return  Signup();
                      }));
                    },
                    child:Text("I don't have an account")),
              ],
            )
          ],
        ),
      ),
    );
  }
}