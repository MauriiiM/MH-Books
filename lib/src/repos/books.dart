import 'dart:convert';

import 'package:mh_books/src/models/books.dart';
import 'package:http/http.dart' as http;

class BooksRepository {
  static Future<List<Book>> fetchNewBooks() async {
    final response =
        await http.get(Uri.parse('https://api.itbook.store/1.0/new'));

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

  // static Future> searchBooks({
  //   required final String titleQuery,
  // }) async {
  //   return [];
  // }
}
