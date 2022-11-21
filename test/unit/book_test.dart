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
  testBooksSerialization();
  testBooksController();
}

void testBooksSerialization() {}

void testBooksController() {
  group(
    'BooksController',
    () {
      late BooksController testingController;

      late MockBooksRepository mockBooksRepository;
      late ProviderContainer container;
      late Listener<AsyncValue<Iterable<Book>>> ctrlrProviderListener;
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

        ctrlrProviderListener = Listener<AsyncValue<Iterable<Book>>>();
        container = ProviderContainer(
          overrides: [
            booksRepositoryProvider.overrideWithValue(mockBooksRepository),
          ],
        )..listen(
            booksControllerProvider,
            ctrlrProviderListener,
            fireImmediately: true,
          );
        addTearDown(container.dispose);

        testingController = container.read(booksControllerProvider.notifier);
      });

      test(
        'Initial default values',
        () async {
          verifyInOrder([
            () => ctrlrProviderListener(
                  null,
                  const AsyncLoading<Iterable<Book>>(),
                ),
            () => ctrlrProviderListener(
                  const AsyncLoading<Iterable<Book>>(),
                  AsyncData(newBooksFromRepo),
                ),
          ]);
          verifyNoMoreInteractions(ctrlrProviderListener);
          verify(mockBooksRepository.fetchNewBooks).called(1);
          verifyNever(() => mockBooksRepository.searchBooks(any<String>()));
        },
      );

      test(
        '''
        .fetchNewBooks():
    sets state to AsyncLoading (with injected data from initial fetch)
    sets state to AsyncData with value [newBooks]
        ''',
        () async {
          registerFallbackValue(const AsyncLoading<Iterable<Book>>());

          await testingController.fetchNewBooks();
          verifyInOrder([
            () => ctrlrProviderListener(
                  null,
                  const AsyncLoading<Iterable<Book>>(),
                ),
            () => ctrlrProviderListener(
                  const AsyncLoading<Iterable<Book>>(),
                  AsyncData(newBooksFromRepo),
                ),
            () => ctrlrProviderListener(
                  AsyncData(newBooksFromRepo),
                  any(that: isA<AsyncLoading<Iterable<Book>>>()), // has value
                ),
            () => ctrlrProviderListener(
                  any(that: isA<AsyncLoading<Iterable<Book>>>()), // has value
                  AsyncData(newBooksFromRepo),
                ),
          ]);
          verifyNoMoreInteractions(ctrlrProviderListener);
          verify(mockBooksRepository.fetchNewBooks).called(2);
          verifyNever(() => mockBooksRepository.searchBooks(any<String>()));
        },
      );

      test(
        '''
        .searchBooks():
    sets state to AsyncLoading (with injected data from initial fetch)
    sets state to AsyncData with value [searchedBooks]
        ''',
        () async {
          final searchedBooksFromRepo = [
            const Book(title: 'Test 11', isbn10: '2345678901'),
            const Book(title: 'Test 21', isbn10: '3456789012'),
            const Book(title: 'Test 31', isbn13: '1234567890123'),
          ];
          when(() => mockBooksRepository.searchBooks(''))
              .thenAnswer((_) async => Future.value(searchedBooksFromRepo));
          registerFallbackValue(const AsyncLoading<Iterable<Book>>());

          await testingController.searchBooks('');
          verifyInOrder([
            () => ctrlrProviderListener(
                  null,
                  const AsyncLoading<Iterable<Book>>(),
                ),
            () => ctrlrProviderListener(
                  const AsyncLoading<Iterable<Book>>(),
                  AsyncData(newBooksFromRepo),
                ),
            () => ctrlrProviderListener(
                  AsyncData(newBooksFromRepo),
                  any(that: isA<AsyncLoading<Iterable<Book>>>()), // has value
                ),
            () => ctrlrProviderListener(
                  any(that: isA<AsyncLoading<Iterable<Book>>>()), // has value
                  AsyncData(searchedBooksFromRepo),
                ),
          ]);
          verifyNoMoreInteractions(ctrlrProviderListener);
          verify(mockBooksRepository.fetchNewBooks).called(1);
          verify(() => mockBooksRepository.searchBooks(any<String>()))
              .called(1);
        },
      );
    },
  );
}
