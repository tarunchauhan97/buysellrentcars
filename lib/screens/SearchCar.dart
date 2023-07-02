import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellbuyrentcar/screens/HomeScreen.dart';
import 'package:sellbuyrentcar/screens/profileScreen.dart';
import 'package:timeago/timeago.dart' as tAgo;

class SearchCar extends StatefulWidget {
  const SearchCar({Key? key}) : super(key: key);

  @override
  _SearchCarState createState() => _SearchCarState();
}

class _SearchCarState extends State<SearchCar> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  String? carModel;
  String? carColor;
  QuerySnapshot? cars;

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search here...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null || _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  _startSearch() {
    ModalRoute.of(context)?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  updateSearchQuery(String newQuery) {
    setState(() {
      getResults();
      searchQuery = newQuery;
    });
  }

  _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  _buildTitle(BuildContext context) {
    return Text("Search Car");
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () {
        Route newRoute = MaterialPageRoute(builder: (_) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      },
      icon: Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  getResults() {
    FirebaseFirestore.instance
        .collection('cars')
        .where("carModel", isGreaterThanOrEqualTo: _searchQueryController.text.trim())
        .get()
        .then((results) {
      setState(() {
        cars = results;
        print("This is result :: ");
        print("Result = " + cars!.docs[0].get('carModel').toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    Widget showCarsList() {
      if (cars != null) {
        return ListView.builder(
          itemCount: cars!.docs.length,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (context, i) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Route newRoute = MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  sellerId: cars!.docs[i].get('uid'),
                                ));
                        Navigator.pushReplacement(context, newRoute);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                cars!.docs[i].get('imgPro'),
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    title: GestureDetector(
                        onTap: () {
                          Route newRoute = MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    sellerId: cars!.docs[i].get('uid'),
                                  ));
                          Navigator.pushReplacement(context, newRoute);
                        },
                        child: Text(cars!.docs[i].get('userName'))),
                    subtitle: GestureDetector(
                      onTap: () {
                        Route newRoute = MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  sellerId: cars!.docs[i].get('uid'),
                                ));
                        Navigator.pushReplacement(context, newRoute);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cars!.docs[i].get('carLocation'),
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Icon(
                            Icons.location_pin,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(
                      cars!.docs[i].get('urlImage'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '\$ ' + cars!.docs[i].get('carPrice'),
                      style: TextStyle(
                        fontFamily: "Bebas",
                        letterSpacing: 2.0,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_car),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(cars!.docs[i].get('carModel')),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                //child: Text(cars!.docs[i].data()['time'].toString()),
                                child: Text(tAgo.format((cars!.docs[i].get('time')).toDate())),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.brush_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                child: Text(cars!.docs[i].get('carColor')),
                                alignment: Alignment.topLeft,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone_android),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Align(
                                //child: Text(cars!.docs[i].data()['time'].toString()),
                                child: Text(cars!.docs[i].get('userNumber')),
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      cars!.docs[i].get('description'),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Text('Loading...');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : _buildBackButton(),
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                   Colors.blueGrey,
                  Colors.deepPurple,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: _screenWidth * .6,
          child: showCarsList(),
        ),
      ),
    );
  }
}
