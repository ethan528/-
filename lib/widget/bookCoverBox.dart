import 'package:flutter/material.dart';
import 'package:reading_buddy/model/Book.dart';
import 'package:reading_buddy/service/databaseSvc.dart';

class BookCoverBox extends StatefulWidget {
  final String name;
  final String imgUrl;
  final String bookKey;

  const BookCoverBox(
      {super.key,
      required this.name,
      required this.imgUrl,
      required this.bookKey});

  @override
  State<BookCoverBox> createState() => _BookCoverBoxState();
}

class _BookCoverBoxState extends State<BookCoverBox> {
  bool isHeartTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isHeartTapped = !isHeartTapped;

          if (isHeartTapped) {
            DatabaseSvc().writeDB(Book(
                name: widget.name,
                imgUrl: widget.imgUrl,
                bookKey: widget.bookKey));
          } else {
            DatabaseSvc().deleteDB(Book(
                name: widget.name,
                imgUrl: widget.imgUrl,
                bookKey: widget.bookKey));
          }
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: widget.imgUrl.isNotEmpty
                ? BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.imgUrl), fit: BoxFit.cover))
                : null,
            child: widget.imgUrl.isNotEmpty
                ? null
                : Center(
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: Icon(
                isHeartTapped ? Icons.favorite : Icons.favorite_border,
                color: isHeartTapped ? Colors.pink : Colors.grey,
                size: 30,
              ))
        ],
      ),
    );
  }
}
