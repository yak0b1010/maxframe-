import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for current user
  User? get currentUser => _auth.currentUser;

  // Check if the user is an admin
  bool get isAdmin => currentUser?.email == 'admin@maxframe.com';

  // Stream for authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up a new user
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection('users').doc(currentUser?.uid).set({
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Log in an existing user
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Log out the current user
  Future<void> logout() async {
    await _auth.signOut();
  }
}