import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/model/Book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prepareBookList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                alignment: Alignment.center,
                child: _buildBookList(context, books),
              )
            ],
          ),
        ),
      ),
    );
  }

  void prepareBookList() {
    for (int i = 0; i < 5; i++) {
      var book = Book();
      book.name = 'Book $i';
      book.imgUrl = 'https://picsum.photos/id/10$i/200/200';
      books.add(book);
    }
  }

  _buildBookList(BuildContext context, List<Book> books) {
    return CarouselSlider.builder(
        itemCount: books.length,
        itemBuilder: (context, index, realIndex) {
          return buildBookCard(books[index]);
        },
        options: CarouselOptions(
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          initialPage: 2,
          viewportFraction: 0.35,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          autoPlay: false,
        ));
  }

  buildBookCard(Book book) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(1.0)),
        child: Stack(
          children: [
            Image.network(
              book.imgUrl,
              fit: BoxFit.contain,
              width: 140.0,
            )
          ],
        ),
      ),
    );
  }
}
