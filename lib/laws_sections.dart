import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rights_of_child/ChapterDetails.dart';
import 'package:rights_of_child/SectionDetails.dart';

class LawsAndSections extends StatefulWidget {
  LawsAndSections({Key key}) : super(key: key);

  @override
  _LawsAndSectionsState createState() => _LawsAndSectionsState();
}

class _LawsAndSectionsState extends State<LawsAndSections> {
  List<Item> _items;
  ScrollController _scrollController;
  bool _isclick1, _isclick2, _isclick3;

  @override
  void initState() {
    super.initState();
    _createChapters();
    _isclick1 = true;
    _isclick2 = false;
    _isclick3 = false;

    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 30 && _scrollController.offset < 600) {
        setState(() {
          _isclick1 = false;
          _isclick2 = true;
          _isclick3 = false;
        });
      }

      if (_scrollController.offset >= 600) {
        setState(() {
          _isclick1 = false;
          _isclick2 = false;
          _isclick3 = true;
        });
      }

      if (_scrollController.offset >= 0 && _scrollController.offset < 300) {
        setState(() {
          _isclick1 = true;
          _isclick2 = false;
          _isclick3 = false;
        });
      }
    });

    // TODO - this is shortcut to specify items.
    // In a real app, you would get them
    // from your data repository or similar.
    _items = new List<Item>();
    _items.add(new Item(_getList1(), false));
    _items.add(new Item(_getList2(), false));
    _items.add(new Item(_getList3(), false));
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        //showmore = _scrollController.position.maxScrollExtent > 629;
      });
    });

    Widget buttonsWidget = new Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: new Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 5, // space between underline and text
                ),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        bottom: BorderSide(
                      color: _isclick1
                          ? Color(0xffe0ae00)
                          : Colors.transparent, // Text colour here
                      width: 3.0, // Underline width
                    ))),
                child: new FlatButton(
                  textColor: Color(0xffe0ae00),
                  color: Colors.transparent,
                  child: new Text(
                    '1-3',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isclick1 ? Color(0xffe0ae00) : Colors.black,
                    ),
                  ),
                  onPressed: _scrollToFIRST,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 5, // space between underline and text
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: _isclick2
                      ? Color(0xffe0ae00)
                      : Colors.transparent, // Text colour here
                  width: 3.0, // Underline width
                ))),
                child: new FlatButton(
                  textColor: Color(0xffe0ae00),
                  color: Colors.transparent,
                  child: new Text(
                    '4-6',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isclick2 ? Color(0xffe0ae00) : Colors.black,
                    ),
                  ),
                  onPressed: _scrollToSECOND,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 5, // space between underline and text
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: _isclick3
                      ? Color(0xffe0ae00)
                      : Colors.transparent, // Text colour here
                  width: 3.0, // Underline width
                ))),
                child: new FlatButton(
                  textColor: Color(0xffe0ae00),
                  color: Colors.transparent,
                  child: new Text(
                    '7-9',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isclick3 ? Color(0xffe0ae00) : Colors.black,
                    ),
                  ),
                  onPressed: _scrollToTHIRD,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget itemsWidget = new ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: _scrollController,
        children: _items.map((Item item) {
          return _singleItemDisplay(item);
        }).toList());

    return SafeArea(
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        body: new Padding(
          padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
          child: new Column(
            children: <Widget>[
              buttonsWidget,
              new Expanded(
                child: itemsWidget,
              ),
//            showmore ? Text('YES') : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _singleItemDisplay(Item item) {
    return new Container(
      child: item._container,
      color: Colors.transparent,
    );
  }

  void _scroll() {
    for (int i = 0; i < _items.length; i++) {
      if (_items.elementAt(i).selected) {
        if (i == 0) {
          _scrollController.animateTo(0,
              duration: new Duration(seconds: 2), curve: Curves.ease);
        } else if (i == 1) {
          _scrollController.animateTo(300,
              duration: new Duration(seconds: 2), curve: Curves.ease);
        } else if (i == 2) {
          _scrollController.animateTo(600,
              duration: new Duration(seconds: 2), curve: Curves.ease);
        }
        break;
      }
    }
  }

  void _scrollToFIRST() {
    setState(() {
      for (var item in _items) {
        if (_items.indexOf(item) == 0) {
          item.selected = true;
          _isclick1 = true;
          _isclick2 = false;
          _isclick3 = false;
          _scroll();
        } else {
          item.selected = false;
          _scroll();
        }
      }
    });
  }

  void _scrollToSECOND() {
    setState(() {
      for (var item in _items) {
        if (_items.indexOf(item) == 1) {
          item.selected = true;
          _isclick1 = false;
          _isclick2 = true;
          _isclick3 = false;
          _scroll();
        } else {
          item.selected = false;
          _scroll();
        }
      }
    });
  }

  void _scrollToTHIRD() {
    setState(() {
      for (var item in _items) {
        if (_items.indexOf(item) == 2) {
          item.selected = true;
          _isclick1 = false;
          _isclick2 = false;
          _isclick3 = true;
          _scroll();
        } else {
          item.selected = false;
          _scroll();
        }
      }
    });
  }

  Container _getList1() {
    return Container(
      child: Column(
        children: [
          _getCard('Chapter I', 'Preliminary', 'Section 1-2'),
          _getCard(
              'Chapter II', 'Sexual Offenses against Children', 'Section 3-12'),
          _getCard(
              'Chapter III',
              'Using Child for Pornographic Purposes and Punishment Therefor',
              'Section 13-15'),
        ],
      ),
    );
  }

  Container _getList2() {
    return Container(
      child: Column(
        children: [
          _getCard('Chapter IV', 'Abetment of and Attempt to Commit an Offense',
              'Section 16-18'),
          _getCard(
              'Chapter V', 'Procedure for Reporting of Casts', 'Section 19-23'),
          _getCard(
              'Chapter VI',
              'Procedure for Recording Statement of the Child',
              'Section 24-27'),
        ],
      ),
    );
  }

  Container _getList3() {
    return Container(
      child: Column(
        children: [
          _getCard('Chapter VII', 'Special Courts', 'Section 28-32'),
          _getCard(
              'Chapter VIII',
              'Procedure and Powers of Special Courts and Recording of Evidence',
              'Section 33-38'),
          _getCard('Chapter IX', 'Miscellaneous', 'Section 39-46'),
        ],
      ),
    );
  }

  Widget _getCard(String chapter, String heading, String section) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          List<Chapter> chapters = _createChapters();
          Chapter tappedChapter;
          for (var c in chapters) {
            if (c.title == chapter) {
              tappedChapter = c;
              break;
            }
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChapterDetails(
                    chapter: tappedChapter,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file_sharp,
                            color: Colors.yellowAccent,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            chapter,
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Text(
                        section,
                        style: TextStyle(color: Colors.white),
                      )
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
                    heading,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Chapter> _createChapters() {
    List<Chapter> chapters = [];
    List<Section> sections = _getSections();
    chapters.add(new Chapter('Chapter I', [sections[0], sections[1]]));
    chapters.add(new Chapter('Chapter II', [
      sections[2],
      sections[3],
      sections[4],
      sections[5],
      sections[6],
      sections[7],
      sections[8],
      sections[9],
      sections[10],
      sections[11]
    ]));
    chapters.add(
        new Chapter('Chapter III', [sections[12], sections[13], sections[14]]));
    chapters.add(
        new Chapter('Chapter IV', [sections[15], sections[16], sections[17]]));
    chapters.add(new Chapter('Chapter V', [
      sections[18],
      sections[19],
      sections[20],
      sections[21],
      sections[22]
    ]));
    chapters.add(new Chapter('Chapter VI',
        [sections[23], sections[24], sections[25], sections[26]]));
    chapters.add(new Chapter('Chapter VII', [
      sections[27],
      sections[28],
      sections[29],
      sections[30],
      sections[31]
    ]));
    chapters.add(new Chapter('Chapter VIII', [
      sections[32],
      sections[33],
      sections[34],
      sections[35],
      sections[36],
      sections[37]
    ]));
    chapters.add(new Chapter('Chapter IX', [
      sections[38],
      sections[39],
      sections[40],
      sections[41],
      sections[42],
      sections[43],
      sections[44],
      sections[45]
    ]));
    return chapters;
  }

  List<Section> _getSections() {
    List<Section> sections = [];
    sections.add(new Section(
        'Section 1',
        'Short title, extent and commencement',
        "1.     This Act may be called the Protection of Children from Sexual Offences Act, 2012.\n2.     It extends to the whole of India, except the State of Jammu and Kashmir.\n3.     It shall come into force on such date as the Central Government may, by notification in the Official Gazette, appoint."));
    sections.add(new Section('Section 2', 'Definitions',
        "1.     In this Act, unless the context otherwise requires, -\na.     'aggravated penetrative sexual assault' has the same meaning as assigned to it in section 5;\n\nb.    'aggravated sexual assault' has the same meaning as assigned to it in section 9;\n\nc.     'aimed forces or security forces' means armed forces of the Union or security forces or police forces, as specified in the Schedule;\n\n'child' means any person below the age of eighteen years;\n\ne.     'domestic relationship' shall have the same meaning as assigned to it in clause (f) of section 2 of the Protection of Women from Domestic Violence Act, 2005;\n\nf.     'penetrative sexual assault' has the same meaning as assigned to it in section 3;\n\ng.    'prescribed' means prescribed by rules made under this Act;\n\nh.     'religious institution' shall have the same meaning as assigned to it in the Religious Institutions (Prevention of Misuse) Act, 1988;\n\ni.      'sexual assault' has the same meaning as assigned to it in section 7;\n\nj.      'sexual harassment' has the same meaning as assigned to it in section 11;\n\nk.     'shared household' means a household where the person charged with the offence lives or has lived at any time in a domestic relationship with the child;\n\nl.      'Special Court' means a court designated as such under section 28;\n\nm.   'Special Public Prosecutor' means a Public Prosecutor appointed under section 32.\n\n2.     The words and expressions used herein and not defined but defined in the Indian Penal Code, the Code of Criminal Procedure, 1973, the Juvenile Justice (Care and Protection of Children) Act, 2000 and the Information Technology Act, 2000 shall have the meanings respectively assigned to them in the said Codes or the Acts."));
    sections.add(new Section('Sectrion 3', 'Penetrative sexual assault',
        'A person is said to commit "penetrative sexual assault" if\n\na.     he penetrates his penis, to any extent, into the vagina, mouth, urethra or anus of a child or makes the child to do so with him or any other person; or\n\nb.    he inserts, to any extent, any object or a part of the body, not being the penis, into the vagina, the urethra or anus of the child or makes the child to do so with him or any other person; or\n\nc.     he manipulates any part of the body of the child so as to cause penetration into the vagina, urethra, anus or any part of body of the child or makes the child to do so with him or any other person; or\n\nd.    he applies his mouth to the penis, vagina, anus, urethra of the child or makes the child to do so to such person or any other person.'));
    sections.add(new Section(
        'Section 4',
        'Punishment for penetrative sexual assault',
        'Whoever commits penetrative sexual assault shall be punished with imprisonment of either description for a term which shall not be less than seven years but which may extend to imprisonment for life, and shall also be liable to fine.'));
    sections.add(new Section(
        'Section 5',
        'Aggravated penetrative sexual assault',
        'a.     Whoever, being a police officer, commits penetrative sexual assault on a child-\n\n i.        within the limits of the police station or premises at which he is appointed; or \n\n ii.        in the premises of any station house, whether or not situated in the police station, to which he is appointed; or\n\niii.        in the course of his duties or otherwise; or\n\n iv.        where he is known as, or identified as, a police officer; or\n\nb.    whoever being a member of the armed forces or security forces commits penetrative sexual assault on a child-\n\ni.        within the limits of the area to which the person is deployed; or\n\n'
            'ii.        in any areas under the command of the forces or armed forces; or\n\niii.        in the course of his duties or otherwise; or\n\niv.        where the said person is known or identified as a member of the security or armed forces; or\n\nc.     whoever being a public servant commits penetrative sexual assault on a child; or\n\nd.    whoever being on the management or on the staff of a jail, remand home, protection home, observation home, or other place of custody or care and protection established by or under any law for the time being in force, commits penetrative sexual assault on a child, being inmate of such jail, remand home, protection home, observation home, or other place of custody or care and protection; or\n\n'
            'e.     whoever being on the management or staff of a hospital, whether Government or private, commits penetrative sexual assault on a child in that hospital; or\n\nf.     whoever being on the management or staff of an educational institution or religious institution, commits penetrative sexual assault on a child in that institution; or\n\ng.    whoever commits gang penetrative sexual assault on a child.\n\nExplanation.- When a child is subjected to sexual assault by one or more persons of a group in furtherance of their common intention, each of such persons shall be deemed to have committed gang penetrative sexual assault within the meaning of this clause and each of such person shall be liable for that act in the same manner as if it were done by him alone; or\n\n'
            'h.     whoever commits penetrative sexual assault on a child using deadly weapons, fire, heated substance or corrosive substance; or\n\ni.      whoever commits penetrative sexual assault causing grievous hurt or causing bodily harm and injury or injury to the sexual organs of the child; or\n\nj.      whoever commits penetrative sexual assault on a child, which-\n\ni.        physically incapacitates the child or causes the child to become mentally ill as defined under clause (l) of section 2 of the Mental Health Act, 1987 or causes impairment of any kind so as to render the child unable to perform regular tasks, temporarily or permanently; or\n\nii.        in the case of female child, makes the child pregnant as a consequence of sexual assault;\n\niii.        inflicts the child with Human Immunodeficiency Virus or any other life threatening disease or infection which may either temporarily or permanently impair the child by rendering him physically incapacitated, or mentally ill to perform regular tasks; or\n\n'
            'k.     whoever, taking advantage of a child\'s mental or physical disability, commits penetrative sexual assault on the child; or\n\n.      whoever commits penetrative sexual assault on the child more than once or repeatedly; or\n\nm.   whoever commits penetrative sexual assault on a child below twelve years; or\n\nn.     whoever being a relative of the child through blood or adoption or marriage or guardianship or in foster care or having a domestic relationship with a parent of the child or who is living in the same or shared household with the child, commits penetrative sexual assault on such child; or\n\no.    whoever being, in the ownership, or management, or staff, of any institution providing services to the child, commits penetrative sexual assault on the child; or\n\np.    whoever being in a position of trust or authority of a child commits penetrative sexual assault on the child in an institution or home of the child or anywhere else; or\n\nq.    whoever commits penetrative sexual assault on a child knowing the child is pregnant; or\n\n'
            'r.      whoever commits penetrative sexual assault on a child and attempts to murder the child; or\n\ns.     whoever commits penetrative sexual assault on a child in the course of communal or sectarian violence; or\n\nt.      whoever commits penetrative sexual assault on a child and who has been previously convicted of having committed any offence under this Act or any sexual offence punishable under any other law for the time being in force; or\n\nu.     whoever commits penetrative sexual assault on a child and makes the child to strip or parade naked in public, is said to commit aggravated penetrative sexual assault.\n\n'));
    sections.add(new Section(
        'Section 6',
        'Punishment for aggravated penetrative sexual assault',
        'Whoever, commits aggravated penetrative sexual assault, shall be punished with rigorous imprisonment for a term which shall not be less than ten years but which may extend to imprisonment for life and shall also be liable to fine'));
    sections.add(new Section('Section 7', 'Sexual assault',
        'Whoever, with sexual intent touches the vagina, penis, anus or breast of the child or makes the child touch the vagina, penis, anus or breast of such person or any other person, or does any other act with sexual intent which involves physical contact without penetration is said to commit sexual assault'));
    sections.add(new Section('Section 8', 'Punishment for sexual assault',
        'Whoever, commits sexual assault, shall be punished with imprisonment of either description for a term which shall not be less than three years but which may extend to five years, and shall also be liable to fine.'));
    sections.add(new Section(
        'Section 9',
        'Aggravated sexual assault',
        'a.     Whoever, being a police officer, commits sexual assault on a child-\n\n i.        within the limits of the police station or premises where he is appointed; or\n\nii.        in the premises of any station house whether or not situated in the police station to which he is appointed; or\n\niii.        in the course of his duties or otherwise; or\n\niv.        where he is known as, or identified as a police officer; or\n\nb.    whoever, being a member of the armed forces or security forces, commits sexual assault on a child-\n\ni.        within the limits of the area to which the person is deployed; or\n\nii.        in any areas under the command of the security or armed forces; or\n\niii.        in the course of his duties or otherwise; or\n\niv.        where he is known or identified as a member of the security or armed forces; or\n\nc.     whoever being a public servant commits sexual assault on a child; or\n\nd.    whoever being on the management or on the staff of a jail, or remand home or protection home or observation home, or other place of custody or care and protection established by or under any law for the time being in force commits sexual assault on a child being inmate of such jail or remand home or protection home or observation home or other place of custody or care and protection; or\n\n'
            'e.     whoever being on the management or staff of a hospital, whether Government or private, commits sexual assault on a child in that hospital; or\n\nf.     whoever being on the management or staff of an educational institution or religious institution, commits sexual assault on a child in that institution; or\n\ng.    whoever commits gang sexual assault on a child.\n\nExplanation.- when a child is subjected to sexual assault by one or more persons of a group in furtherance of their common intention, each of such persons shall be deemed to have committed gang sexual assault within the meaning of this clause and each of such person shall be liable for that act in the same manner as if it were done by him alone; or\n\nh.     whoever commits sexual assault on a child using deadly weapons, fire, heated substance or corrosive substance; or\n\n'
            'i.      whoever commits sexual assault causing grievous hurt or causing bodily harm and injury or injury to the sexual organs of the child; or\n\nj.      whoever commits sexual assault on a child, which-\n\ni.        physically incapacitates the child or causes the child to become mentally ill as defined under clause (l) of section 2 of the Mental Health Act, 1987 or causes impairment of any kind so as to render the child unable to perform regular tasks, temporarily or permanently; or\n\nii.        inflicts the child with Human Immunodeficiency Virus or any other life threatening disease or infection which may either temporarily or permanently impair the child by rendering him physically incapacitated, or mentally ill to perform regular tasks; or\n\n'
            'k.     whoever, taking advantage of a child\'s mental or physical disability, commits sexual assault on the child; or\n\nl.      whoever commits sexual assault on the child more than once or repeatedly; or\n\nm.   whoever commits sexual assault on a child below twelve years; or\n\nn.     whoever, being a relative of the child through blood or adoption or marriage or guardianship or in foster care, or having domestic relationship with a parent of the child, or who is living in the same or shared household with the child, commits sexual assault on such child; or\n\no.    whoever, being in the ownership or management or staff, of any institution providing services to the child, commits sexual assault on the child in such institution; or\n\np.    whoever, being in a position of trust or authority of a child, commits sexual assault on the child in an institution or home of the child or anywhere else; or\n\n'
            'q.    whoever commits sexual assault on a child knowing the child is pregnant; or\n\nr.      whoever commits sexual assault on a child and attempts to murder the child; or\n\ns.     whoever commits sexual assault on a child in the course of communal or sectarian violance; or\n\nt.      whoever commits sexual assault on a child and who has been previously convicted of having committed any offence under this Act or any sexual offence punishable under any other law for the time being in force; or\n\nu.     whoever commits sexual assault on a child and makes the child to strip or parade naked in public, is said to commit aggravated sexual assault.\n\n'));
    sections.add(new Section(
        'Section 9',
        'Punishment for aggravated sexual assault',
        'Whoever, commits aggravated sexual assault shall be punished with imprisonment of either description for a term which shall not be less than five years but which may extend to seven years, and shall also be liable to fine.'));
    sections.add(new Section('Section 11', 'Sexual harassment',
        'A person is said to commit sexual harassment upon a child when such person with sexual intent,-\n\ni.        utters any word or makes any sound, or makes any gesture or exhibits any object or part of body with the intention that such word or sound shall be heard, or such gesture or object or part of body shall be seen by the child; or\n\nii.        makes a child exhibit his body or any part of his body so as it is seen by such person or any other person; or\n\n iii.        shows any object to a child in any form or media for pornographic purposes; or\n\n iv.        repeatedly or constantly follows or watches or contacts a child either directly or through electronic, digital or any other means; or\n\n v.        threatens to use, in any form of media, a real or fabricated depiction through electronic, film or digital or any other mode, of any part of the body of the child or the involvement of the child in a sexual act; or\n\nvi.        entices a child for pornographic purposes or gives gratification therefore\n\nExplanation.- Any question which involves "sexual intent" shall be a question of fact.'));
    sections.add(new Section('Section 12', 'Punishment for sexual harassment',
        'Whoever, commits sexual harassment upon a child shall be punished with imprisonment of either description for a term which may extend to three years and shall also be liable to fine'));
    sections.add(new Section(
        'Section 13',
        'Use of child for pornographic purposes',
        'Whoever, uses a child in any form of media (including programme or advertisement telecast by television channels or internet or any other electronic form or printed form, whether or not such programme or advertisement is intended for personal use or for distribution), for the purposes of sexual gratification, which includes-\n\na.     representation of the sexual organs of a child;\n\nb.    usage of a child engaged in real or simulated sexual acts (with or without penetration);\n\nc.     the indecent or obscene representation of a child, shall be guilty of the offence of using a child for pornographic purposes.\n\nExplanation.- For the purposes of this section, the expression "use a child" shall include involving a child through any medium like print, electronic, computer or any other technology for preparation, production, offering, transmitting, publishing, facilitation and distribution of the pornographic material'));
    sections.add(new Section(
        'Section 14',
        'Punishment for using child for pornographic purposes',
        '1.     Whoever, uses a child or children for pornographic purposes shall be punished with imprisonment of either description which may extend to five years and shall also be liable to fine and in the event of second or subsequent conviction with imprisonment of either description for a term which may extend to seven years and also be liable to fine\n\n2.     If the person using the child for pornographic purposes commits an offence referred to in section 3, by directly participating in pornographic acts, he shall be punished with imprisonment of either description for a term which shall not be less than ten years but which may extend to imprisonment for life, and shall also be liable to fine.\n\n3.     If the person using the child for pornographic purposes commits an offence referred to in section 5, by directly participating in pornographic acts, he shall be punished with rigorous imprisonment for life and shall also be liable to fine\n\n'
            '4.     If the person using the child for pornographic purposes commits an offence referred to in section 7, by directly participating in pornographic acts, he shall be punished with imprisonment of either description for a term which shall not be less than six years but which may extend to eight years, and shall also be liable to fine\n\n5.     If the person using the child for pornographic purposes commits an offence referred to in section 9, by directly participating in pornographic acts, he shall be punished with imprisonment of either description for a term which shall not be less than eight years but which may extend to ten years, and shall also be liable to fine'));
    sections.add(new Section(
        'Section 15',
        'Punishment for storage of pornographic material involving child',
        'Any person, who stores, for commercial purposes any pornographic material in any form involving a child shall be punished with imprisonment of either description which may extend to three years or with fine or with both.'));
    sections.add(new Section('Section 16', 'Abetment of an offence',
        'A person abets an offence, who-\n\nFirst.- Instigates any person to do that offence; or\n\nSecondly.- Engages with one or more other person or persons in any conspiracy for the doing of that offence, if an act or illegal omission takes place in pursuance of that conspiracy, and in order to the doing of that offence; or\n\nThirdly.- Intentionally aids, by any act or illegal omission, the doing of that offence.\n\nExplanation I.- A person who, by wilful misrepresentation, or by wilful concealment of a material fact, which he is bound to disclose, voluntarily causes or procures, or attempts to cause or procure a thing to be done, is said to instigate the doing of that offence.\n\nExplanation II.- Whoever, either prior to or at the time of commission of an act, does anything in order to facilitate the commission of that act, and thereby facilitates the commission thereof, is said to aid the doing of that act.\n\nExplanation III.-Whoever employs, harbours, receives or transports a child, by means of threat or use force or other forms of coercion, abduction, fraud, deception, abuse of power or of a position, vulnerability or the giving or receiving of payments or benefits to achieve the consent of a person having control over another person, for the purpose of any offence under this Act, is said to aid the doing of that act.\n\n'));
    sections.add(new Section('Section 17', 'Punishment for abetment',
        'Whoever abets any offence under this Act, if the act abetted is committed in consequence of the abetment, shall be punished with punishment provided for that offence.\n\nExplanation.- An act or offence is said to be committed in consequence of abetment, when it is committed in consequence of the instigation, or in pursuance of the conspiracy or with the aid, which constitutes the abetment'));
    sections.add(new Section(
        'Section 18',
        'Punishment for attempt to commit an offence',
        'Whoever attempts to commit any offence punishable under this Act or to cause such an offence to be committed, and in such attempt, does any act towards the commission of the offence, shall be punished with imprisonment of any description provided for the offence, for a term which may extend to one-half of the imprisonment for life or, as the case may be, one-half of the longest term of imprisonment provided for that offence or with fine or with both.'));
    sections.add(new Section(
        'Section 19',
        'Reporting of offences',
        '1.     "Notwithstanding anything contained in the Code of Criminal Procedure, 1973, any person (including the child), who has apprehension that an offence under this Act is likely to be committed or has knowledge that such an offence has been committed, he shall provide such information to,-\n\na.     the Special Juvenile Police Unit, or\n\nb.    the local police.\n\n2.     Every report given under sub-section (1) shall be-\n\na.     ascribed an entry number and recorded in writing;\n\nb.    be read over to the informant;\n\nc.     shall be entered in a book to be kept by the Police Unit.\n\n3.     Where the report under sub-section (1) is given by a child, the same shall be recorded under sub-section (2) in a simple language so that the child understands contents being recorded.\n\n4.     In case contents are being recorded in the language not understood by the child or wherever it is deemed necessary, a translator or an interpreter, having such qualifications, experience and on payment of such fees as may be prescribed, shall be provided to the child if he fails to understand the same.\n\n5.     Where the Special Juvenile Police Unit or local police is satisfied that the child against whom an offence has been committed is in need of care and protection, then, it shall, after recording the reasons in writing, make immediate arrangement to give him such care and protection (including admitting the child into shelter home or to the nearest hospital) within twenty-four hours of the report, as may be prescribed.\n\n'
            '6.     The Special Juvenile Police Unit or local police shall, without unnecessary delay but within a period of twenty-four hours, report the matter to the Child Welfare Committee and the Special Court or where no Special Court has been designated, to the Court of Session, including need of the child for care and protection and steps taken in this regard\n\n7.     No person shall incur any liability, whether civil or criminal, for giving the information in pond faith for the purpose of sub-section (1)'));
    sections.add(new Section(
        'Section 20',
        'Obligation of media, studio and photographic facilities to report cases',
        'Any personnel of the media or hotel or lodge or hospital or club or studio or photographic facilities, by whatever name called, irrespective of the number of persons employed therein, shall, on coming across any material or object which is sexually exploitative of the child (including pornographic, sexually-related or making obscene representation of a child or children) through the use of any medium, shall provide such information to the Special Juvenile Police Unit or to the local police, as the case may be'));
    sections.add(new Section(
        'Section 21',
        'Title: Punishment for failure to report or record a case',
        '1.     Any person, who fails to report the commission of an offence under sub-section (1) of section 19 or section 20 or who fails to record such offence under sub-section (2) of section 19 shall be punished with imprisonment of either description which may extend to six months or with fine or with both.\n\n2.     Any person, being in-charge of any company or an institution (by whatever name called) who fails to report the commission of an offence under sub-section (1) of section 19 in respect of a subordinate under his control, shall be punished with imprisonment for a term which may extend to one year and with fine.\n\n 3.     The. revisions of sub-section (1) shall not apply to a child under this Act'));
    sections.add(new Section(
        'Section 22',
        'Punishment for false complaint or false information',
        '1.     Any person, who makes false complaint or provides false information against any person, in respect of an offence committed under sections 3,5,7 and section 9, solely with the intention to humiliate, extort or threaten or defame him, snail be punished with imprisonment for a term which may extend to six months or with fine or with both.\n\n2.     Where a false complaint has been made or false information has been provided by a child, no punishment shall be imposed on such child.\n\n3.     Whoever not being a child, makes a false complaint or provides false information against a child, knowing it to be false, thereby victimising such child in any of the offences under this Act, shall be punished with imprisonment which may extend to one year or with fine or with both.'));
    sections.add(new Section('Section 23', 'Procedure for media',
        '1.     No person shall make any report or present comments on any child from any form of media or studio or photographic facilities without having complete and authentic information, which may have the effect of lowering his reputation or infringing upon his privacy.\n\n2.     No reports in any media shall disclose, the identity of a child including his name, address, photograph, family details, school, neighbourhood or any other particulars which may lead to disclosure of identity of the child:\n\nProvided that for reasons to be recorded in writing, the Special Court, competent to try the case under the Act, may permit such disclosure, if in its opinion such disclosure is in the interest of the child.\n\n3.     The publisher or owner of the media or studio or photographic facilities shall be jointly and severally liable for the acts and omissions of his employee.\n\n4.     Any person who contravenes the provisions of sub-section (1) or sub-section (2) shall be liable to be punished with imprisonment of either description for a period which shall not be less than six months but which may extend to one year or with fine or with both.'));
    sections.add(new Section('Section 24', 'Recording of statement of a child',
        '1.     The statement of the child shall be recorded at the residence of the child or at a place where he usually resides or at the place of his choice and as far as practicable by a woman police officer not below the rank of sub-inspector.\n\n2.     The police officer while recording the statement of the child shall not be in uniform.\n\n3.     The police officer making the investigation, shall, while examining the child, ensure that at no point of time the child come in the contact in any way with the accused.\n\n4.     No child shall be detained in the police station in the night for any reason.\n\n5.     The police officer shall ensure that the identity of the child is protected from the public media, unless otherwise directed by the Special Court in the interest of the child.'));
    sections.add(new Section(
        'Section 25',
        'Recording of statement of a child by Magistrate',
        '1.     If the statement of the child is being recorded under section 164 of the Code of Criminal Procedure, 1973 (herein referred to as the Code), the Magistrate recording such statement shall, notwithstanding anything contained therein, record the statement as spoken by the child:\n\nProvided that the provisions contained in the first proviso to sub-section (1) of section 164 of the Code shall, so far it permits the presence of the advocate of the accused shall not apply in this case.\n\n2.     The Magistrate shall provide to the child and his parents or his representative, a copy of the document specified under section 207 of the Code, upon the final report being filed by the police under section 173 of that Code.'));
    sections.add(new Section(
        'Section 26',
        'Additional provisions regarding statement to be recorded',
        '1.     The Magistrate or the police officer, as the case may be, shall record the statement as spoken by the child in die presence of the parents of the child or any other person in whom the child has trust or confidence.\n\n2.     Wherever necessary, the Magistrate or the police officer, as the case may be, may take the assistance of a translator or an interpreter, having such qualifications, experience and on payment of such fees as may be prescribed, while recording the statement of the child.\n\n3.     The Magistrate or the police officer, as the case may be, may, in the case of a child having a mental or physical disability, seek the assistance of a special educator or any person familiar with the manner of communication of the child or an expert in that field, having such qualifications, experience and on payment of such fees as may be prescribed, to record the statement of the child.\n\n4.     Wherever possible, the Magistrate or the police officer, as the case may be, shall ensure that the statement of the child is also recorded by audio-video electronic means.'));
    sections.add(new Section('Section 27', 'Medical examination of a child',
        '1.     The medical examination of a child in respect of whom any offence has been committed under this Act, shall, notwithstanding that a First Information Report or complaint has not been registered for the offences under this Act, be conducted in accordance with section 164A of the Code of Criminal Procedure, 1973.\n\n2.     In case the victim is a girl child, the medical examination shall be conducted by a woman doctor.\n\n3.     The medical examination shall be conducted in the presence of the parent of the child or any other person in whom the child reposes trust or confidence.\n\n4.     Where, in case the parent of the child or other person referred to in sub-section (3) cannot be present, for any reason, during the medical examination of the child, the medical examination shall be conducted in the presence of a woman nominated by the head of the medical institution'));
    sections.add(new Section('Section 28', 'Designation of Special Courts',
        '1.     For the purposes of providing a speedy trial, the State Government shall in consultation with the Chief Justice of the High Court, by notification in the Official Gazette, designate for each district, a Court of Session to be a Special Court to try the offences under the Act:\n\nProvided that if a Court of Session is notified as a children\'s court under the Commissions for Protection of Save Young India Act, 2005 or a Special Court designated for similar purposes under any other law for the time being in force, then, such court shall be deemed to be a Special Court under this section.\n\n2.     While trying an offence under this Act, a Special Court shall also try an offence [other than the offence referred to in sub-section (1)], with which the accused may, under the Code of Criminal Procedure, 1973, be charged at the same trial.\n\n3.     The Special Court constituted under this Act, notwithstanding anything in the Information Technology Act, 2000, shall have jurisdiction to try offences under section 67B of that Art in so far as it relates to publication or transmission of sexually explicit material depicting children in any act, or conduct or manner or facilitates abuse of children online.'));
    sections.add(new Section('Section 29', 'Presumption as to certain offences',
        'Where a person is prosecuted for committing or abetting or attenuating to commit any offence under sections 3,5,7 and section 9 of this Act, the Special Court shall presume, that such person has committed or abetted or attempted to commit the offence, as the case may be unless the contrary is proved.'));
    sections.add(new Section(
        'Section 30',
        'Presumption of culpable mental state',
        '1.     In any prosecution for any offence under this Act which requires a culpable mental state on the part of the accused, the Special Court shall presume the existence of such mental state but it shall be a defence for the accused to prove the fact that he had no such mental state with respect to the act charged as an offence in that prosecution.\n\n2.     For the purposes of this section, a fact is said to be proved only when the Special Court believes it to exist beyond reasonable doubt and not merely when its existence is established by a preponderance of probability.\n\nExplanation.- In this section, "culpable mental state" includes intention, motive, knowledge of a fact and the belief in, or reason to believe, a fact.'));
    sections.add(new Section(
        'Section 31',
        'Application of Code of Criminal Procedure, 1973 to proceedings before a Special Court',
        'Save as otherwise provided in this Act, the provisions of the Code of Criminal Procedure, 1973 (including the provisions as to bail and bonds) shall apply to the proceedings before a Special Court and for the purposes of the said provisions, the Special Court shall be deemed to be a Court of Sessions and the person conducting a prosecution before a Special Court, shall be deemed to be a Public Prosecutor.'));
    sections.add(new Section('Section 32', 'Special Public Prosecutors',
        '1.     The State Government shall, by notification in the Official Gazette, appoint a Special Public Prosecutor for every Special Court for conducting cases only under the provisions of this Act.\n\n2.     A person shall be eligible to be appointed as a Special Public Prosecutor under sub-section (7) only if he had been in practice for not less than seven years as an advocate.\n\n3.     Every person appointed as a Special Public Prosecutor under this section shall be deemed to be a Public Prosecutor within the meaning of clause (u) of section 2 of the Code of Criminal Procedure, 1973 and provision of that Code shall have effect accordingly.'));
    sections.add(new Section(
        'Section 33',
        'Procedure and powers of Special Court',
        '1.     A Special Court may take cognizance of any offence, without the accused being committed to it for trial, upon receiving a complaint of facts which constitute such offence, or upon a police report of such facts.\n\n2.     The Special Public Prosecutor, or as the case may be, the counsel appearing for the accused shall, while recording the examination-in-chief, cross-examination or re-examination of the child, communicate the questions to be put to the child to the Special Court which shall in turn put those questions to the child.\n\n3.     The Special Court may, if it considers necessary, permit frequent breaks for the child during the trial.\n\n4.     The Special Court shall create a child-friendly atmosphere by allowing a family member, a guardian, a friend or a relative, in whom the child has trust or confidence, to be present in the court.\n\n5.     The Special Court shall ensure that the child is not called repeatedly to testify in the court.\n\n'
            '6.     The Special Court shall not permit aggressive questioning or character assassination of the child and ensure that dignity of the child is maintained at all times during the trial.\n\n7.     The Special Court shall ensure that the identity of the child is not disclosed at any time during the course of investigation or trial:\n\nProvided that for reasons to be recorded in writing, the Special Court may permit such disclosure, if in its opinion such disclosure is in the interest of the child.\n\nExplanation.- For the purposes of this sub-section, the identity of the child shall include the identity of the child\'s family, school, relatives, neighbourhood or any other information by which the identity of the child may be revealed.\n\n8.     In appropriate cases, the Special Court may, in addition to the punishment, direct payment of such compensation as may be prescribed to the child for any physical or mental trauma caused to him or for immediate rehabilitation of such child.\n\n'
            '9.     Subject to the provisions of this Act, a Special Court shall, for the purpose of the trial of any offence under this Act, have all the powers of a Court of Session and shall try such offence as if it were a Court of Session, and as far as may be, in accordance with the procedure specified in the Code of Criminal Procedure, 1973 for trial before a Court of Session.'));
    sections.add(new Section(
        'Section 34',
        'Procedure in case of commission of offence by child and determination of age by Special Court',
        '1.     Where any offence under this Act is committed by a child, such child shall be dealt with under the provisions of the Juvenile Justice (Care and Protection of Children) Act, 2000.\n\n2.     If any question arises in any proceeding before the Special Court whether a person is a child or not, such question shall be determined by the Special Court after satisfying itself about the age of such person and it shall record in writing its reasons for such determination.\n\n3.     No order made by the Special Court shall be deemed to be invalid merely by any subsequent proof that the age of a person as determined by it under sub-section (2) was not the correct age of that person.'));
    sections.add(new Section(
        'Section 35',
        'Period for recording of evidence of child and disposal of case',
        '1.     The evidence of the child shall be recorded within a period of thirty days of the Special Court taking cognizance of the offence and reasons for delay, if any, shall be recorded by the Special Court.\n\n2.     The Special Court shall complete the trial, as far as possible, within a period of one year from the date of taking cognizance of the offence.'));
    sections.add(new Section(
        'Section 36',
        'Child not to see accused at the time of testifying',
        '1.     The Special Court shall ensure that the child is not exposed in any way to the accused at the time of recording of the evidence, while at the same time ensuring that the accused is in a position to hear the statement of the child and communicate with his advocate.\n\n2.     For the purposes of sub-section (1), the Special Court may record the statement of a child through video conferencing or by utilising single visibility mirrors or curtains or any other device.'));
    sections.add(new Section('Section 37', 'Trials to be conducted in camera',
        'The Special Court shall try cases in camera and in the presence of the parents of the child or any other person in whom the child has trust or confidence:\n\nProvided that where the Special Court is of the opinion that the child needs to be examined at a place other than the court, it shall proceed to issue a commission in accordance with the provisions of section 284 of the Code of Criminal Procedure, 1973.'));
    sections.add(new Section(
        'Section 38',
        'Assistance of an interpreter or expert while recording evidence of child',
        '1.     Wherever necessary, the Court may take the assistance of a translator or interpreter having such qualifications, experience and on payment of such fees as may be prescribed, while recording the evidence of the child.\n\n2.     If a child has a mental or physical disability, the Special Court may take the assistance of a special educator or any person familiar with the manner of communication of the child or an expert in that field, having such qualifications, experience and on payment of such fees as may be prescribed to record the evidence of the child.'));
    sections.add(new Section(
        'Section 39',
        'Guidelines for child to take assistance of experts, etc',
        'Subject to such rules as may be made in this behalf, the State Government shall prepare guidelines for use of non-governmental organisations, professionals and experts or persons having knowledge of psychology, social work, physical health, mental health and child development to be associated with the pre-trial and trial stage to assist the child.'));
    sections.add(new Section(
        'Section 40',
        'Right of child to take assistance of legal practitioner',
        'Subject to the proviso to section 301 of the Code of Criminal Procedure, 1973 the family or the guardian of the child shall be entitled to the assistance of a legal counsel of their choice for any offence under this Act:\n\nProvided that if the family or the guardian of the child are unable to afford a legal counsel, the Legal Services Authority shall provide a lawyer to them.'));
    sections.add(new Section(
        'Section 41',
        'Provisions of sections 3 to 13 not to apply in certain cases',
        'The provisions of sections 3 to 13 (both inclusive) shall not apply in case of medical examination or medical treatment of a child when such medical examination or medical treatment is undertaken with the consent of his parents or guardian.'));
    sections.add(new Section('Section 42', 'Alternative punishment',
        'Where an act or omission constitute an offence punishable under this Act and also under any other law for the time being in force, then, notwithstanding anything contained in any law for the time being in force, the offender found guilty of such offence shall be liable to punishment only under such law or this Act as provides for punishment which is greater in degree.'));
    sections.add(new Section('Section 43', 'Public awareness about Act',
        'The Central Government and every State Government, shall take all measures to ensure that-\n\na.     the provisions of this Act are given wide publicity through media including the television, radio and the print media at regular intervals to make the general public, children as well as their parents and guardians aware of the provisions of this Act;\n\nb.    the officers of the Central Government and the State Governments and other concerned persons (including the police officers) are imparted periodic training on the matters relating to the implementation of the provisions of the Act'));
    sections.add(new Section(
        'Section 44',
        'Monitoring of implementation of Act',
        '1.     The National Commission for Protection of Save Young India constituted under section 3, or as the case may be, the State Commission for Protection of Save Young India constituted under section 17, of the Commissions for Protection of Save Young India Act, 2005, shall, in addition to the functions assigned to them under that Act, also monitor the implementation of the provisions of this Act in such manner as may be prescribed.\n\n2.     The National Commission or, as the case may be, the State Commission, referred to in sub-section (1), shall, while inquiring into any matter relating to any offence under this Act, have the same powers as are vested in it under the Commissions for Protection of Save Young India Act, 2005.\n\n'
            '3.     The National Commission or, as the case may be, the State Commission, referred to in sub-section (1), shall, also include, its activities under this section, in the annual report referred to in section 16 of the Commissions for Protection of Save Young India Act, 2005.'));
    sections.add(new Section(
        'Section 45',
        'Power to make rules',
        '1.     The Central Government may, by notification in the Official Gazette, make rules for carrying out the purposes of this Act.\n\n2.     In particular, and without prejudice to the generality of the foregoing powers, such rules may provide for all or any of the following matters, namely:-\n\na.     the qualifications and experience of, and the fees payable to, a translator or an interpreter, a special educator or any person familiar with the manner of communication of the child or an expert in that field, under sub-section (4) of section 19; sub-sections (2) and (3) of section 26 and section 38;\n\nb.    care and protection and emergency medical treatment of the child under sub-section (5) of section 19;\n\nc.     the payment of compensation under sub-section (8) of section 33;\n\n'
            'd.    the manner of periodic monitoring of the provisions of the Act under sub-section (1) of section 44.\n\n3.     Every rule made under this section shall be laid, as soon as may be after it is made, before each House of Parliament, while it is in session, for a total period of thirty days which may be comprised in one session or in two or more successive sessions, and if, before the expiry of the session immediately following the session or the successive sessions aforesaid, both Houses agree in making any modification in the rule or both Houses agree that the rule should not be made, the rule shall thereafter have effect only in such modified form or be of no effect, as the case may be; so, however, that any such modification or annulment shall be without prejudice to the validity of anything previously done under that rule.'));
    sections.add(new Section('Section 46', 'Power to remove difficulties',
        '1.     If any difficulty arises in giving effect to the provisions of this Act, the Central Government may, by order published in the Official Gazette, make such provisions not inconsistent with the provisions of this Act as may appear to it to be necessary or expedient for removal of the difficulty:\n\nProvided that no order shall be made under this section after the expiry of the period of two years from the commencement of this Act.\n\n2.     Every order made under this section shall be laid, as soon as may be after it is made, before each House of Parliament.'));
    return sections;
  }
}

class Item {
  final Container _container;
  bool selected;

  Item(this._container, this.selected);
}
