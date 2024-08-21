import 'package:reading_buddy/model/Book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BookApi {
  static Future<List<Book>> getBookInformation(String keyword) async {
    var url =
        Uri.https('www.googleapis.com', 'books/v1/volumes', {'q': keyword});

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      final books = <Book>[];
      for (final item in jsonResponse['items'] as List) {
        final book = Book.fromJson(item);
        books.add(book);
      }
      return books;
    } else {
      throw Exception('Error');
    }
  }
}
