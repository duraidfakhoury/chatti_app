import 'package:chatii_app/components/chat_bubble.dart';
import 'package:chatii_app/components/custome_textfield.dart';
import 'package:chatii_app/services/auth/auth_service.dart';
import 'package:chatii_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {  

  final String reciverEmail ; 
  final String reciverId ; 
  const ChatPage({super.key , required this.reciverEmail, required this.reciverId});
  
  @override
  State<ChatPage> createState() => _ChatPageState();
  }

  class _ChatPageState extends State<ChatPage>{
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService(); 

  FocusNode myFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();

    myFocusNode.addListener( (){
      if(myFocusNode.hasFocus){
        Future.delayed(const Duration(milliseconds: 500),()=>scrollDown());
      }
    });
  } 

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown () {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn);
  }

  void sendMessage ()async {
    if(_messageController.text.isNotEmpty){
     await _chatService.sendMessage(widget.reciverId, _messageController.text);
     _messageController.clear();

    }
    scrollDown();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor:Colors.transparent ,
        title: Text(widget.reciverEmail ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),

        ],
      ),
    );
  }

    Widget _buildMessageList() {
  final senderId = _authService.getCurrentUser()!.uid;
  return StreamBuilder(
    stream: _chatService.getMasseges(widget.reciverId, senderId),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text("Error loading messages"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // Scroll down after messages are loaded
      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollDown(); // Ensure this is called after the frame is rendered
        });
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No messages yet."));
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.data!.docs[index];
          return _buildMessageItem(doc);
        },
      );
    },
  );
}


  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic> data = doc.data() as Map <String,dynamic>;
    bool isCuurentUser = data['senderId']==_authService.getCurrentUser()!.uid;
    var aligment = isCuurentUser ? Alignment.centerRight : Alignment.bottomLeft;
    return Container(
      alignment: aligment,
      child: ChatBubble(message: data['message'], isCuurentUser: isCuurentUser ,messageId: doc.id , userId: data["senderId"]));
  }

  Widget _buildUserInput () {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          Expanded(child: CustomeTextfield(
                focusNode: myFocusNode,
                placeHolder: "type a message ..", 
                isPassword: false, 
                controller: _messageController
              )
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(50)
              ),
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(onPressed: sendMessage, icon:const Icon(Icons.send,
              color: Colors.white,
              )))
        ],
      ),
    );
  }
  
  }
   
  


