import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:mh_books/src/repos/books.dart';

final newBooksProvider = FutureProvider<Iterable<Book>>(
    (ref) async => BooksRepository.fetchNewBooks());

final searchedBooksProvider = FutureProvider<Iterable<Book>>(
    (ref) async => BooksRepository.searchBooks());

final selectedBookProvider = StateProvider.autoDispose<Book?>((ref) => null);
