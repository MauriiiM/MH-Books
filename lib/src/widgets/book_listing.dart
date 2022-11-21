import 'package:flutter/material.dart';
import 'package:mh_books/src/models/book.dart';

class BookListing extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookListing(
    this.book, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = book.image;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        onTap: onTap,
        leading: image == null || image.isEmpty
            ? const Icon(Icons.library_books)
            : Image.network(
                image,
                errorBuilder: (context, error, _) =>
                    const Icon(Icons.library_books),
              ),
        title: Text(
          book.title.isNotEmpty ? book.title : '[Untitled]',
          maxLines: 2,
        ),
        subtitle: (book.authors ?? book.subtitle) == null
            ? null
            : Text(
                (book.authors ?? book.subtitle)!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: book.price == null
            ? null
            : Text(
                // currencyFormatter.format(book.price!),
                book.price!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
