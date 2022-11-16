class Book {
  final String? title;
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

  const Book({
    this.title,
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
  }) : assert(
          title != null && (isbn10 != null || isbn13 != null),
          'All key values cannot be null.',
        );

  factory Book.fromJson(final Map<String, dynamic> json) => Book(
        title: json['title'],
        subtitle: json['subtitle'],
        authors: json['authors'],
        publisher: json['publisher'],
        isbn10: json['isbn10'],
        isbn13: json['isbn13'],
        pages: json['pages'],
        year: json['year'],
        rating: json['rating'],
        desc: json['desc'],
        price: json['price'],
        image: json['image'],
        url: json['url'],
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
      );
}
