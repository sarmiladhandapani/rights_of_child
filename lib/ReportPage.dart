import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _selectedDate = 'Incident Date';
  String _selectedViolationItem;
  String _selectedLocation;
  String _selectedState;
  bool checkedValue = false;
  String phoneNumber;
  TextEditingController ynameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController vnameController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController remarksController = new TextEditingController();

  File _image1, _image2, _image3, _image4;
  final picker1 = ImagePicker();
  final picker2 = ImagePicker();
  final picker3 = ImagePicker();
  final picker4 = ImagePicker();

  _insertReport(BuildContext context) async {
    var uri = Uri.parse(
        'https://delicioustechnoworld.com/report_bdfbnvdsfnoinb43ir4enfrior.php');
    var request = http.MultipartRequest("POST", uri);
    request.fields['key'] =
        'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg';
    var currentUser = await FlutterSession().get('currentUser');
    request.fields['userid'] = currentUser['id'];
    request.fields['logintype'] = currentUser['loginType'];
    request.fields['cname'] = ynameController.text;
    request.fields['mobile'] = phoneNumber;
    request.fields['vname'] = vnameController.text;
    request.fields['violation'] = _selectedViolationItem;
    request.fields['location'] = _selectedLocation;
    request.fields['state'] = _selectedState;
    request.fields['district'] = districtController.text;
    request.fields['city'] = cityController.text;
    request.fields['street'] = streetController.text;
    request.fields['remarks'] = remarksController.text;
    request.fields['isMyName'] = checkedValue.toString();
    request.fields['date'] = _selectedDate.toString();
    if (_image1 != null) {
      var pic = await http.MultipartFile.fromPath("image1", _image1.path);
      request.files.add(pic);
    }
    if (_image2 != null) {
      var pic = await http.MultipartFile.fromPath("image2", _image2.path);
      request.files.add(pic);
    }
    if (_image2 != null) {
      var pic = await http.MultipartFile.fromPath("image3", _image3.path);
      request.files.add(pic);
    }
    if (_image3 != null) {
      var pic = await http.MultipartFile.fromPath("image4", _image4.path);
      request.files.add(pic);
    }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    var respString = jsonDecode(respStr);
    if (respString[0]['action'].toString().trim().compareTo('sucess'.trim()) ==
        0) {
      showAlertDialog(context, 'Thanks for your support!',
          'Your report has been recorded!');
      setState(() {
        _image1 = null;
        _image2 = null;
        _image3 = null;
        _image4 = null;
        _selectedDate = 'Incident Date';
        checkedValue = false;
        phoneNumber = '';
        ynameController.text = '';
        mobileController.text = '';
        vnameController.text = '';
        districtController.text = '';
        cityController.text = '';
        streetController.text = '';
        remarksController.text = '';
      });
    } else {
      showAlertDialog(context, 'Something Wrong!', 'Please try again later!');
      setState(() {
        _image1 = null;
        _image2 = null;
        _image3 = null;
        _image4 = null;
        _selectedDate = 'Incident Date';
        checkedValue = false;
        phoneNumber = '';
        ynameController.text = '';
        mobileController.text = '';
        vnameController.text = '';
        districtController.text = '';
        cityController.text = '';
        streetController.text = '';
        remarksController.text = '';
      });
    }
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

  Future choiceImage1() async {
    final pickedImage = await picker1.getImage(source: ImageSource.gallery);
    setState(() {
      _image1 = File(pickedImage.path);
    });
  }

  Future choiceImage2() async {
    final pickedImage = await picker2.getImage(source: ImageSource.gallery);
    setState(() {
      _image2 = File(pickedImage.path);
    });
  }

  Future choiceImage3() async {
    final pickedImage = await picker3.getImage(source: ImageSource.gallery);
    setState(() {
      _image3 = File(pickedImage.path);
    });
  }

  Future choiceImage4() async {
    final pickedImage = await picker4.getImage(source: ImageSource.gallery);
    setState(() {
      _image4 = File(pickedImage.path);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFF1f186f),
          ),
        ),
        backgroundColor: Color(0xffe6e2ff),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Report an Incident',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: ynameController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Your Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: ynameController.text.trim().length > 3 ||
                              ynameController.text.trim().length < 1
                          ? null
                          : 'Atleast 3 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntlPhoneField(
                    controller: mobileController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (phone) {
                      //print(phone.completeNumber);
                      setState(() {
                        phoneNumber = phone.completeNumber;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: vnameController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Violator Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: vnameController.text.trim().length > 3 ||
                              vnameController.text.trim().length < 1
                          ? null
                          : 'Atleast 3 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.black),
                        left: BorderSide(width: 1.0, color: Colors.black),
                        right: BorderSide(width: 1.0, color: Colors.black),
                        bottom: BorderSide(width: 1.0, color: Colors.black),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          child: Text(_selectedDate,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF000000))),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          tooltip: 'Incident Date',
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.black),
                        left: BorderSide(width: 1.0, color: Colors.black),
                        right: BorderSide(width: 1.0, color: Colors.black),
                        bottom: BorderSide(width: 1.0, color: Colors.black),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: new DropdownButton<String>(
                      hint: Text('Violation Type'),
                      value: _selectedViolationItem,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedViolationItem = newValue;
                        });
                      },
                      items: <String>[
                        'Child Labor',
                        'Child Trafficking',
                        'Children without Parental Care',
                        'Child Abuse',
                        'Child Marriage',
                        'Missing Child',
                        'Child with special needs',
                        'Child living with AIDS',
                        'Child in need of Care and Protection',
                        'Child Affected by Substance Abuse',
                        'Child in Conflict with Law',
                        'Child in Poverty',
                        'Child Beggary',
                        'Street Children',
                        'Neglected Child',
                        'Run Away Child',
                        'Child affected by conflict and disaster',
                        'Child Refugees',
                        'Other',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.black),
                        left: BorderSide(width: 1.0, color: Colors.black),
                        right: BorderSide(width: 1.0, color: Colors.black),
                        bottom: BorderSide(width: 1.0, color: Colors.black),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: new DropdownButton<String>(
                      hint: Text('Location'),
                      value: _selectedLocation,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                      items: <String>[
                        'Home',
                        'Neighbour Home',
                        'Park/Playground',
                        'School',
                        'Tuition Centre',
                        'Public Transport',
                        'Public Place',
                        'Hotel/Restaurants',
                        'Social Media',
                        'Digital Media',
                        'Radio',
                        'Hospital',
                        'Law Enforcement Area',
                        'Children\'s Home',
                        'Traffic Signal',
                        'Other',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.black),
                        left: BorderSide(width: 1.0, color: Colors.black),
                        right: BorderSide(width: 1.0, color: Colors.black),
                        bottom: BorderSide(width: 1.0, color: Colors.black),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: new DropdownButton<String>(
                      hint: Text('State'),
                      value: _selectedState,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedState = newValue;
                        });
                      },
                      items: <String>[
                        'Andra Pradesh',
                        'Arunachal Pradesh',
                        'Assam',
                        'Bihar',
                        'Chhattisgarh',
                        'Goa',
                        'Gujarat',
                        'Haryana',
                        'Himachal Pradesh',
                        'Jammu and Kashmir',
                        'Jharkhand',
                        'Karnataka',
                        'Kerala',
                        'Madya Pradesh',
                        'Maharashtra',
                        'Manipur',
                        'Meghalaya',
                        'Mizoram',
                        'Nagaland',
                        'Orissa',
                        'Punjab',
                        'Rajasthan',
                        'Sikkim',
                        'Tamil Nadu',
                        'Telagana',
                        'Tripura',
                        'Uttaranchal',
                        'Uttar Pradesh',
                        'West Bengal',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: districtController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'District',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: districtController.text.trim().length > 3 ||
                              districtController.text.trim().length < 1
                          ? null
                          : 'Atleast 3 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cityController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'City',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: cityController.text.trim().length > 3 ||
                              cityController.text.trim().length < 1
                          ? null
                          : 'Atleast 3 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: streetController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Street',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: streetController.text.trim().length > 3 ||
                              streetController.text.trim().length < 1
                          ? null
                          : 'Atleast 3 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: remarksController,
                    minLines: 5,
                    maxLines: 25,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Remarks',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: remarksController.text.trim().length > 50 ||
                              remarksController.text.trim().length < 1
                          ? null
                          : 'Atleast 50 characters required',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 40,
                        ),
                        onPressed: () {
                          choiceImage1();
                        },
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(10),
                        child: _image1 == null
                            ? Center(child: Text('No image selected'))
                            : Image.file(_image1),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.highlight_remove,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _image1 = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 40,
                        ),
                        onPressed: () {
                          choiceImage2();
                        },
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(10),
                        child: _image2 == null
                            ? Center(child: Text('No image selected'))
                            : Image.file(_image2),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.highlight_remove,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _image2 = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 40,
                        ),
                        onPressed: () {
                          choiceImage3();
                        },
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(10),
                        child: _image3 == null
                            ? Center(child: Text('No image selected'))
                            : Image.file(_image3),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.highlight_remove,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _image3 = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 40,
                        ),
                        onPressed: () {
                          choiceImage4();
                        },
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(10),
                        child: _image4 == null
                            ? Center(child: Text('No image selected'))
                            : Image.file(_image4),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.highlight_remove,
                          size: 40,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _image4 = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      tristate: 1 == 2,
                      activeColor: Colors.green,
                      value: checkedValue,
                      onChanged: (bool value) {
                        setState(() {
                          checkedValue = value;
                        });
                      },
                    ),
                    Text('Send the complaint in my name'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Builder(
                    builder: (context) => Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          bottom: 20,
                        ),
                        child: ButtonTheme(
                          minWidth: double.infinity,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_image1 != null &&
                                  _image2 != null &&
                                  _image3 != null &&
                                  _image4 != null &&
                                  (ynameController.text != null &&
                                      ynameController.text != '' &&
                                      ynameController.text.trim().length > 3) &&
                                  (phoneNumber != null && phoneNumber != '') &&
                                  (vnameController.text != null &&
                                      vnameController.text != '' &&
                                      vnameController.text.trim().length > 3) &&
                                  (_selectedDate != 'Incident Date' &&
                                      _selectedDate != null &&
                                      _selectedDate != '') &&
                                  (_selectedViolationItem != null &&
                                      _selectedViolationItem != '') &&
                                  (_selectedLocation != null &&
                                      _selectedLocation != '') &&
                                  (_selectedState != null &&
                                      _selectedState != '') &&
                                  (districtController.text != null &&
                                      districtController.text != '' &&
                                      districtController.text.trim().length >
                                          3) &&
                                  (cityController.text != null &&
                                      cityController.text != '' &&
                                      cityController.text.trim().length > 3) &&
                                  (streetController.text != null &&
                                      streetController.text != '' &&
                                      streetController.text.trim().length >
                                          3) &&
                                  (remarksController.text != null &&
                                      remarksController.text != '' &&
                                      remarksController.text.trim().length >
                                          50) &&
                                  (_selectedDate != null &&
                                      _selectedDate != '' &&
                                      _selectedDate != 'Incident Date')) {
                                _insertReport(context);
                              } //if
                              else {
                                showAlertDialog(context, 'Warning',
                                    'Please fill all the required details');
                              }
                            },
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
