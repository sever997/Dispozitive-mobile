import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create
  Future<String> addTestData(
      String collection, Map<String, dynamic> data) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);
      print('Document added successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding document: $e');
      rethrow;
    }
  }

  // Read
  Future<List<Map<String, dynamic>>> getTestData(String collection) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collection).get();
      final documents = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Document ID: ${doc.id}');
        print('Document Data: $data');
        return {...data, 'id': doc.id};
      }).toList();
      return documents;
    } catch (e) {
      print('Error getting documents: $e');
      rethrow;
    }
  }

  // Update
  Future<void> updateTestData(
      String collection, String docId, Map<String, dynamic> newData) async {
    try {
      await _firestore.collection(collection).doc(docId).update(newData);
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  // Delete
  Future<void> deleteTestData(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
