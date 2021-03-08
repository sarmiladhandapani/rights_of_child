import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class ViewReports extends StatefulWidget {
  @override
  _ViewReportsState createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  _getReports() async {
    String url =
        'https://delicioustechnoworld.com/get_reports_bwefbyi3ibyibibewifuwebfu.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg',
      }),
    );
    final profile = jsonDecode(response.body);
    return profile;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reported Incidents',
            style: TextStyle(
              color: Color(0xFF1f186f),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFF1f186f),
          ),
        ),
        body: FutureBuilder(
          future: _getReports(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Complainer :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['complainer']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Phone :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['mobile']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Violator :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['violator']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Incident Date :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['date']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Violation Type :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['violation'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Place :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['location'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Address :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['street'].toString() +
                                      ', ' +
                                      snapshot.data[index]['city'].toString() +
                                      ', ' +
                                      snapshot.data[index]['district']
                                          .toString() +
                                      ', ' +
                                      snapshot.data[index]['state'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Remarks :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1f186f),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data[index]['remarks'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            bottom: 3,
                            top: 15,
                            right: 53,
                          ),
                          child: Text(
                            'Image Proof',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      fullscreenDialog: true,
                                      transitionDuration:
                                          Duration(milliseconds: 1000),
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return FullImageScreen(
                                          tag: snapshot.data[index]['id']
                                                  .toString() +
                                              '1',
                                          path:
                                              'https://www.delicioustechnoworld.com/' +
                                                  snapshot.data[index]['img1']
                                                      .toString(),
                                        );
                                      },
                                      transitionsBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                          Widget child) {
                                        return FadeTransition(
                                          opacity:
                                              animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://www.delicioustechnoworld.com/' +
                                            snapshot.data[index]['img1']
                                                .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 3,
                                    ),
                                  ),
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      fullscreenDialog: true,
                                      transitionDuration:
                                          Duration(milliseconds: 1000),
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return FullImageScreen(
                                          tag: snapshot.data[index]['id']
                                                  .toString() +
                                              '2',
                                          path:
                                              'https://www.delicioustechnoworld.com/' +
                                                  snapshot.data[index]['img2']
                                                      .toString(),
                                        );
                                      },
                                      transitionsBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                          Widget child) {
                                        return FadeTransition(
                                          opacity:
                                              animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://www.delicioustechnoworld.com/' +
                                            snapshot.data[index]['img2']
                                                .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 3,
                                    ),
                                  ),
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      fullscreenDialog: true,
                                      transitionDuration:
                                          Duration(milliseconds: 1000),
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return FullImageScreen(
                                          tag: snapshot.data[index]['id']
                                                  .toString() +
                                              '3',
                                          path:
                                              'https://www.delicioustechnoworld.com/' +
                                                  snapshot.data[index]['img3']
                                                      .toString(),
                                        );
                                      },
                                      transitionsBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                          Widget child) {
                                        return FadeTransition(
                                          opacity:
                                              animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://www.delicioustechnoworld.com/' +
                                            snapshot.data[index]['img3']
                                                .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 3,
                                    ),
                                  ),
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      fullscreenDialog: true,
                                      transitionDuration:
                                          Duration(milliseconds: 1000),
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
                                        return FullImageScreen(
                                          tag: snapshot.data[index]['id']
                                                  .toString() +
                                              '4',
                                          path:
                                              'https://www.delicioustechnoworld.com/' +
                                                  snapshot.data[index]['img4']
                                                      .toString(),
                                        );
                                      },
                                      transitionsBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                          Widget child) {
                                        return FadeTransition(
                                          opacity:
                                              animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://www.delicioustechnoworld.com/' +
                                            snapshot.data[index]['img4']
                                                .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.brown,
                                      width: 3,
                                    ),
                                  ),
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 5,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String tag;
  final String path;

  const FullImageScreen({Key key, this.tag, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe6e2ff),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'Click on the image to go back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Center(
                    child: Hero(
                      tag: tag,
                      child: CachedNetworkImage(
                        imageUrl: path,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, text) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
