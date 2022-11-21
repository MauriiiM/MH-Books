import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mh_books/src/models/book.dart';
import 'package:mh_books/src/repos/books.dart';
import 'package:mh_books/src/controllers/books.dart';
import 'package:mocktail/mocktail.dart';

class MockBooksRepository extends Mock implements BooksRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  late BooksController testingController;
  late MockBooksRepository mockBooksRepository;
  late ProviderContainer container;
  late Listener<AsyncValue<Iterable<Book>>> ctrlrProviderListener;
  final booksFromRepo = [
    const Book(title: 'Test 1', isbn10: '0123456789'),
    const Book(title: 'Test 2', isbn10: '1234567890'),
    const Book(title: 'Test 3', isbn13: '0123456789012'),
  ];

// returns an overwrite to expected [booksRepositoryProvider]
  ProviderContainer makeProviderContainer(
    MockBooksRepository mockBooksRepository,
  ) {
    final container = ProviderContainer(
      overrides: [
        booksRepositoryProvider.overrideWithValue(mockBooksRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  void mockRepoFetchBookReturnsBooksFromRepo() =>
      when(mockBooksRepository.fetchNewBooks)
          .thenAnswer((_) async => Future.value(booksFromRepo));

  setUp(() {
    mockBooksRepository = MockBooksRepository();
    mockRepoFetchBookReturnsBooksFromRepo();

    ctrlrProviderListener = Listener<AsyncValue<Iterable<Book>>>();
    container = makeProviderContainer(mockBooksRepository)
      ..listen(
        booksControllerProvider,
        ctrlrProviderListener,
        fireImmediately: true,
      );
    testingController = container.read(booksControllerProvider.notifier);

    registerFallbackValue(const AsyncLoading<Iterable<Book>>());
  });

  test(
    'Initial default values for BooksController',
    () async {
      verifyInOrder([
        () => ctrlrProviderListener(null, const AsyncLoading<Iterable<Book>>()),
        () => ctrlrProviderListener(
              const AsyncLoading<Iterable<Book>>(),
              AsyncData(booksFromRepo),
            ),
      ]);
      verifyNoMoreInteractions(ctrlrProviderListener);
      verify(mockBooksRepository.fetchNewBooks).called(1);
      verifyNever(mockBooksRepository.searchBooks);
    },
  );

  group(
    'BooksController.getNewBooks()',
    () {
      test(
        'Initializes controller; gets new books using BooksRepository',
        () async {
          await testingController.fetchNewBooks();
          verifyInOrder([
            () => ctrlrProviderListener(
                  null,
                  const AsyncLoading<Iterable<Book>>(),
                ),
            () => ctrlrProviderListener(
                  const AsyncLoading<Iterable<Book>>(),
                  AsyncData(booksFromRepo),
                ),
            () => ctrlrProviderListener(
                  AsyncData(booksFromRepo),
                  any(that: isA<AsyncLoading<Iterable<Book>>>()), // has value
                ),
            () => ctrlrProviderListener(
                  any(that: isA<AsyncLoading<Iterable<Book>>>()), // has value
                  AsyncData(booksFromRepo),
                ),
          ]);
          verifyNoMoreInteractions(ctrlrProviderListener);
          verify(mockBooksRepository.fetchNewBooks).called(2);
        },
      );

      //     test(
      //       '''Indicates fetching of data;
      // sets books to the ones from repo;
      // indicates not fetching''',
      //       () async {
      //         final future = testing.fetchNewBooks();
      //         expect(testing.debugState.isFetching, true);
      //         await future;
      //         expect(testing.debugState.books, booksFromRepo);
      //         expect(testing.debugState.isFetching, false);
      //       },
      //     );
    },
  );
}
