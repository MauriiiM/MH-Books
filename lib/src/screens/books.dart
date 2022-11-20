import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:mh_books/src/screens/book_detail.dart';
import 'package:mh_books/src/controllers/books.dart';
import 'package:mh_books/src/widgets/book_listing.dart';

class BooksScreen extends ConsumerWidget {
  static const title = 'Books';

  const BooksScreen({super.key});

  Iterable<Widget> bookListings(
    Iterable<Book> books, {
    required BuildContext context,
  }) =>
      books.map((b) => BookListing(
            b,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(book: b),
              ),
            ),
          ));

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ref.watch(booksControllerProvider).when(
              data: (books) => books.isEmpty
                  ? const Center(
                      child: Text('There are no books to display.'),
                    )
                  : Scrollbar(
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: bookListings(
                          books,
                          context: context,
                        ).toList(),
                      ),
                    ),
              error: (object, stackTrace) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'There was an error loading the books.',
                      style: TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () => ref
                          .watch(booksControllerProvider.notifier)
                          .fetchNewBooks(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      );
}
