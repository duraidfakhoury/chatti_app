import 'package:chatii_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final String message ; 
  final bool isCuurentUser ; 
  final String messageId ;
  final String userId ; 
  const ChatBubble({
    super.key, 
    required this.message, 
    required this.isCuurentUser, 
    required this.messageId, 
    required this.userId});

  void showOptions (BuildContext context , String userID , String messageID){
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return SafeArea(child: Wrap(
          children: [
            //report message button 
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text("Report"),
              onTap: () {
                Navigator.pop(context);
                reportContent(context , messageID , userID);
              },
            ),
            //block user button 
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text("Block"),
              onTap: () {
                Navigator.pop(context);
                blockUser(context, userID);
              },
            ),
            //cancel button 
              ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
      },);
  }

  void reportContent(BuildContext context , String messageID , String userID ){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Message "),
        content: const Text("Are you sure you want to report thid message ? "),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              
              ChatService().reportUser(messageID, userID);
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Message Reported")));
            } , 
            child: const Text("Report")),
        ],
      ),);
  }
  void blockUser(BuildContext context , String userID ){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content: const Text("Are you sure you want to block this user ? "),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              ChatService().blockUser(userID);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("User Blocked!")));
            } , 
            child: const Text("Block")),
        ],
      ),);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if(!isCuurentUser){
            showOptions(context, userId , messageId);
        }
      },
      child : Container(
      decoration: BoxDecoration(
        color: isCuurentUser ? Colors.lightBlue : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12)
      ),
      padding:const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 25 , vertical: 5),
      
      
      child: Text(message , style: const TextStyle(color:  Colors.white),),
      )
    );
  }
}