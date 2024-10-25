import 'package:chatii_app/services/auth/auth_service.dart';
import 'package:chatii_app/components/custome_button.dart';
import 'package:chatii_app/components/custome_textField.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{

  final void Function()? onTap ; 

  final TextEditingController _emcontroller = TextEditingController() ; 
  final TextEditingController _pwcontroller  = TextEditingController();

  void logIn(BuildContext context) async {

    final authService = AuthService();

    try{
      await authService.signInWithEmailPassword(_emcontroller.text, _pwcontroller.text);
    }
    catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(context: context,
       builder: (context)=> AlertDialog(
        title: const Text("error while signing in "),
        content: Text(e.toString()),
       ));
    }

  }

  LoginPage({super.key , required this.onTap});

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
              Text("Wlcome back , You have been missed " ,
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
              const SizedBox(height: 25,),
              CustomeButton(text:"log In",
              onTap:() => logIn(context),
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("not a member ? " , style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap ,
                    child: Text("Register now " , style: TextStyle(
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