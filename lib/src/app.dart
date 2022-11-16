import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mh_books/src/screens/books.dart';

class MHBooks extends StatelessWidget {
  const MHBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      home: BooksScreen(),
    );
  }
}
