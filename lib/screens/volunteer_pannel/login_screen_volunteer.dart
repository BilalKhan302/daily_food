import 'package:daily_food/screens/volunteer_pannel/volunterr_home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class LoginScreenVolunteer extends StatefulWidget {
  const LoginScreenVolunteer({Key? key}) : super(key: key);

  @override
  State<LoginScreenVolunteer> createState() => _LoginScreenVolunteerState();
}

class _LoginScreenVolunteerState extends State<LoginScreenVolunteer> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  UserCredential? user;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // String regex =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body:  Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.fitHeight,

                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.srcOver),
                  image: AssetImage(
                      "images/login_vol.jpeg"
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: height*0.2,),
                Text("Login Screen",
                  style: TextStyle(
                      fontSize: 30,
                      color: primaryColor
                  ),),
                const SizedBox(height: 10,),
                SizedBox(
                  height: height * 0.02,
                ),
                ConstTextForm(
                  controller: _email,
                  label: "Please Enter the Email",
                  icon: const Icon(Icons.email_outlined,
                  color: Colors.white,),
                  obsTxt: false,
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                ConstTextForm(
                  controller: _pass,
                  label: "Please Enter the Password",
                  icon: const Icon(Icons.password_outlined,color: Colors.white,) ,
                  obsTxt: true,
                  type: TextInputType.text,
                ),
                SizedBox(height: 40),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.8),
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

                            final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("volunteer").doc(user.user?.uid).get();
                            if (snapshot.data() is Map) {
                              Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
                              if(data["role"] == "volunteer") {
                                // Allow the user to log in
                                String currentUser=data["name"];
                                String? currentId=_auth.currentUser?.uid;
                                String? patientPhone=data["phone"];
                                String? patientImgUrl=data["imgUrl"];
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VolunteerHomeScreen(volunteerName: currentUser,)));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) =>  PatientHome(
                                //     patientImgUrl: patientImgUrl,
                                //     patientPhone: patientPhone,
                                //     currentUserName: currentUser,
                                //     currentUserId: currentId,
                                //
                                //   ),
                                // ));

                              }
                            } else {
                              // Show an error message
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                elevation: 1.0,
                                content: const Text("You are not authorized to access this page"),
                                backgroundColor: primaryColor,
                              ));
                            }
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
        ],
      )
    );

  }

}

