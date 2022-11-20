import 'package:flutter/cupertino.dart';

@immutable
class Book implements Comparable<Book> {
  final String title;
  final String? subtitle;
  final String? authors;
  final String? publisher;
  final String? isbn10;
  final String? isbn13;
  final int? pages;
  final String? year;
  final double? rating;
  final String? desc;
  final String? price;
  final String? image;
  final String? url;
  final Map<String, String>? pdfs;

  const Book({
    required this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.isbn10,
    this.isbn13,
    this.pages,
    this.year,
    this.rating,
    this.desc,
    this.price,
    this.image,
    this.url,
    this.pdfs,
  }) : assert(
          (isbn10 != null && isbn10.length == 10) ||
              (isbn13 != null && isbn13.length == 13),
          'All key values cannot be null.',
        );

  factory Book.fromJson(final Map<String, dynamic> json) => Book(
        title: json['title'],
        subtitle: json['subtitle'],
        authors: json['authors'],
        publisher: json['publisher'],
        isbn10: json['isbn10'],
        isbn13: json['isbn13'],
        pages: json['pages'] == null ? null : int.tryParse(json['pages']),
        year: json['year'],
        rating: json['rating'] == null ? null : double.tryParse(json['rating']),
        desc: json['desc'],
        price: json['price'],
        image: json['image'],
        url: json['url'],
        pdfs: json['pdf'],
      );

  Book copyWith({
    String? title,
    String? subtitle,
    String? authors,
    String? publisher,
    String? isbn10,
    String? isbn13,
    int? pages,
    String? year,
    double? rating,
    String? desc,
    String? price,
    String? image,
    String? url,
    Map<String, String>? pdfs,
  }) =>
      Book(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        authors: authors ?? this.authors,
        publisher: publisher ?? this.publisher,
        isbn10: isbn10 ?? this.isbn10,
        isbn13: isbn13 ?? this.isbn13,
        pages: pages ?? this.pages,
        year: year ?? this.year,
        rating: rating ?? this.rating,
        desc: desc ?? this.desc,
        price: price ?? this.price,
        image: image ?? this.image,
        url: url ?? this.url,
        pdfs: pdfs ?? this.pdfs,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && (isbn10 == other.isbn10 || isbn13 == other.isbn13);

  @override
  int get hashCode =>
      title.hashCode ^ subtitle.hashCode ^ isbn10.hashCode ^ isbn13.hashCode;

  @override
  int compareTo(Book other) {
    final titleComp = title.compareTo(other.title);
    if (titleComp == 0) {
      final subtitleComp = (subtitle ?? '').compareTo(other.subtitle ?? '');
      if (subtitleComp != 0) {
        return subtitleComp;
      }

      final authorsComp = (authors ?? '').compareTo(other.authors ?? '');
      if (authorsComp != 0) {
        return authorsComp;
      }
    }

    return titleComp;
  }
}
