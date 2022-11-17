import 'dart:convert';

import 'package:mh_books/src/models/book.dart';
import 'package:http/http.dart' as http;

class BooksRepository {
  static const api = 'https://api.itbook.store/1.0';

  /// Get new releases books.
  static Future<List<Book>> fetchNewBooks() async {
    final response = await http.get(Uri.parse('$api/new'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch new books');
    }

    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse is! Map<String, dynamic>) {
      throw const FormatException();
    }

    final responseBooks = decodedResponse['books'];
    if (responseBooks is! List) {
      throw const FormatException();
    }

    return responseBooks.map((bookJson) => Book.fromJson(bookJson)).toList();
  }

  /// Search books by title, author, ISBN or keywords. Formatted as:
  /// `/search/{query}`
  /// `/search/{query}/{page}`
  static Future<List<Book>> searchBooks({
    final String? query,
    final String? page,
  }) async {
    final response =
        await http.get(Uri.parse('$api/search${page != null ? '/$page' : ''}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch new books');
    }

    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse is! Map<String, dynamic>) {
      throw const FormatException();
    }

    final responseBooks = decodedResponse['books'];
    if (responseBooks is! List) {
      throw const FormatException();
    }

    return responseBooks.map((bookJson) => Book.fromJson(bookJson)).toList();
  }
}
