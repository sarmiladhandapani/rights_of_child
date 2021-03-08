import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:rights_of_child/ContactUs.dart';
import 'package:rights_of_child/Events.dart';
import 'package:rights_of_child/FAQPage.dart';
import 'package:rights_of_child/ReportPage.dart';
import 'package:rights_of_child/ViewReports.dart';
import 'package:rights_of_child/ViewVolunteers.dart';
import 'package:rights_of_child/VolunteerPage.dart';
import 'package:rights_of_child/forum/DiscussionScreen.dart';
import 'package:rights_of_child/laws_sections.dart';
import 'package:rights_of_child/user_info.dart';

class HomePage extends StatefulWidget {
  final String action;

  const HomePage({Key key, this.action}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FirstLayer(),
          SecondLayer(),
          ThirdLayer(),
          HomePage1(
            action: widget.action,
          ),
        ],
      ),
    );
  }
}

class HomePage1 extends StatefulWidget {
  final String action;

  const HomePage1({Key key, this.action}) : super(key: key);
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String uI = null;
  List _children;

  double xoffSet = 0;
  double yoffSet = 0;
  double angle = 0;

  bool isOpen = false;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      LawsAndSections(),
      EventsPage(),
      DiscussionScreen(),
      UserInfoPage(
        action: widget.action,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4Transform()
          .translate(x: xoffSet, y: yoffSet)
          .rotate(angle)
          .matrix4,
      duration: Duration(milliseconds: 250),
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Color(0xffe6e2ff),
              body: _children[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.yellowAccent,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: Color(0xFF1f186f),
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Color(0xFF1f186f),
                    icon: Icon(Icons.event),
                    label: 'Events',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Color(0xFF1f186f),
                    icon: Icon(Icons.chat),
                    label: 'Forum',
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Color(0xFF1f186f),
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
            !isOpen
                ? IconButton(
                    icon: Icon(
                      Icons.sort,
                      color: Color(0xFF1f186f),
                    ),
                    onPressed: () {
                      setState(() {
                        xoffSet = 150;
                        yoffSet = 80;
                        angle = -0.2;
                        isOpen = true;
                      });

                      secondLayerState.setState(() {
                        secondLayerState.xoffSet = 122;
                        secondLayerState.yoffSet = 110;
                        secondLayerState.angle = -0.275;
                      });
                    })
                : IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Color(0xFF1f186f)),
                    onPressed: () {
                      if (isOpen == true) {
                        setState(() {
                          xoffSet = 0;
                          yoffSet = 0;
                          angle = 0;
                          isOpen = false;
                        });

                        secondLayerState.setState(() {
                          secondLayerState.xoffSet = 0;
                          secondLayerState.yoffSet = 0;
                          secondLayerState.angle = 0;
                        });
                      }
                    }),
          ],
        ),
      ),
    );
  }
}

class FirstLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF4c41a3), Color(0xFF1f186f)])),
    );
  }
}

SecondLayerState secondLayerState;

class SecondLayer extends StatefulWidget {
  @override
  SecondLayerState createState() => SecondLayerState();
}

class SecondLayerState extends State<SecondLayer> {
  double xoffSet = 0;

  double yoffSet = 0;

  double angle = 0;

  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    secondLayerState = this;
    return AnimatedContainer(
        transform: Matrix4Transform()
            .translate(x: xoffSet, y: yoffSet)
            .rotate(angle)
            .matrix4,
        duration: Duration(milliseconds: 550),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xFF4c41a3)),
        child: Column(
          children: [
            Row(
              children: [],
            )
          ],
        ));
  }
}

class ThirdLayer extends StatelessWidget {
  showAlertDialog(BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Color(0xFF1f186f),
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/rc-logo.png',
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.width / 4,
                      ),
                      Column(
                        children: [
                          Text(
                            "Rights for Children",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Rights for Future",
                            style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Color(0xffffff00),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    var currentUser = await FlutterSession().get('currentUser');
                    final DateTime day = DateFormat("MMMM d, yyyy")
                        .parse(currentUser['dob'].toString());
                    int age = DateTime.now().year - day.year;
                    String name = currentUser['userName'].toString();
                    if (name.compareTo('Admin-biueIYBIYDIUSBDI#@#HBHDB') == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewReports(),
                          ));
                    } else {
                      age > 15
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportPage(),
                              ))
                          : showAlertDialog(context, 'Warning!',
                              'You are not eligible to make complaints!');
                    }
                  },
                  child: Text(
                    "Report an Incident",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                GestureDetector(
                  onTap: () async {
                    var currentUser = await FlutterSession().get('currentUser');
                    String name = currentUser['userName'].toString();
                    if (name.compareTo('Admin-biueIYBIYDIUSBDI#@#HBHDB') == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewVolunteers(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VolunteerPage(),
                          ));
                    }
                  },
                  child: Text(
                    "Volunteer Registration",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Divider(
                  color: Color(0xFF5950a0),
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FAQsPage(),
                        ));
                  },
                  child: Text(
                    "FAQs",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUsPage(),
                        ));
                  },
                  child: Text(
                    "Contact Us",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Divider(
                  color: Color(0xFF5950a0),
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
