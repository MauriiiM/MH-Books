import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:mh_books/src/util/exceptions.dart';

class BooksRepository {
  static const _endpoint = 'https://api.itbook.store/1.0';

  /// Get new releases books.
  Future<List<Book>> fetchNewBooks() async {
    late final Response response;
    try {
      response = await http.get(Uri.parse('$_endpoint/new'));
    } catch (e) {
      throw FetchDataException('Failed to fetch new books.');
    }

    if (response.statusCode != 200) {
      throw BadResponseException(
          'Failed to fetch new books. ${response.reasonPhrase}');
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
  Future<List<Book>> searchBooks(
    final String query, {
    final String? page,
  }) async {
    late final Response response;
    try {
      response = await http.get(
          Uri.parse('$_endpoint/search/$query${page != null ? '/$page' : ''}'));
    } catch (e) {
      throw FetchDataException('Failed to fetch new books.');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to search books. ${response.reasonPhrase}');
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

final booksRepositoryProvider = Provider((ref) => BooksRepository());
