import 'package:chatii_app/services/auth/auth_service.dart';
import 'package:chatii_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                    color: Colors.transparent,  // Makes sure it's fully transparent
                    padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 100),
                    child: Center(
                      child: Icon(
                              Icons.message,
                              color: Theme.of(context).colorScheme.primary,
                              size: 40,
                            ),
                          ),
                       ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text(
                    "S E T T I G S",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>const SettingsPage())
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 15),
                child: ListTile(
                  title: Text(
                    "L O G O U T",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    final auth = AuthService();
                    auth.signOut();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
