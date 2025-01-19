import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_test.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _authStatus;
  String? _firestoreStatus;
  String? _lastDocumentId;

  Future<void> _signIn() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _authStatus = 'Signed in: ${userCredential.user?.email}';
      });
    } catch (e) {
      setState(() {
        _authStatus = 'Error: $e';
      });
    }
  }

  Future<void> _testFirestoreCreate() async {
    try {
      final docId = await _firestoreService.addTestData('test_collection', {
        'name': 'Test Item',
        'timestamp': DateTime.now().toString(),
      });
      setState(() {
        _lastDocumentId = docId;
        _firestoreStatus = 'Document created successfully. ID: $docId';
      });
    } catch (e) {
      setState(() {
        _firestoreStatus = 'Create error: $e';
      });
    }
  }

  Future<void> _testFirestoreRead() async {
    try {
      final data = await _firestoreService.getTestData('test_collection');
      setState(() {
        _firestoreStatus = 'Documents retrieved: ${data.length}';
      });
    } catch (e) {
      setState(() {
        _firestoreStatus = 'Read error: $e';
      });
    }
  }

  Future<void> _testFirestoreUpdate() async {
    if (_lastDocumentId == null) {
      setState(() {
        _firestoreStatus = 'No document to update. Create one first.';
      });
      return;
    }

    try {
      await _firestoreService.updateTestData(
        'test_collection',
        _lastDocumentId!,
        {
          'name': 'Updated Test Item',
          'updated_at': DateTime.now().toString(),
        },
      );
      setState(() {
        _firestoreStatus = 'Document updated successfully';
      });
    } catch (e) {
      setState(() {
        _firestoreStatus = 'Update error: $e';
      });
    }
  }

  Future<void> _testFirestoreDelete() async {
    if (_lastDocumentId == null) {
      setState(() {
        _firestoreStatus = 'No document to delete. Create one first.';
      });
      return;
    }

    try {
      await _firestoreService.deleteTestData('test_collection', _lastDocumentId!);
      setState(() {
        _firestoreStatus = 'Document deleted successfully';
        _lastDocumentId = null;
      });
    } catch (e) {
      setState(() {
        _firestoreStatus = 'Delete error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Operations Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Authentication Section
            const Text(
              'Authentication',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
            if (_authStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_authStatus!),
              ),

            const SizedBox(height: 32),

            // Firestore Section
            const Text(
              'Firestore Operations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testFirestoreCreate,
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  onPressed: _testFirestoreRead,
                  child: const Text('Read'),
                ),
                ElevatedButton(
                  onPressed: _testFirestoreUpdate,
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _testFirestoreDelete,
                  child: const Text('Delete'),
                ),
              ],
            ),
            if (_firestoreStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_firestoreStatus!),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 