import 'package:authexample/auth/wrapper.dart';
import 'package:authexample/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isGood = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  signUp() async{
    print("SIGNUP STARTED");

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      print("USER CREATED");
      Get.offAll(() => Wrapper());

    } on FirebaseAuthException catch (e) {
      print("FIREBASE ERROR: ${e.code}");

      Get.snackbar(
        "Signup Failed",
        e.message ?? "Unknown error",
        snackPosition: SnackPosition.BOTTOM,
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Cream and Cookies",style: GoogleFonts.dmSans(fontSize: 30, fontWeight: FontWeight.bold),),),
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5,),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(21)
                ),
                margin: EdgeInsets.all(10),
                child: ClipRRect(child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnj0mPLOW0B9FPDrDd_7wRbKbRU6ev4P4-kA&s", fit: BoxFit.fill,), borderRadius: BorderRadius.circular(21),),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(21)
                ),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Login to the cookies", style: GoogleFonts.dmSans(fontSize: 25, fontWeight: FontWeight.w300),),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width*0.7,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  hint: Text("Email ID", style: TextStyle(color: Colors.black45),),
                                  prefixIcon: Icon(Icons.mail, color: Colors.black,),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(color: Colors.blue)
                                  ),
                                ),
                                controller: email,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return('please enter a email');
                                  }
                                  if(!GetUtils.isEmail(value))
                                  {
                                    return('please enter a valid email');
                                  }
                                  return null;
                                }

                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width*0.7,
                            child: TextFormField(
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                  hint: Text("*********", style: TextStyle(color: Colors.black45),),
                                  prefixIcon: Icon(Icons.lock, color: Colors.black,),

                                  suffixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  }, icon: Icon(isObscure? Icons.visibility_off : Icons.visibility),),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(color: Colors.blue)
                                  ),
                                ),
                                controller: password,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return('please enter a password');
                                  }
                                  if(value.length <=6)
                                  {
                                    return('password is too short');
                                  }
                                  return null;
                                }

                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width*0.7,
                            child: TextFormField(
                                obscureText: isGood,
                                decoration: InputDecoration(
                                  hint: Text("*********", style: TextStyle(color: Colors.black45),),
                                  prefixIcon: Icon(Icons.lock_person_rounded, color: Colors.black,),

                                  suffixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      isGood = !isGood;
                                    });
                                  }, icon: Icon(isGood? Icons.visibility_off : Icons.visibility),),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(color: Colors.blue)
                                  ),
                                ),
                                controller: confirm_password,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return('please enter a password');
                                  }
                                  if(value.length <=6)
                                  {
                                    return('password is too short');
                                  }
                                  if(confirm_password.text != password.text)
                                    {
                                      return('password do not match');
                                    }
                                  return null;
                                }

                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width*0.4,
                              child: ElevatedButton(
                                onPressed: () {
                                  print("BUTTON PRESSED");

                                  if (formKey.currentState!.validate()) {
                                    print("FORM VALID");
                                    signUp();
                                  } else {
                                    print("FORM INVALID");
                                  }
                                },
                                child: Text(
                                  "Sign-in",
                                  style: GoogleFonts.dmSans(color: Colors.black, fontSize: 15),
                                ),
                              )

                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have a account?", style:GoogleFonts.dmSans(color: Colors.black),),
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text("Login", style: GoogleFonts.dmSans(color: Colors.blue),))
                            ],)
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
