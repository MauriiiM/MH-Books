// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_books/src/app.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:mh_books/src/repos/books.dart';
import 'package:mh_books/src/widgets/book_listing.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

void main() {
  late BooksRepository mockBooksRepository;
  final newBooksFromRepo = [
    const Book(title: 'Test 10', isbn10: '0123456789'),
    const Book(title: 'Test 20', isbn10: '1234567890'),
    const Book(title: 'Test 30', isbn13: '0123456789012'),
  ];

  void mockRepoFetchNewBooksReturnsBooksFromRepo() =>
      when(mockBooksRepository.fetchNewBooks)
          .thenAnswer((_) async => Future.value(newBooksFromRepo));

  setUp(() {
    mockBooksRepository = MockBooksRepository();
    mockRepoFetchNewBooksReturnsBooksFromRepo();
  });

  testWidgets('App opens to [CircularProgressIndicator]',
      (WidgetTester tester) async {
    await tester.pumpWidget(UncontrolledProviderScope(
      container: ProviderContainer(
        overrides: [
          booksRepositoryProvider.overrideWithValue(mockBooksRepository),
        ],
      ),
      child: const MHBooks(),
    ));
    expect(find.byWidget(const Scaffold()), findsOneWidget);

    // await tester.pumpAndSettle(const Duration(seconds: 3));
    // expect(find.byType(BookListing), findsWidgets);

    // await tester.tap(find.byType(BookListing));
    // await tester.pump();
    // expect(find.text('1'), findsOneWidget);
  });
}
