import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        FirebaseAuth.instance.signOut();
      }),
      body: AppBar(centerTitle: true, title: Text("Home Page"),),
    );
  }
}
