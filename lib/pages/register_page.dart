import 'package:chatii_app/services/auth/auth_service.dart';
import 'package:chatii_app/components/custome_button.dart';
import 'package:chatii_app/components/custome_textField.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget{
  final TextEditingController _emcontroller = TextEditingController() ; 
  final TextEditingController _pwcontroller  = TextEditingController();
  final TextEditingController _confirmpwcontroller  = TextEditingController();

  final void Function()? onTap ; 

  void register(BuildContext context) async {
    if(_pwcontroller.text == _confirmpwcontroller.text){
      try{
        final _auth = AuthService();
          _auth.signUpWithEmailPassword(
            _emcontroller.text,
            _pwcontroller.text);
        }catch (e){
          showDialog(context: context,
          builder: (context)=> AlertDialog(
          title: const Text("error while signing in "),
          content: Text(e.toString()),
          ));
        }
    }else{
      showDialog(context: context,
          builder: (context)=> const AlertDialog(
          title: Text("Passwords don't match"),
          ));
    }
  
  }

  RegisterPage({super.key , required this.onTap});

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(

        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message , 
              size: 60,
              color: Theme.of(context).colorScheme.primary,
              ),
              const  SizedBox(height: 50,),
              Text("Let's create an account for you ." ,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const  SizedBox(height: 25),
              CustomeTextfield(
                placeHolder: "Email",
                isPassword: false,
                controller: _emcontroller,
              ),

              const SizedBox(height: 10,),

              CustomeTextfield(
                placeHolder: "password",
                isPassword: true ,
                controller: _pwcontroller,
              ),
              const SizedBox(height: 10,),

              CustomeTextfield(
                placeHolder: "confirm password",
                isPassword: true ,
                controller: _confirmpwcontroller,
              ),
              const SizedBox(height: 25,),
              CustomeButton(text:"Register",
              onTap: () => register(context),
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("already have an acount ? " , style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap ,
                    child: Text("Login now " , style: TextStyle(
                      fontWeight: FontWeight.bold ,
                      color: Theme.of(context).colorScheme.primary,
                    ),),
                  )
                ],
              )
            ],
        )),
    );
  }
}