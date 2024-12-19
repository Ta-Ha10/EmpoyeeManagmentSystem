import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods remain unchanged

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

  Future<void> addDocumentWithAutoIncrementId(
      String collectionName, Map<String, dynamic> data) async {
    try {
      int newId = await _getNextId();
      data['id'] = newId;

      await _firestore
          .collection(collectionName)
          .doc(newId.toString())
          .set(data);
      await _updateId(newId);

      print('Document added with ID: $newId');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<Map<String, dynamic>?> getDocument(
      String collectionName, String documentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionName).doc(documentId).get();
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

  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
