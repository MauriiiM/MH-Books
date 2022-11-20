import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mh_books/src/repos/books.dart';

import '../models/book.dart';

class BooksController extends AsyncNotifier<Iterable<Book>> {
  Future<void> fetchNewBooks() async {
    final booksRepo = ref.read(booksRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(booksRepo.fetchNewBooks);
  }

  Future<void> searchBooks() async {
    final booksRepo = ref.read(booksRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(booksRepo.searchBooks);
  }

  @override
  FutureOr<Iterable<Book>> build() async {
    final booksRepo = ref.read(booksRepositoryProvider);
    return booksRepo.fetchNewBooks();
  }
}

final booksControllerProvider =
    AsyncNotifierProvider<BooksController, Iterable<Book>>(BooksController.new);
