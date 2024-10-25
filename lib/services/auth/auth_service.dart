import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  //instance of auth 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth  _auth = FirebaseAuth.instance;

  User? getCurrentUser () {
    return _auth.currentUser;
  }

  //sign in 
  Future<UserCredential> signInWithEmailPassword (String email , String password ) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {'uid':userCredential.user!.uid , 'email' : email}
      );
      return userCredential;
    }on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //signUp
  Future<UserCredential> signUpWithEmailPassword (String email , String password) async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password);
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {'uid':userCredential.user!.uid , 'email' : email}
      );
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }



  //signout 
  Future <void> signOut(){
    return _auth.signOut();
  } 
}