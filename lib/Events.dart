import 'dart:convert';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

final _formKey = GlobalKey<FormState>();

class _EventsPageState extends State<EventsPage> {
  String eventName, eventDescription;
  String _selectedDate = 'Select Date';
  String _selectedDate2 = 'Select Date';
  DateTime from = DateTime.now();
  DateTime to;
  bool isAllDay;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay _time2 = TimeOfDay.now();

  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventDiscriptionController =
      new TextEditingController();

  List meetings = <Meeting>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEvents();
  }

  _getEvents() async {
    String url =
        'https://delicioustechnoworld.com/get_event_ebrbeiurgnoerngioeroingoierg.php';
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
    List<Meeting> meetingsk = <Meeting>[];
    for (int i = 0; i < profile.length; i++) {
      final DateTime day = DateFormat("MMMM d, yyyy").parse(profile[i]['date']);
      int startHour = DateTime.parse(profile[i]['from']).hour;
      int startMinute = DateTime.parse(profile[i]['from']).minute;
      int startSecond = DateTime.parse(profile[i]['from']).second;
      int endHour = DateTime.parse(profile[i]['to']).hour;
      int endMinute = DateTime.parse(profile[i]['to']).minute;
      int endSecond = DateTime.parse(profile[i]['to']).second;
      DateTime startTime = DateTime(
          day.year, day.month, day.day, startHour, startMinute, startSecond);
      DateTime endTime =
          DateTime(day.year, day.month, day.day, endHour, endMinute, endSecond);
      meetingsk.add(new Meeting(profile[i]['ename'], profile[i]['edesc'],
          startTime, endTime, const Color(0xFF1f186f), false));
    } //loop

    setState(() {
      meetings = meetingsk;
    });
    return meetings;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (d != null) {
      setState(() {
        _selectedDate2 = d.toString();
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
    } // => 2012-01-01 00:00:00.000
  }

  void onTimeChanged1(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      from = DateTime(
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(_selectedDate2).year,
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(_selectedDate2).month,
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(_selectedDate2).day,
          _time.hour,
          _time.minute);
    });
  }

  void onTimeChanged2(TimeOfDay newTime) {
    setState(() {
      _time2 = newTime;
      to = DateTime(
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(_selectedDate2).year,
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(_selectedDate2).month,
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(_selectedDate2).day,
          _time2.hour,
          _time2.minute);
    });
  }

  insertEvent() async {
    String url =
        'https://delicioustechnoworld.com/event_uiwhfuwienfiownqoiefoiwehfuoiwehfioejw.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg',
        'name': eventName,
        'description': eventDescription,
        'date': _selectedDate,
        'from': from.toString(),
        'to': to.toString(),
        'allDay': 'false',
      }),
    );
    final profile = jsonDecode(response.body);
  }

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
    return FutureBuilder(
        future: _getEvents(),
        builder: (context, snapshot1) {
          if (snapshot1.hasData) {
            return FutureBuilder(
                future: FlutterSession().get('currentUser'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      resizeToAvoidBottomPadding: false,
                      appBar: AppBar(
                        leading: Container(),
                        iconTheme: IconThemeData(
                          color: Color(0xFF1f186f),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          snapshot.data['loginType'] == 'credentials' &&
                                  snapshot.data['userName'].toString().compareTo(
                                          'Admin-biueIYBIYDIUSBDI#@#HBHDB') ==
                                      0
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Color(0xFF1f186f),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: Stack(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkResponse(
                                                        onTap: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        child: CircleAvatar(
                                                          child:
                                                              Icon(Icons.close),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 40),
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Event Title',
                                                                errorText: eventNameController.text.trim().length >
                                                                            3 ||
                                                                        eventNameController.text.trim().length <
                                                                            1
                                                                    ? null
                                                                    : 'Atleast 3 characters required',
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(),
                                                                ),
                                                              ),
                                                              maxLength: 100,
                                                              controller:
                                                                  eventNameController,
                                                              onChanged:
                                                                  (name) {
                                                                setState(() {
                                                                  eventName =
                                                                      eventNameController
                                                                          .text;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Event Description',
                                                                errorText: eventDiscriptionController.text.trim().length >
                                                                            50 ||
                                                                        eventDiscriptionController.text.trim().length <
                                                                            1
                                                                    ? null
                                                                    : 'Atleast 50 characters required',
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(),
                                                                ),
                                                              ),
                                                              maxLength: 150,
                                                              maxLines: 3,
                                                              controller:
                                                                  eventDiscriptionController,
                                                              onChanged:
                                                                  (name) {
                                                                setState(() {
                                                                  eventDescription =
                                                                      eventDiscriptionController
                                                                          .text;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      border:
                                                                          Border(
                                                                        top: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        left: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        right: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        bottom: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5))),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: <
                                                                      Widget>[
                                                                    InkWell(
                                                                      child: Text(
                                                                          _selectedDate,
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style:
                                                                              TextStyle(color: Color(0xFF000000))),
                                                                      onTap:
                                                                          () {
                                                                        _selectDate(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .calendar_today),
                                                                      tooltip:
                                                                          '',
                                                                      onPressed:
                                                                          () {
                                                                        _selectDate(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      border:
                                                                          Border(
                                                                        top: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        left: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        right: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        bottom: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5))),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    showPicker(
                                                                      context:
                                                                          context,
                                                                      value:
                                                                          _time,
                                                                      onChange:
                                                                          onTimeChanged1,
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "From",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      border:
                                                                          Border(
                                                                        top: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        left: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        right: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                        bottom: BorderSide(
                                                                            width:
                                                                                1.0,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5))),
                                                              child: FlatButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    showPicker(
                                                                      context:
                                                                          context,
                                                                      value:
                                                                          _time2,
                                                                      onChange:
                                                                          onTimeChanged2,
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "To",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: RaisedButton(
                                                              child: Text(
                                                                  "Submit"),
                                                              onPressed: () {
                                                                if (eventName != '' &&
                                                                    eventName !=
                                                                        null &&
                                                                    eventDescription !=
                                                                        null &&
                                                                    eventDescription !=
                                                                        '' &&
                                                                    _selectedDate !=
                                                                        'Select Date' &&
                                                                    _selectedDate2 !=
                                                                        'Select Date' &&
                                                                    _selectedDate2 !=
                                                                        '' &&
                                                                    _selectedDate2 !=
                                                                        null &&
                                                                    _selectedDate !=
                                                                        '' &&
                                                                    _selectedDate !=
                                                                        null &&
                                                                    from.toString() !=
                                                                        'null' &&
                                                                    from.toString() !=
                                                                        '' &&
                                                                    to.toString() !=
                                                                        'null' &&
                                                                    to.toString() !=
                                                                        '') {
                                                                  insertEvent();
                                                                  setState(() {
                                                                    eventName =
                                                                        '';
                                                                    eventNameController
                                                                        .text = '';
                                                                    eventDescription =
                                                                        '';
                                                                    eventDiscriptionController
                                                                        .text = '';
                                                                    _selectedDate =
                                                                        'Select Date';
                                                                    _selectedDate2 =
                                                                        'Select Date';
                                                                    from = DateTime
                                                                        .now();
                                                                    to = null;
                                                                    isAllDay =
                                                                        false;
                                                                    _time =
                                                                        TimeOfDay
                                                                            .now();
                                                                    _time2 =
                                                                        TimeOfDay
                                                                            .now();
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  _getEvents();
                                                                } else {
                                                                  showAlertDialog(
                                                                      context,
                                                                      'Warning',
                                                                      'Please fill all the details!');
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                )
                              : Container(),
                        ],
                      ),
                      body: Container(
                        child: SfCalendar(
                          view: CalendarView.month,
                          initialSelectedDate: DateTime.now(),
                          dataSource: MeetingDataSource(meetings),
                          monthViewSettings: MonthViewSettings(
                            numberOfWeeksInView: 2,
                            showAgenda: true,
                            agendaViewHeight: 400,
                            agendaItemHeight: 70,
                            appointmentDisplayCount: 3,
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
            ;
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName.toString().toUpperCase() +
        '\n' +
        appointments[index].description;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.description, this.from, this.to, this.background,
      this.isAllDay);

  String eventName;
  String description;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
