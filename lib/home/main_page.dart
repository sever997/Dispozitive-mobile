import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_controller.dart';
import '../resources/resource_service.dart';
import '../resources/edit_resource_page.dart';
import '../resources/bookmark_service.dart';

class MainPage extends StatelessWidget {
  final ResourceService _resourceService = ResourceService();
  final BookmarkService _bookmarkService = BookmarkService();

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Resource Hub'),
        actions: [
          IconButton(
            onPressed: () async {
              await authController.signOut();
              context.go('/auth');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              context.go('/bookmarks');
            },
            tooltip: 'View Bookmarked Resources',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Resources',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _resourceService.fetchResources(), // Listen to db changes
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No resources available.'));
                  }

                  final resources = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: resources.length,
                    itemBuilder: (context, index) {
                      final resource = resources[index];

                      return FutureBuilder<bool>(
                        future: _bookmarkService.isBookmarked(resource.id),
                        builder: (context, bookmarkSnapshot) {
                          if (!bookmarkSnapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          final isBookmarked = bookmarkSnapshot.data ?? false;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                resource['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(resource['description']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: isBookmarked ? Colors.amber : null,
                                    ),
                                    tooltip: isBookmarked
                                        ? 'Remove Bookmark'
                                        : 'Add Bookmark',
                                    onPressed: () async {
                                      if (isBookmarked) {
                                        await _bookmarkService
                                            .removeBookmark(resource.id);
                                      } else {
                                        await _bookmarkService.addBookmark({
                                          'id': resource.id,
                                          'title': resource['title'],
                                          'description':
                                              resource['description'],
                                        });
                                      }
                                      (context as Element).markNeedsBuild();
                                    },
                                  ),
                                  if (authController.user?.uid ==
                                      resource['createdBy']) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      tooltip: 'Edit Resource',
                                      onPressed: () {
                                        context.push(
                                          '/edit-resource',
                                          extra: {
                                            'id': resource.id,
                                            'title': resource['title'],
                                            'description':
                                                resource['description'],
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Delete Resource',
                                      onPressed: () async {
                                        final confirmed = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text('Delete Resource'),
                                            content: const Text(
                                                'Are you sure you want to delete this resource?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmed == true) {
                                          await _resourceService
                                              .deleteResource(resource.id);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Resource deleted')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () {
                context.go('/stress-relief');
              },
              child: const Icon(Icons.mood),
              tooltip: 'Stress Relief Duck',
              heroTag: 'stress_relief',
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              context.go('/add-resource');
            },
            child: const Icon(Icons.add),
            tooltip: 'Add New Resource',
            heroTag: 'add_resource',
          ),
        ],
      ),
    );
  }
}
