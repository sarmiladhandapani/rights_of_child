import 'package:flutter/material.dart';
import 'package:rights_of_child/laws_sections.dart';

class SectionDetails extends StatefulWidget {
  final Section section;

  SectionDetails({Key key, this.section}) : super(key: key);

  @override
  _SectionDetailsState createState() => _SectionDetailsState();
}

class _SectionDetailsState extends State<SectionDetails> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    LawsAndSections(),
    Center(
      child: Text('Events'),
    ),
    Center(
      child: Text('Forum'),
    ),
    Center(
      child: Text('Profile'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe6e2ff),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFF1f186f),
          ),
          backgroundColor: Colors.transparent,
          title: Text(
            widget.section.title,
            style: TextStyle(
              color: Color(0xFF1f186f),
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF4c41a3),
                      Color(0xFF1f186f),
                    ],
                    stops: [
                      0.5,
                      1.0,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.insert_drive_file_sharp,
                                color: Color(0xffe0ae00),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                widget.section.title,
                                style: TextStyle(
                                  color: Color(0xffffff00),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                        bottom: 20,
                        right: 10,
                      ),
                      child: Text(
                        widget.section.subTitle,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(.8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                        bottom: 20,
                        right: 10,
                      ),
                      child: Text(
                        widget.section.description,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   onTap: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //   },
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.yellowAccent,
        //   items: [
        //     BottomNavigationBarItem(
        //       backgroundColor: Color(0xFF1f186f),
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       backgroundColor: Color(0xFF1f186f),
        //       icon: Icon(Icons.event),
        //       label: 'Events',
        //     ),
        //     BottomNavigationBarItem(
        //       backgroundColor: Color(0xFF1f186f),
        //       icon: Icon(Icons.chat),
        //       label: 'Forum',
        //     ),
        //     BottomNavigationBarItem(
        //       backgroundColor: Color(0xFF1f186f),
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class Section {
  final title;
  final subTitle;
  final description;

  Section(this.title, this.subTitle, this.description);
}
