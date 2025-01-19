import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bookmark_service.dart';

class BookmarksPage extends StatelessWidget {
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/main');
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookmarkService.getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookmarks yet.'));
          }

          final bookmarks = snapshot.data!;

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text(bookmark['title']),
                subtitle: Text(bookmark['description']),
              );
            },
          );
        },
      ),
    );
  }
}
