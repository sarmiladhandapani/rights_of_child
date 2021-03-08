import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';

class VolunteerPage extends StatefulWidget {
  @override
  _VolunteerPageState createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController designationController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController otherController = new TextEditingController();

  String _selectedSupportType;
  String _selectedState;
  bool checkedValue = false;
  String phoneNumber;

  _insertVolunteer(BuildContext context) async {
    var uri = Uri.parse(
        'https://delicioustechnoworld.com/volunteer_add_rierngeruignwei43un53u54nr.php');
    var request = http.MultipartRequest("POST", uri);
    request.fields['key'] =
        'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg';
    var currentUser = await FlutterSession().get('currentUser');
    request.fields['userid'] = currentUser['id'];
    request.fields['logintype'] = currentUser['loginType'];
    request.fields['name'] = nameController.text;
    request.fields['designation'] = designationController.text;
    request.fields['company'] = companyController.text;
    request.fields['mobile'] = phoneNumber;
    request.fields['email'] = emailController.text;
    request.fields['supportType'] = _selectedSupportType;
    request.fields['state'] = _selectedState;
    request.fields['district'] = districtController.text;
    request.fields['address'] = addressController.text;
    request.fields['other_details'] = otherController.text;
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    var respString = jsonDecode(respStr);
    if (respString[0]['action'].toString().trim().compareTo('sucess'.trim()) ==
        0) {
      showAlertDialog(context, 'Thanks for your support!',
          'You are successfully registered as a volunteer!');
      setState(() {
        nameController.text = '';
        designationController.text = '';
        companyController.text = '';
        mobileController.text = '';
        emailController.text = '';
        districtController.text = '';
        addressController.text = '';
        otherController.text = '';
        checkedValue = false;
        phoneNumber = '';
      });
    } else {
      showAlertDialog(context, 'Something Wrong!', 'Please try again later!');
      setState(() {
        nameController.text = '';
        designationController.text = '';
        companyController.text = '';
        mobileController.text = '';
        emailController.text = '';
        districtController.text = '';
        addressController.text = '';
        otherController.text = '';
        checkedValue = false;
        phoneNumber = '';
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
                    'Volunteer Support',
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
                    controller: nameController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Your Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: nameController.text.trim().length > 3 ||
                              nameController.text.trim().length < 1
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
                    controller: designationController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Designation',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: designationController.text.trim().length > 3 ||
                              designationController.text.trim().length < 1
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
                    controller: companyController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Organization/Company Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: companyController.text.trim().length > 3 ||
                              companyController.text.trim().length < 1
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
                      //Save Young Indiaphone.completeNumber);
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
                    controller: emailController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText:
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(emailController.text)
                              ? null
                              : 'Invalid Email Address',
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
                      hint: Text('Support Type'),
                      value: _selectedSupportType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSupportType = newValue;
                        });
                      },
                      items: <String>[
                        'Technical Support',
                        'Vocational Training',
                        'Life Skill Training',
                        'Capacity Building Workshops',
                        'Sports Materials',
                        'IEC Materials',
                        'Books',
                        'Food and Clothing',
                        'Transport',
                        'CSR',
                        'Education of a Child',
                        'Health Services',
                        'Financial Support',
                        'Volunteer Support',
                        'Technological Support',
                        'Psychosocial Support',
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
                    controller: addressController,
                    minLines: 3,
                    maxLines: 7,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: addressController.text.trim().length > 15 ||
                              addressController.text.trim().length < 1
                          ? null
                          : 'Atleast 15 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: otherController,
                    minLines: 3,
                    maxLines: 7,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: 'Other Details',
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: otherController.text.trim().length > 50 ||
                              otherController.text.trim().length < 1
                          ? null
                          : 'Atleast 50 characters required',
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      tristate: 1 == 2,
                      activeColor: Colors.green.shade800,
                      value: checkedValue,
                      onChanged: (bool value) {
                        setState(() {
                          checkedValue = value;
                        });
                      },
                    ),
                    Flexible(
                      child: Text(
                        'I commit myself to the realization of Child Rights. I do not have any association with Tobacco, Alcohol or Junk Food industry either directly or indirectly',
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Builder(
                    builder: (context) => Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          bottom: 15,
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
                              if ((nameController.text.trim().length > 3 &&
                                      nameController.text != null) &&
                                  (designationController.text.trim().length >
                                          3 &&
                                      designationController.text != null) &&
                                  (companyController.text.trim().length > 3 &&
                                      companyController.text != null) &&
                                  (phoneNumber.trim().length > 10 &&
                                      phoneNumber != null) &&
                                  (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(emailController.text) &&
                                      emailController.text != null) &&
                                  (_selectedSupportType != null &&
                                      _selectedSupportType != '') &&
                                  (_selectedState != null &&
                                      _selectedState != '') &&
                                  (districtController.text.trim().length > 3 &&
                                      districtController.text != null) &&
                                  (addressController.text.trim().length > 15 &&
                                      addressController.text != null) &&
                                  (otherController.text.trim().length > 50 &&
                                      otherController.text != null) &&
                                  checkedValue) {
                                _insertVolunteer(context);
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
