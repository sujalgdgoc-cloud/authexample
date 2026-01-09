import 'package:authexample/screens/signin.dart';
import 'package:authexample/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool isObscure = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Authentication Error',
          e.message ?? 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      });
    }
  }
  forget() async{
    if (email.text.isEmpty || !GetUtils.isEmail(email.text)) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a registered email address",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.trim(),
      );

      Get.snackbar(
        "Email Sent",
        "Password reset link sent. Check inbox & spam folder.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message ?? "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
   Speical_Login()async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Cream and Cookies",style: GoogleFonts.dmSans(fontSize: 30, fontWeight: FontWeight.bold),),),
      body: SafeArea(
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
                height: MediaQuery.of(context).size.height*0.6,
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
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width*0.4,
                              child: ElevatedButton(onPressed: (){
                                if(formKey.currentState!.validate())
                                  {
                                    signIn();
                                  }
                              }, child: Text("Login", style: GoogleFonts.dmSans(color: Colors.black, fontSize: 15)), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, iconColor: Colors.black),)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text("Didn't have a account?", style:GoogleFonts.dmSans(color: Colors.black),),
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Signin()));
                            }, child: Text("Sign-in", style: GoogleFonts.dmSans(color: Colors.blue),))
                          ],
                          ),
                          TextButton(onPressed: (){
                            forget();
                          }, child: Text("Forget password? ",style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.blue),)),
                          Divider(color: Colors.black,),
                          Text("Continue with google", style: GoogleFonts.dmSans(color: Colors.grey),),
                          IconButton.outlined(onPressed: (){
                            Speical_Login();
                            print("button working");
                          }, icon: Icon(Icons.g_mobiledata, size: 40,)
                          )
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
