import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );


    await _firestore.collection('users').doc(credential.user!.uid).set({
      'fullName': fullName,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'user',
    });
 


    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

Future<void> sendPasswordResetEmail(String email) async {
  await _auth.sendPasswordResetEmail(
    email: email,
  );
}

Future<void> signOut() async {
  await _auth.signOut();
}

User? get currentUser => _auth.currentUser;
}
