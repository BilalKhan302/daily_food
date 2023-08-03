import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';
import '../homeScreen/home_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }
  navigate() async{await Future.delayed(const Duration(seconds: 2));
  if(!mounted)return;
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        backgroundColor: primaryColor,
        body: Center(child: SvgPicture.asset('images/splashLogo.svg',
          height: MediaQuery.of(context).size.height*0.2,
          width: MediaQuery.of(context).size.width-30,))
    );
  }
}