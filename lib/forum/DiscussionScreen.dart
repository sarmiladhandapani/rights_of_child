import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DiscussionScreen extends StatefulWidget {
  @override
  _DiscussionScreenState createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController textEditingController =
      new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  File _image;
  final picker = ImagePicker();

  Future choiceImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _handleSubmit(File imageFile, String uid) async {
    String message = textEditingController.text.toString();
    textEditingController.clear();
    String time = DateTime.now().toString();
    var uri = Uri.parse(
        'https://delicioustechnoworld.com/ifybewiewbfuyerfbryefyeryubyufbr.php');
    var request = http.MultipartRequest("POST", uri);
    request.fields['key'] =
        'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg';
    request.fields['message'] = message;
    request.fields['time'] = time;
    request.fields['sender_id'] = uid;
    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath("image", imageFile.path);
      request.files.add(pic);
    }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    var respString = jsonDecode(respStr);
    if (respString[0]['action'].toString().trim().compareTo('sucess'.trim()) ==
        0) {
      setState(() {
        _image = null;
      });
      _getChatData(uid);
    } else {}
  }

  _getChatData(String id) async {
    String url =
        'https://delicioustechnoworld.com/giuefhiurfhurfhiurhguhoiadniwoefje.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'lsingsiewonfeirngioenfoeinfoiewnafoiwnm',
        'sender_id': id,
      }),
    );
    final responseBody = jsonDecode(response.body);
    return responseBody;
  }

  Widget _textComposerWidget(String uid) {
    return new IconTheme(
      data: new IconThemeData(color: Color(0xFF1f186f)),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                choiceImage();
              },
            ),
            Container(
              width: 100,
              height: 100,
              child: _image == null
                  ? Center(child: Text('No image selected'))
                  : Image.file(_image),
            ),
            new Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: new TextField(
                  decoration: new InputDecoration.collapsed(
                      hintText: "Enter your message"),
                  controller: textEditingController,
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _image == null
                    ? _handleSubmit(null, uid)
                    : _handleSubmit(_image, uid),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6e2ff),
      body: FutureBuilder(
        future: FlutterSession().get('currentUser'),
        builder: (context, snapshot1) {
          snapshot1.hasData ? _getChatData(snapshot1.data['id']) : null;
          return snapshot1.hasData
              ? new Column(
                  children: <Widget>[
                    new Flexible(
                        child: new FutureBuilder(
                      future: _getChatData(snapshot1.data['id']),
                      builder: (context, snapshot) {
                        if (snapshot.data == null || snapshot.data == '') {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 2,
                                right: 2,
                              ),
                              child: Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    elevation: 0,
                                    margin: EdgeInsets.all(0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(snapshot
                                                            .data[index]
                                                                ['logintype']
                                                            .toString() ==
                                                        'twitter'
                                                    ? 'https://toppng.com/uploads/preview/twitter-logo-11549680523gyu1fhgduu.png'
                                                    : snapshot.data[index][
                                                                    'logintype']
                                                                .toString() ==
                                                            'credentials'
                                                        ? 'https://www.howitworksdaily.com/wp-content/uploads/2016/03/email-logo.jpg'
                                                        : snapshot.data[index]
                                                            ['profile']),
                                                radius: 40,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5,
                                                  right: 10,
                                                  top: 15,
                                                  bottom: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      snapshot.data[index][
                                                                      'logintype']
                                                                  .toString() ==
                                                              'twitter'
                                                          ? Icon(
                                                              const IconData(
                                                                  0xea96,
                                                                  fontFamily:
                                                                      'icomoon'),
                                                              color: Color(
                                                                  0Xff00acee),
                                                              size: 15.0,
                                                            )
                                                          : snapshot.data[index]
                                                                          [
                                                                          'logintype']
                                                                      .toString() ==
                                                                  'facebook'
                                                              ? Icon(
                                                                  const IconData(
                                                                      0xea90,
                                                                      fontFamily:
                                                                          'icomoon'),
                                                                  color: Color(
                                                                      0Xff3B5998),
                                                                  size: 15.0,
                                                                )
                                                              : snapshot.data[index]
                                                                              [
                                                                              'logintype']
                                                                          .toString() ==
                                                                      'google'
                                                                  ? Icon(
                                                                      const IconData(
                                                                          0xea88,
                                                                          fontFamily:
                                                                              'icomoon'),
                                                                      color: Color(
                                                                          0Xffdb3236),
                                                                      size:
                                                                          15.0,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .alternate_email,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 15,
                                                                    ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 5,
                                                          bottom: 3,
                                                          top: 3,
                                                          right: 2,
                                                        ),
                                                        child: Text(
                                                          snapshot.data[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: DateFormat.yMMMd(
                                                                        "en_US")
                                                                    .format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(snapshot
                                                                        .data[
                                                                            index]
                                                                            [
                                                                            'time']
                                                                        .toString()))
                                                                    .toString() +
                                                                '  ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: DateFormat(
                                                                    'kk:mm:a')
                                                                .format(DateFormat(
                                                                        "yyyy-MM-dd hh:mm:ss")
                                                                    .parse(snapshot
                                                                        .data[
                                                                            index]
                                                                            [
                                                                            'time']
                                                                        .toString()))
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12.5,
                                                              color:
                                                                  Colors.teal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5,
                                                    ),
                                                    child: SizedBox(
                                                      child: AutoSizeText(
                                                          snapshot.data[index]
                                                              ['message']),
                                                      width: 200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        snapshot.data[index]['image_path'] !=
                                                    '' &&
                                                snapshot.data[index]
                                                        ['image_path'] !=
                                                    null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FullImageScreen(
                                                            tag: snapshot
                                                                .data[index]
                                                                    ['uid']
                                                                .toString(),
                                                            path: 'https://www.delicioustechnoworld.com/' +
                                                                snapshot.data[
                                                                        index][
                                                                    'image_path'],
                                                            uID: snapshot1
                                                                .data['id']
                                                                .toString(),
                                                          ),
                                                        ));
                                                  },
                                                  child: Hero(
                                                    tag: 'img' +
                                                        snapshot.data[index]
                                                            ['uid'],
                                                    child: CachedNetworkImage(
                                                      height: 200,
                                                      width: 200,
                                                      imageUrl:
                                                          'https://www.delicioustechnoworld.com/' +
                                                              snapshot.data[
                                                                      index][
                                                                  'image_path'],
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, text) =>
                                                          new Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )),
                    new Divider(
                      height: 1.0,
                    ),
                    new Container(
                      decoration: new BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child:
                          _textComposerWidget(snapshot1.data['id'].toString()),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String tag;
  final String path;
  final uID;

  const FullImageScreen({Key key, this.tag, this.path, this.uID})
      : super(key: key);
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
                      tag: 'img' + tag,
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
