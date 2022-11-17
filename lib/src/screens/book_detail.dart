import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (book.image != null)
              Image.network(
                book.image!,
                errorBuilder: (context, error, _) =>
                    const Icon(Icons.library_books),
              ),
            Text(book.title),
            if (book.subtitle != null) Text(book.subtitle!),
            if (book.authors != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('authors'),
                  Text(book.authors!),
                ],
              ),
            if (book.rating != null) Text('${book.rating!}/5'),
            if (book.price != null) Text(book.price!),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  if (book.publisher != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('publisher'),
                        Text(book.publisher!),
                      ],
                    ),
                  if (book.isbn10 != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('isbn10'),
                        Text(book.isbn10!),
                      ],
                    ),
                  if (book.isbn13 != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('isbn13'),
                        Text(book.isbn13!),
                      ],
                    ),
                  if (book.pages != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('pages'),
                        Text('${book.pages!}'),
                      ],
                    ),
                  if (book.year != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('year'),
                        Text(book.year!),
                      ],
                    ),
                  if (book.pdfs?.isNotEmpty == true) ...[
                    ...book.pdfs!.entries.map(
                      (pdf) => TextButton(
                        onPressed: () {
                          try {
                            launchUrl(Uri(path: pdf.value));
                          } on Exception catch (_) {
                            log('Error launching pdf');
                          }
                        },
                        child: Text(pdf.key),
                      ),
                    )
                  ],
                ],
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
