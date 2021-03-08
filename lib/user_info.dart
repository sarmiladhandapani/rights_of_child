import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:rights_of_child/HomePage.dart';
import 'package:rights_of_child/login.dart';

reDirectPage(String action, BuildContext context) async {
  if (action.toString().trim().compareTo('sucess'.trim()) == 0) {
    await FlutterSession().set('isLoggedIn', true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  action: action,
                )));
  } else {
    await FlutterSession().set('isLoggedIn', false);
    showAlertDialog(context, action);
  }
}

showAlertDialog(BuildContext context, String action) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "OK",
      style: TextStyle(
        color: Color(0xFF1f186f),
      ),
    ),
    onPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("SignIn Failed"),
    content: Text(action),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class UserInfoPage extends StatelessWidget {
  final String action;

  const UserInfoPage({Key key, this.action}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6e2ff),
      body: profileView(),
    );
  }

  Widget profileView() {
    return FutureBuilder(
        future: FlutterSession().get('currentUser'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 70,
                        child: ClipOval(
                          child: snapshot.data['loginType'] == 'twitter' ||
                                  snapshot.data['loginType'] == 'credentials'
                              ? Container()
                              : Image.network(
                                  snapshot.data['profileImageUrl'].toString(),
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      // Positioned(
                      //     bottom: 1,
                      //     right: 1,
                      //     child: Container(
                      //       height: 40,
                      //       width: 40,
                      //       child: Icon(
                      //         Icons.add_a_photo,
                      //         color: Colors.white,
                      //       ),
                      //       decoration: BoxDecoration(
                      //           color: Colors.deepOrange,
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(20))),
                      //     ))
                    ],
                  ),
                ),
                Flexible(
                    child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFF4c41a3), Color(0xFF1f186f)])),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data['userName'].toString(),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data['userEmail'].toString(),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data['dob'].toString(),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                        child: Container(
                          height: 60,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data['connectType']
                                            .toString()
                                            .trim()
                                            .compareTo('credentials') ==
                                        0
                                    ? 'Login Type - Email'
                                    : 'Login Type - ' +
                                        snapshot.data['loginType']
                                            .toString()
                                            .toUpperCase(),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  width: 1.0, color: Colors.white70)),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 70,
                            width: 200,
                            child: FlatButton(
                              child: Align(
                                child: Text(
                                  'LOGOUT',
                                  style: TextStyle(
                                      color: Color(0xFF1f186f), fontSize: 20),
                                ),
                              ),
                              onPressed: () async {
                                if (snapshot.data['loginType'] == 'google') {
                                  LoginScreenState().googleSignIn.signOut();
                                } else if (snapshot.data['loginType'] ==
                                    'facebook') {
                                  LoginScreenState().fbLogin.logOut();
                                } else if (snapshot.data['loginType'] ==
                                    'twitter') {
                                  LoginScreenState().twitterLogin.logOut();
                                }
                                await FlutterSession().set('currentUser', '');
                                await FlutterSession().set('isLoggedIn', false);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              },
                            ),
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
