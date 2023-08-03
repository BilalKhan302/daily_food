import 'package:daily_food/screens/ngo_pannel/login_screen_ngo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:velocity_x/velocity_x.dart';
import '../../utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

final _auth = FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SignUpScreenNgo extends StatefulWidget {
  const SignUpScreenNgo({Key? key}) : super(key: key);

  @override
  State<SignUpScreenNgo> createState() => _SignUpScreenNgoState();
}

class _SignUpScreenNgoState extends State<SignUpScreenNgo> {
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
        CollectionReference ref=FirebaseFirestore.instance.collection('ngo');
        ref.doc(user!.uid).set({
          'email': email,
          'name': name,
          'phone': phone,
          'role':"ngo",
        });

      }

    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: Text(
        //     "Ngo Panel",
        //     style: TextStyle(fontSize: 25),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: primaryColor,
        // ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,

                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.srcOver),
                    image: AssetImage(
                        "images/signup.jpg"
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.3,
                  ),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "If You Are New...",
                            style: TextStyle(fontSize: 20, color: Colors.red)),
                        TextSpan(
                            text: "Please Register First!",
                            style: TextStyle(fontSize: 15, color: primaryColor)),
                      ])),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("If you have Already An Account..",
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreenNgo()));
                          },
                          child: Text("Click Here",
                              style: TextStyle(fontSize: 16, color: Colors.red)),
                        ),

                      ],
                    ),
                  ),
                  ConstTextForm(
                    controller: _email,
                    label: "Please Enter the Email",
                    icon: Icon(Icons.email_outlined),
                    obsTxt: false,
                    type: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ConstTextForm(
                    controller: _pass,
                    label: "Please Enter the Password",
                    icon: Icon(Icons.password_outlined),
                    obsTxt: true,
                    type: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ConstTextForm(
                    controller: _name,
                    label: "Enter Your Full Name",
                    icon: Icon(Icons.person),
                    obsTxt: false,
                    type: TextInputType.text,),
                  SizedBox(
                    height: 10,
                  ),
                  ConstTextForm(
                    controller: _phone,
                    label: "Enter your phone number",
                    icon: Icon(Icons.phone),
                    obsTxt: false,
                    type: TextInputType.phone,),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: height*0.05,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          minimumSize: Size(width * 0.8, 40)),
                      onPressed: () async {
                        if (_email.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 1.0,
                            content: Text("Email Can't be empty"),
                            backgroundColor: primaryColor,
                          ));
                        } else if (_pass.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 1.0,
                            content: Text("Password Can't be empty"),
                            backgroundColor: primaryColor,
                          ));
                        } else if (_pass.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              elevation: 1.0,
                              backgroundColor: primaryColor,
                              content: Text(
                                  "Password length must be six or greater")));
                        }
                        await uploadData(
                          _email.text,
                          _pass.text,
                          _name.text,
                          _phone.text
                        ).then((value) =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreenNgo())));

                      },
                      child: Text(
                        "Register",
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
      ),
    );

  }

}

