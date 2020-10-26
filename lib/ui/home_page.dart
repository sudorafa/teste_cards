import 'dart:convert';

import 'package:teste_cards/ui/card_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getCards() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(
          "https://api.magicthegathering.io/v1/cards?page=$_offset&pageSize=29&contains=imageUrl");
    else
      response = await http.get(
          "https://api.magicthegathering.io/v1/cards?page=$_offset&pageSize=29&contains=imageUrl&name=$_search");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Image.network(
            "https://i.pinimg.com/originals/87/a8/99/87a899120826d2ae2869d6e2d94a69b5.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getCards(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createCardTable(context, snapshot);
                  }
                }),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createCardTable(BuildContext context, AsyncSnapshot snapshot) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 18) / 2;
    final double itemWidth = size.width / 2;

    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / itemHeight)),
        itemCount: _getCount(snapshot.data["cards"]),
        itemBuilder: (context, index) {
          if (index < snapshot.data["cards"].length) {
            return Container(
              child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 0.8,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data["cards"][index]["imageUrl"] ==
                                  null
                              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT7GpbN3UDBr906iiXrTpK2veDQKZcDSbyvXQ&usqp=CAU"
                              : snapshot.data["cards"][index]["imageUrl"],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(snapshot.data["cards"][index]["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  )),
                              Text(snapshot.data["cards"][index]["type"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                              Text(snapshot.data["cards"][index]["setName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white,
                                  )),
                              Text(snapshot.data["cards"][index]["artist"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white,
                                  )),
                              for (var color in snapshot.data["cards"][index]
                                  ["colors"])
                                Text(color,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CardPage(snapshot.data["cards"][index])));
                  },
                  onLongPress: () {
                    Share.share(snapshot.data["cards"][index]["imageUrl"] ==
                            null
                        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT7GpbN3UDBr906iiXrTpK2veDQKZcDSbyvXQ&usqp=CAU"
                        : snapshot.data["cards"][index]["imageUrl"]);
                  }),
            );
          } else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70.0,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 29;
                  });
                },
              ),
            );
        });
  }
}
