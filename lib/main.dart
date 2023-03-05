import 'package:ctse_inlab_one/views/login/Login.dart';
import 'package:ctse_inlab_one/views/app/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Firebase.initializeApp();
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTSE Recipe APP',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const Login()
          : const Home(),
    );
  }
}
