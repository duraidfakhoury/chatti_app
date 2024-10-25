import 'package:chatii_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService  extends ChangeNotifier {

  final  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance ; 
  // get list of all users 
  Stream<List<Map<String,dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs
      .where((doc) =>  doc.data()['email'] != _auth.currentUser!.email)
      .map((doc) => doc.data()).toList();
    });
  }
  
  // get list off all users except blocked users 

  Stream<List<Map<String,dynamic>>> getUserStreamExcludingBlocked () {
    final currentUser  = _auth.currentUser;

    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          final blockedUsersIds = snapshot.docs.map((doc)=> doc.id).toList();

          final usersSnapshot = await _firestore.collection("Users").get();

          return usersSnapshot.docs
              .where((doc) => doc.data()['email'] != currentUser.email && !blockedUsersIds.contains(doc.id))
              .map((doc) => doc.data())
              .toList(); 
        });

  }

  //send a message 
  Future<void> sendMessage(String reciverId , message ) async {
    //get user info 
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    
    //create message 

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail, 
      reciverId: reciverId, 
      message: message, 
      timestamp: timestamp);
  
    List<String> ids = [currentUserId,reciverId];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .add(newMessage
    .toMap());
  }
  //get messages
  Stream<QuerySnapshot> getMasseges(String userID , otherUserID) {
    List<String> id = [userID,otherUserID];
    id.sort();
    String chatRoomID = id.join('_');

    return _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .orderBy("timestamp",descending: false)
    .snapshots();
  }
  //report user 
  Future<void> reportUser(String messageID , String userID) async {
    final currentUser = _auth.currentUser; 
    final report = {
      'reportedBy' : currentUser!.uid,
      'messageId' : messageID , 
      'messageOwnerId' : userID , 
      'timestamp' : FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }
  //block user 
  Future<void> blockUser(String userID ) async{
    final currentUser = _auth.currentUser;
    
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userID)
        .set({});
    notifyListeners();
  }
  //unblock user 
  Future<void> unBlockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
    notifyListeners();
  }
  //get blocked users
    Stream<List<Map<String,dynamic>>> getBlockedUsers(String userID) {
    return _firestore
        .collection("Users")
        .doc(userID)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          final blockedUsersIds = snapshot.docs.map((doc)=> doc.id).toList();
          final userDocs = await Future.wait(
            blockedUsersIds
                        .map((id) => _firestore.collection("Users").doc(id).get())
          );
          return userDocs.map((doc) => doc.data() as Map<String,dynamic>).toList(); 
        });
  }
}