import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods
  Future<User?> signupWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Cloud Firestore methods with auto-increment ID
  Future<int> _getNextId() async {
    DocumentReference idDoc = _firestore.collection('metadata').doc('counter');
    DocumentSnapshot snapshot = await idDoc.get();

    if (!snapshot.exists) {
      await idDoc.set({'currentId': 1199});
      return 1200;
    } else {
      int currentId = snapshot['currentId'];
      return currentId + 1;
    }
  }

  Future<void> _updateId(int newId) async {
    DocumentReference idDoc = _firestore.collection('metadata').doc('counter');
    await idDoc.update({'currentId': newId});
  }

  Future<void> addUserDocumentWithAutoIncrementId(
      String userId, Map<String, dynamic> data) async {
    try {
      int newId = await _getNextId();
      data['id'] = newId;

      await _firestore.collection('users').doc(userId).set(data);
      await _updateId(newId);

      print('User document added with auto-increment ID: $newId');
    } catch (e) {
      print('Error adding user document: $e');
    }
  }

  // Public method to get the next ID
  Future<int> getNextUserId() async {
    return await _getNextId();
  }

  // Method to get a specific document by ID
  Future<Map<String, dynamic>?> getUserDocument(String documentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(documentId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        print('No such document!');
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }
}
