import 'package:flutter/material.dart';
import 'package:share/share.dart';

class CardPage extends StatelessWidget {
  final Map _cardData;

  CardPage(this._cardData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_cardData["name"]),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_cardData["imageUrl"] == null
                  ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT7GpbN3UDBr906iiXrTpK2veDQKZcDSbyvXQ&usqp=CAU"
                  : _cardData["imageUrl"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.blue,
      body: Center(
          child: Container(
              padding: EdgeInsets.all(50.0),
              child: Column(children: [
                Image.network(_cardData["imageUrl"] == null
                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT7GpbN3UDBr906iiXrTpK2veDQKZcDSbyvXQ&usqp=CAU"
                    : _cardData["imageUrl"]),
                Text(_cardData["text"],
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    )),
                Text(_cardData["type"],
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    )),
                Text(_cardData["setName"],
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    )),
                Text(_cardData["artist"],
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    )),
              ]))),
    );
  }
}
