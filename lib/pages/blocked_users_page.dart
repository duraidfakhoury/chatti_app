import 'package:chatii_app/components/user_tile.dart';
import 'package:chatii_app/services/auth/auth_service.dart';
import 'package:chatii_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {

  BlockedUsersPage({super.key});


  final ChatService _chatService = ChatService() ; 
  final AuthService _authService = AuthService() ;  
 
  void showUnblokBox (BuildContext context , String userId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Unblock User") ,
        content: const Text("Are you sure you want to unblock this user ? "),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              _chatService.unBlockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("User UnBlocked!")));
            } , 
            child: const Text("UnBLock")),
        ],
      ),);
  }

  @override
  Widget build(BuildContext context) {

    final userId = _authService.getCurrentUser()!.uid; 

    return Scaffold(
      appBar: AppBar(title: const Text("BLOCKED USERS" ),
      backgroundColor:Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      ),
      body: StreamBuilder<List<Map<String,dynamic>>> (
        stream: _chatService.getBlockedUsers(userId) , 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading Blocked Users"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final blockedUsers = snapshot.data ??  [] ;

          if(blockedUsers.isEmpty){
            return 
              const Center(child: Text("No Blocked Users"),);
          }
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(text: user['email'] , onTap: () => showUnblokBox(context,user['uid']),);
            },);
        },) ,
    );
  }
}