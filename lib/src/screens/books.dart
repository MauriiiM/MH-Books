import 'package:flutter/material.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:mh_books/src/repos/books.dart';
import 'package:mh_books/src/screens/book_detail.dart';
import 'package:mh_books/src/widgets/book_listing.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  static const title = 'Books';
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    booksFuture = BooksRepository.fetchNewBooks();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   books = BookProvider.of(context);
  //   super.didChangeDependencies();
  // }

  Iterable<Widget> bookListings(List<Book> books) =>
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: FutureBuilder<List<Book>>(
        future: booksFuture,
        builder: (final context, final snapshot) {
          if (snapshot.hasData) {
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
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const Text(
                    'There was an error loading the books.',
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      booksFuture = BooksRepository.fetchNewBooks();
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
