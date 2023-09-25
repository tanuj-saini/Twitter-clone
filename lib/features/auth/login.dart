import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/signUpScreen.dart';
import 'package:twitter/utils/LoderScreen.dart';
import 'package:twitter/utils/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends ConsumerState<LoginScreen> {

  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController PasswordContoller = TextEditingController();
 
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailContoller.dispose();
    PasswordContoller.dispose();
  }
   void signInWithEmail(String email,String password){
    
    
    ref.watch(authContollerProvider.notifier).loginInUser(email, password, context);

   }

  @override
  Widget build(BuildContext context) {
    final isLoding=ref.watch(authContollerProvider);
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          child: SvgPicture.asset('assets/svgs/twitter_logo.svg'),radius: 10,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child:isLoding?LoderScreen(): Center( 
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                TextField(
                  controller: emailContoller,
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: PasswordContoller,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () {signInWithEmail(emailContoller.text, PasswordContoller.text);},
                        child: Text(
                          'Done',
                          style: TextStyle(color: Pallete.whiteColor),
                        ))
                        ),
                        SizedBox(height: 30,),
                      Text('Already Have a Account '),TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>SignUpScreen()));
                      }, child: Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}



showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));}