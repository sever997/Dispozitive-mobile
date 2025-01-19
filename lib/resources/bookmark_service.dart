import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _bookmarksKey = 'bookmarked_resources';

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarksJson = prefs.getString(_bookmarksKey);
    if (bookmarksJson == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(bookmarksJson));
  }

  Future<void> addBookmark(Map<String, dynamic> resource) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.add(resource);
    await prefs.setString(_bookmarksKey, json.encode(bookmarks));
  }

  Future<void> removeBookmark(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((resource) => resource['id'] == id);
    await prefs.setString(_bookmarksKey, json.encode(bookmarks));
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((resource) => resource['id'] == id);
  }
}
