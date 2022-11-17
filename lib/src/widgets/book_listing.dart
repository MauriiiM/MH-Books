import 'package:flutter/material.dart';
import 'package:mh_books/src/models/books.dart';
import 'package:intl/intl.dart';

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
    final locale = Localizations.localeOf(context);
    final currencyFormatter =
        NumberFormat.simpleCurrency(locale: locale.toString());

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
          book.title?.isNotEmpty == true ? book.title! : '[Untitled]',
          maxLines: 1,
        ),
        subtitle: book.subtitle == null
            ? null
            : Text(
                book.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
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