import 'package:chatii_app/components/custome_drawer.dart';
import 'package:chatii_app/components/user_tile.dart';
import 'package:chatii_app/pages/chat_page.dart';
import 'package:chatii_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.transparent ,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("C H A T S", ),
      ),
      drawer: const CustomDrawer(),
      body: _bildUserList(),
    );
  }

  Widget _bildUserList () {
    return StreamBuilder(
      stream: _chatService.getUserStreamExcludingBlocked(), 
      builder: (context,snapshot){
        if (snapshot.hasError) {
        return const Center(child: Text("Error loading Chats"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
        ); 
      });
  }

  Widget _buildUserListItem (Map<String , dynamic> userData , BuildContext context) {
  return UserTile(
    text: userData['email'],
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: 
      (context)=> ChatPage(reciverEmail: userData['email'],reciverId: userData["uid"],)
      ));
    },
  );
}
}


