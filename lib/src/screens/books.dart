import 'package:flutter/material.dart';
import 'package:mh_books/src/models/books.dart';
import 'package:mh_books/src/repos/books.dart';
import 'package:mh_books/src/widgets/book_listing.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  static const title = 'Books';
  late Future<List<Book>> booksFuture;

  void initState() {
    booksFuture = BooksRepository.fetchNewBooks();
  }

  // @override
  // void didChangeDependencies() {
  //   books = BookProvider.of(context);
  //   super.didChangeDependencies();
  // }

  Iterable<Widget> bookListings(List<Book> books) =>
      books.map((c) => BookListing(
            c,
            onTap: () => null,
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [],
      ),
      body: FutureBuilder<List<Book>>(
        future: booksFuture,
        builder: (final context, final snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final books = snapshot.data!;
            return books.isEmpty
                ? const Center(
                    child: Text('There are no books to display.'),
                  )
                : Scrollbar(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: bookListings(books).toList(),
                    ),
                  );
          }

          return const Center(
            child: Text(
              'There was an error loading the books.',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
