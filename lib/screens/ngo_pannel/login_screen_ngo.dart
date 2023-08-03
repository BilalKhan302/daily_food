import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/constants.dart';
import 'ngo_home.dart';

final _auth = FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class LoginScreenNgo extends StatefulWidget {
  const LoginScreenNgo({Key? key}) : super(key: key);

  @override
  State<LoginScreenNgo> createState() => _LoginScreenNgoState();
}

class _LoginScreenNgoState extends State<LoginScreenNgo> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  UserCredential? user;
  String ?currentUser;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // String regex =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: const Text(
        //     "NGO Panel",
        //     style: TextStyle(fontSize: 25,
        //     color: Colors.black),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: primaryColor,
        // ),
        body:Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,

                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.srcOver),
                    image: AssetImage(
                        "images/home.jpg"
                    ),
                  )),
            ),
            Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        SizedBox(height: height*0.3,),
                        Text("Login Screen",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white
                          ),),
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ListView(
                              children: [
                                ConstTextForm(
                                  controller: _email,
                                  label: "Please Enter the Email",
                                  icon: const Icon(Icons.email_outlined,color: Colors.white,),
                                  obsTxt: false,
                                  type: TextInputType.emailAddress,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ConstTextForm(
                                  controller: _pass,
                                  label: "Please Enter the Password",
                                  icon: const Icon(Icons.password_outlined,color: Colors.white,),
                                  obsTxt: true,
                                  type: TextInputType.text,
                                ),
                                 SizedBox(height: height*0.09,),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: primaryColor,
                                        minimumSize: Size(width * 0.8, 40)),
                                    onPressed: () async {
                                      if (_email.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          elevation: 1.0,
                                          content: const Text("Email Can't be empty"),
                                          backgroundColor: primaryColor,
                                        ));
                                      } else if (_pass.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          elevation: 1.0,
                                          content: const Text("Password Can't be empty"),
                                          backgroundColor: primaryColor,
                                        ));
                                      } else if (_pass.text.length < 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            elevation: 1.0,
                                            backgroundColor: primaryColor,
                                            content: const Text(
                                                "Password length must be six or greater")));
                                      }
                                      // login
                                      _auth.fetchSignInMethodsForEmail(_email.text)
                                          .then((signInMethods) async {
                                        if (signInMethods.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            elevation: 1.0,
                                            content: const Text("Email not found"),
                                            backgroundColor: primaryColor,
                                          ));
                                        } else {
                                          // email exists
                                          UserCredential? user = await _auth.signInWithEmailAndPassword(email: _email.text, password: _pass.text);

                                          if (user != null) {

                                            final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("ngo").doc(user.user?.uid).get();
                                            if (snapshot.data() is Map) {
                                              Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                                              if(data["role"] == "ngo")
                                                // Allow the user to log in
                                                currentUser=data["name"];
                                              String? currentId=_auth.currentUser?.uid;
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NGOHomeScreen()));
                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //   builder: (context) => DoctorHome(
                                              //     docId: currentId,
                                              //     docEmail: _auth.currentUser!.email,
                                              //     docName: currentUser,
                                              //
                                              //   ),
                                              // ));
                                            } else {
                                              // Show an error message
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                elevation: 1.0,
                                                content: const Text("You are not authorized to access this page"),
                                                backgroundColor: primaryColor,
                                              ));
                                            }
                                          }else {
                                            // Show an error message
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              elevation: 1.0,
                                              content: const Text("You are not authorized to access this page"),
                                              backgroundColor: primaryColor,
                                            ));
                                          }

                                        }
                                      })
                                          .catchError((error) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          elevation: 1.0,
                                          content: Text("Error: $error"),
                                          backgroundColor: primaryColor,
                                        ));
                                      });

                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        )
      ),
    );

  }

}

