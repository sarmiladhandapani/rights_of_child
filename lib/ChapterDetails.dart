import 'package:flutter/material.dart';
import 'package:rights_of_child/SectionDetails.dart';
import 'package:rights_of_child/laws_sections.dart';

class ChapterDetails extends StatefulWidget {
  final Chapter chapter;

  ChapterDetails({Key key, this.chapter}) : super(key: key);

  @override
  _ChapterDetailsState createState() => _ChapterDetailsState();
}

class _ChapterDetailsState extends State<ChapterDetails> {
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
          title: Text(
            widget.chapter.title,
            style: TextStyle(
              color: Color(0xFF1f186f),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          child: ListView.builder(
              itemCount: widget.chapter.sections.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      List<Section> sections = widget.chapter.sections;
                      Section tappedSection;
                      for (var c in sections) {
                        if (c.title == widget.chapter.sections[index].title) {
                          tappedSection = c;
                          break;
                        }
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SectionDetails(
                                section: tappedSection,
                              )));
                    },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insert_drive_file_sharp,
                                        color: Color(0xffffff00),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        widget.chapter.sections[index].title,
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
                                widget.chapter.sections[index].subTitle,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
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

class Chapter {
  final title;
  final List<Section> sections;

  Chapter(this.title, this.sections);
}
