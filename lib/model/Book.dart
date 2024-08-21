import 'package:randomstring_dart/randomstring_dart.dart';

class Book {
  String name;
  String imgUrl;
  String bookKey;

  Book({required this.name, required this.imgUrl, required this.bookKey});

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final name = volumeInfo['title'] ?? '';
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final imgUrl = imageLinks['thumbnail'] ?? '';
    final rs = RandomString();
    String bookKey = rs.getRandomString();

    return Book(name: name, imgUrl: imgUrl, bookKey: bookKey);
  }

  static fromMap(Map<dynamic, dynamic> bookValue) {
    var name = bookValue['name'] ?? '';
    var imgUrl = bookValue['imgUrl'] ?? '';
    var bookKey = bookValue['bookKey'] ?? '';

    return Book(
      name: name,
      imgUrl: imgUrl,
      bookKey: bookKey,
    );
  }
}
