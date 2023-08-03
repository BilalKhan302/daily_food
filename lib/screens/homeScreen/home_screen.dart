import 'package:daily_food/screens/ngo_pannel/signup_screen_ngo.dart';
import 'package:daily_food/screens/volunteer_pannel/signup_screen_volunteer.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedValue = '';
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: height*0.40,
                    width: width,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(200),bottomLeft: Radius.circular(200))
                    ),

                    // child: SvgPicture.asset("images/wave (7).svg",height: 170,fit: BoxFit.fill,),
                  ),
                  Positioned(
                      top: 50,
                      left: 100,
                      child: SvgPicture.asset('images/splashLogo.svg',height: 200,width: 200,)),

                ],
              ),
              20.heightBox,
              Text("Welcome To Daily food",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),),
              10.heightBox,

              Text("You can donate and receive the extra food",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),),
              SizedBox(
                height: height*0.05,
              ),
              // SvgPicture.asset("images/home_screen.svg",height: height*0.2,
              //   width: width,),
              // SizedBox(
              //   height: height*0.04,
              // ),
              Text("Please Choose Your Role",style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),),
              SizedBox(
                height: height*0.02,
              ),


          DropdownButton<String>(
            value: selectedValue,
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue.toString();
              });
            },
            items: [
              DropdownMenuItem(value: '', child: Text('Select an option')),
              DropdownMenuItem(value: 'Ngo', child: Text('Ngo')),
              DropdownMenuItem(value: 'Volunteer', child: Text('Volunteer')),
            ],
          ),
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: RadioListTile(
              //           activeColor: primaryColor,
              //           value: Role.ngo,
              //           groupValue: _role,
              //           title: Text("Ngo"),
              //           onChanged: (val){
              //             setState(() {
              //               _role=val;
              //             });
              //           }
              //       ),
              //     ),
              //     Expanded(
              //       child: RadioListTile(
              //           activeColor: primaryColor,
              //           value: Role.volunteer,
              //           groupValue: _role,
              //           title: Text("Volunteer"),
              //           onChanged: (val){
              //             setState(() {
              //               _role=val;
              //             });
              //           }
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: height*0.13,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      minimumSize: Size(width*0.8, 40)
                  ),
                  onPressed: (){
                    print(selectedValue);
                    if(selectedValue=='Ngo'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreenNgo()));
                    }else if(selectedValue=='Volunteer'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreenVolunteer()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Center(child: Text("Please select your role first"))));
                    }
                  }, child: Text("Next",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),))


            ],
          ),
        ),
      ),
    );
  }
}
