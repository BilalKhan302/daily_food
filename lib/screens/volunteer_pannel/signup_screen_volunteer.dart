import 'package:daily_food/screens/volunteer_pannel/login_screen_volunteer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/constants.dart';
final _auth = FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class SignUpScreenVolunteer extends StatefulWidget {
  const SignUpScreenVolunteer({Key? key}) : super(key: key);
  @override
  State<SignUpScreenVolunteer> createState() => _SignUpScreenVolunteerState();
}
class _SignUpScreenVolunteerState extends State<SignUpScreenVolunteer> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? _image;
  UserCredential? user;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Future pickImage() async {
      try {
        final pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {
          if (pickedImage != null) {
            _image = File(pickedImage.path);
          } else {
            print("error");
          }
        });
      } catch (e) {}
    }

    Future uploadData(String email, String password, String name,
        String phone,) async {
      // String imgUrl;
      // String imgId = DateTime.now().microsecondsSinceEpoch.toString();
      // Reference reference = FirebaseStorage.instance.ref().child("images/patient/").child('me$imgId');
      // await reference.putFile(_image);
      // imgUrl = await reference.getDownloadURL();
      UserCredential? user;
      try {
        user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        print(e);
      }
      if (user != null) {
        var user=_auth.currentUser;
        CollectionReference ref=FirebaseFirestore.instance.collection('volunteer');
        ref.doc(user!.uid).set({
          'email': email,
          'name': name,
          'phone': phone,
          // 'imgUrl':imgUrl,
          'role':"volunteer",
        });
      }

    }
    // String regex =
    //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,

                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.srcOver),
                    image: AssetImage(
                        "images/signup_vol.jpg"
                    ),
                  )),
            ),
            Column(
              children: [
                SizedBox(
                  height: height * 0.3,
                ),
                RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: "IF You Are New...",
                          style: TextStyle(fontSize: 20, color: Colors.red)),
                      TextSpan(
                          text: "Please Register First!",
                          style: TextStyle(fontSize: 15, color: Colors.black))
                    ])),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("If you have Already An Account..",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreenVolunteer()));
                        },
                        child: Text("Click Here",
                            style: TextStyle(fontSize: 16, color: Colors.red)),
                      ),

                    ],
                  ),
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
                          icon: const Icon(Icons.email_outlined),
                          obsTxt: false,
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ConstTextForm(
                          controller: _pass,
                          label: "Please Enter the Password",
                          icon: const Icon(Icons.password_outlined),
                          obsTxt: true,
                          type: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ConstTextForm(
                            controller: _name,
                            label: "Enter Your Full Name",
                            icon: const Icon(Icons.person),
                            obsTxt: false,
                            type: TextInputType.text),
                        const SizedBox(
                          height: 10,
                        ),
                        ConstTextForm(
                          controller: _phone,
                          label: "Enter your phone number",
                          icon: const Icon(Icons.phone),
                          obsTxt: false,
                          type: TextInputType.phone,),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(height: height*0.03,),
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
                              await uploadData(
                                _email.text,
                                _pass.text,
                                _name.text,
                                _phone.text,
                              ).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreenVolunteer())));

                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ))

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );

  }

}


