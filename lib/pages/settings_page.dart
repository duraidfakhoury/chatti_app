import 'package:chatii_app/pages/blocked_users_page.dart';
import 'package:chatii_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("Settings" ),
      backgroundColor:Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)
              
                ),
                margin: const EdgeInsets.only(left : 25 , top: 10 , right: 25 ),
                padding: const EdgeInsets.only(left : 25 , right: 25 , top : 20 , bottom: 20 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text("Dark Mode : "),
                     CupertinoSwitch(
                      value:Provider.of<ThemeProvider>(context,listen: false).isDarkMode,
                      onChanged: (value)=> Provider.of<ThemeProvider>(context,listen: false).toggleTheme())
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12)
              
                ),
                margin: const EdgeInsets.only(left : 25 , top: 10 , right: 25 ),
                padding: const EdgeInsets.only(left : 25 , right: 25 , top : 20 , bottom: 20 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text("Bloked Users: "),
                     IconButton(onPressed: () => 
                          Navigator.push(context , MaterialPageRoute(
                            builder: (context) =>  BlockedUsersPage(),)), 
                            icon: const Icon(Icons.arrow_forward_rounded))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}