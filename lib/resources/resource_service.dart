import 'package:cloud_firestore/cloud_firestore.dart';
import 'bookmark_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResourceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BookmarkService _bookmarkService = BookmarkService();
  final CollectionReference _resources = FirebaseFirestore.instance.collection('resources');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new resource
  Future<void> addResource(
      String title, String description, String userId) async {
    try {
      await _resources.add({
        'title': title,
        'description': description,
        'createdBy': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding resource: $e');
      rethrow;
    }
  }

  // Fetch all resources
  Stream<QuerySnapshot> fetchResources() {
    String? userId = _auth.currentUser?.uid;
    return _resources
        .where('createdBy', isEqualTo: userId)
        .snapshots();
  }

  // Update a resource
  Future<void> updateResource(
      String id, String title, String description) async {
    try {
      await _resources.doc(id).update({
        'title': title,
        'description': description,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating resource: $e');
      rethrow;
    }
  }

  // Delete a resource (from db and bookmarks)
  Future<void> deleteResource(String id) async {
    try {
      await _resources.doc(id).delete();
      // Remove from bookmarks if it exists
      await _bookmarkService.removeBookmark(id);
    } catch (e) {
      print('Error deleting resource: $e');
      rethrow;
    }
  }
}
