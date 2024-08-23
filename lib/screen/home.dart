import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/model/Book.dart';
import 'package:reading_buddy/screen/login.dart';
import 'package:reading_buddy/service/databaseSvc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    prepareBookList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                      }).onError((error, stackTrace) {
                        print('logout failed $error');
                      });
                    },
                    icon: const Icon(
                      Icons.logout,
                    ),
                  ),
                ],
              ),
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

  void updateUIWithBooks(List<Book> newBooks) {
    if (mounted) {
      setState(() {
        books = newBooks;
      });
    }
  }

  void prepareBookList() {
    DatabaseSvc().readDB(updateUIWithBooks);

    // for (int i = 0; i < 5; i++) {
    //   var name = 'Book $i';
    //   var imgUrl = 'https://picsum.photos/id/10$i/200/200';
    //   var book = Book(name: name, imgUrl: imgUrl);
    //
    //   books.add(book);
    // }
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
