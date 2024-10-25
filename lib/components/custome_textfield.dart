import 'package:flutter/material.dart';


class CustomeTextfield extends StatelessWidget {

  final String placeHolder ; 
  final bool isPassword ; 
  final TextEditingController controller ; 
  final FocusNode? focusNode ; 
  const CustomeTextfield({
    super.key ,
    required this.placeHolder , 
    required this.isPassword , 
    required this.controller ,
    this.focusNode,
    });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  25),
      child: TextField(
        focusNode: focusNode,
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true , 
          hintText: placeHolder,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          )
        ),
      
      ),
    );

  }
}