import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellbuyrentcar/screens/HomeScreen.dart';
import 'package:sellbuyrentcar/commons/functions.dart';
import 'package:timeago/timeago.dart' as tAgo;

import '../commons/globalVar.dart';

class ProfileScreen extends StatefulWidget {
  String sellerId;

  ProfileScreen({required this.sellerId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName = '';
  String userNumber = '';
  String carPrice = '';
  String carModel = '';
  String carLocation = '';
  String carColor = '';
  String description = '';
  String urlImage = '';
  late QuerySnapshot cars;

  carMethods carObj = new carMethods();

  Future<dynamic> showDialogForUpdateData(selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Update   Data",
              style: TextStyle(fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Your Name'),
                  onChanged: (value) {
                    this.userName = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Your Phone Number'),
                  onChanged: (value) {
                    this.userNumber = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Price'),
                  onChanged: (value) {
                    this.carPrice = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Name'),
                  onChanged: (value) {
                    this.carModel = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Car Color'),
                  onChanged: (value) {
                    this.carColor = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Location'),
                  onChanged: (value) {
                    this.carLocation = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Write Car Description'),
                  onChanged: (value) {
                    this.description = value;
                  },
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(hintText: 'Enter Image URL'),
                  onChanged: (value) {
                    this.urlImage = value;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text(
                  "Update Now",
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Map<String, dynamic> carData = {
                    'userName': this.userName,
                    'userNumber': this.userNumber,
                    'carPrice': this.carPrice,
                    'carModel': this.carModel,
                    'carColor': this.carColor,
                    'carLocation': this.carLocation,
                    'description': this.description,
                    'urlImage': this.urlImage,
                  };
                  carObj.updateData(selectedDoc, carData).then((value) {
                    print("Data updated successfully.");
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
            ],
          );
        });
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

  Widget _buildUserImage() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(adUserImageUrl), fit: BoxFit.fill),
      ),
    );
  }

  getResults() {
    FirebaseFirestore.instance
        .collection('cars')
        .where("uId", isEqualTo: widget.sellerId)
        .get()
        .then((results) {
      setState(() {
        cars = results;
        adUserName = cars.docs[0].get('userName');
        adUserImageUrl = cars.docs[0].get('imgPro');
        _isLoading = false;
      });
    });
  }

  Widget showCarsList() {
    if (cars != null) {
      return ListView.builder(
        itemCount: cars.docs.length,
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
                                sellerId: cars.docs[i].get('uId'),
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
                              cars.docs[i].get('imgPro'),
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  title: GestureDetector(
                      onTap: () {
                        Route newRoute = MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  sellerId: cars.docs[i].get('uId'),
                                ));
                        Navigator.pushReplacement(context, newRoute);
                      },
                      child: Text(cars.docs[i].get('userName'))),
                  subtitle: GestureDetector(
                    onTap: () {
                      Route newRoute = MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                sellerId: cars.docs[i].get('uId'),
                              ));
                      Navigator.pushReplacement(context, newRoute);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cars.docs[i].get('carLocation'),
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
                  trailing: cars.docs[i].get('uId') == userId
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (cars.docs[i].get('uId') == userId) {
                                  showDialogForUpdateData(cars.docs[i].id);
                                }
                              },
                              child: Icon(
                                Icons.edit_outlined,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                                onDoubleTap: () {
                                  if (cars.docs[i].get('uId') == userId) {
                                    carObj.deleteData(cars.docs[i].id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext c) => HomeScreen()));
                                  }
                                },
                                child: Icon(Icons.delete_forever_sharp)),
                          ],
                        )
                      : Row(mainAxisSize: MainAxisSize.min, children: []),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    cars.docs[i].get('urlImage'),
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '\$ ' + cars.docs[i].get('carPrice'),
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
                              child: Text(cars.docs[i].get('carModel')),
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
                              //child: Text(cars.docs[i].data()['time'].toString()),
                              child: Text(tAgo.format((cars.docs[i].get('time')).toDate())),
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
                              child: Text(cars.docs[i].get('carColor')),
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
                              //child: Text(cars.docs[i].data()['time'].toString()),
                              child: Text(cars.docs[i].get('userNumber')),
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
                    cars.docs[i].get('description'),
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
bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return _isLoading
        ? Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()),
        ))
        : Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(),
        title: Row(
          children: [
            _buildUserImage(),
            SizedBox(
              width: 10,
            ),
            Text(adUserName),
          ],
        ),
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
          width: _screenWidth * .5,
          child: showCarsList(),
        ),
      ),
    );
  }
}
