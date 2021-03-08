import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:rights_of_child/database/DatabasePage.dart';
import 'package:rights_of_child/user_details.dart';

class AdditionalDetails extends StatefulWidget {
  final Data userData;

  const AdditionalDetails({Key key, this.userData}) : super(key: key);
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  String _selectedDate = 'Select DOB';
  GlobalKey<FormState> _formKey = GlobalKey();
  String phoneNumber, Email, username;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 15),
      firstDate: DateTime(1920),
      lastDate: DateTime(DateTime.now().year - 15),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'You must be atleast 15 years of age to continue...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1f186f),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'DOB : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
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
                        tooltip: 'Select your DOB',
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.userData.loginType == 'twitter'
                      ? TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText:
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(emailController.text)
                                    ? null
                                    : 'Invalid Email Address',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          controller: emailController,
                          onChanged: (email) {
                            setState(() {
                              Email = emailController.text;
                            });
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  widget.userData.loginType == 'credentials'
                      ? TextField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            errorText: usernameController.text.trim().length >
                                        3 ||
                                    usernameController.text.trim().length < 1
                                ? null
                                : 'Atleast 3 characters required',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          maxLength: 30,
                          controller: usernameController,
                          onChanged: (name) {
                            setState(() {
                              username = usernameController.text;
                            });
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  // IntlPhoneField(
                  //   controller: phoneController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Phone Number',
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(),
                  //     ),
                  //   ),
                  //   onChanged: (phone) {
                  //     //print(phone.completeNumber);
                  //     setState(() {
                  //       phoneNumber = phone.completeNumber;
                  //     });
                  //   },
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Builder(
                      builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 30),
                          child: ButtonTheme(
                            minWidth: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              color: Color(0xFF1f186f),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'NEXT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () async {
                                if (widget.userData.loginType == 'twitter') {
                                  if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(emailController.text) &&
                                      _selectedDate != 'Select DOB') {
                                    Data currentUserData = new Data(
                                      id: widget.userData.id,
                                      userEmail:
                                          widget.userData.loginType == 'twitter'
                                              ? emailController.text
                                              : widget.userData.userEmail,
                                      userName: widget.userData.userName,
                                      profileImageUrl:
                                          widget.userData.profileImageUrl,
                                      loginType: widget.userData.loginType,
                                      dob: _selectedDate,
                                      countryCode: '',
                                      telephone: '',
                                      connectType: widget.userData.connectType,
                                      password: widget.userData.password,
                                    );
                                    await FlutterSession()
                                        .set('currentUser', currentUserData);
                                    await FlutterSession()
                                        .set('isLoggedIn', false);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PhpConnect(
                                                  userData: currentUserData,
                                                )));
                                  } //all ok twitter signup
                                  else {
                                    final snackBar = SnackBar(
                                      content: _selectedDate == 'Select DOB'
                                          ? Text('Select your DOB!')
                                          : Text('Enter valid Email Address!'),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {},
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } //no dob selected
                                } //logged in twitter
                                else if (widget.userData.loginType ==
                                    'credentials') {
                                  if (usernameController.text.trim().length >
                                          3 &&
                                      _selectedDate != 'Select DOB') {
                                    Data currentUserData = new Data(
                                      id: widget.userData.id,
                                      userEmail:
                                          widget.userData.loginType == 'twitter'
                                              ? emailController.text
                                              : widget.userData.userEmail,
                                      userName: username,
                                      profileImageUrl:
                                          widget.userData.profileImageUrl,
                                      loginType: widget.userData.loginType,
                                      dob: _selectedDate,
                                      countryCode: '',
                                      telephone: '',
                                      connectType: widget.userData.connectType,
                                      password: widget.userData.password,
                                    );
                                    await FlutterSession()
                                        .set('currentUser', currentUserData);
                                    await FlutterSession()
                                        .set('isLoggedIn', false);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PhpConnect(
                                                  userData: currentUserData,
                                                )));
                                  } //all ok credential signup
                                  else {
                                    final snackBar = SnackBar(
                                      content: _selectedDate == 'Select DOB'
                                          ? Text('Select your DOB!')
                                          : Text(
                                              'Please fill all the details!'),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {},
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } //no dob selected
                                } else {
                                  Data currentUserData = new Data(
                                    id: widget.userData.id,
                                    userEmail: widget.userData.userEmail,
                                    userName: widget.userData.userName,
                                    profileImageUrl:
                                        widget.userData.profileImageUrl,
                                    loginType: widget.userData.loginType,
                                    dob: _selectedDate,
                                    countryCode: '',
                                    telephone: '',
                                    connectType: widget.userData.connectType,
                                    password: widget.userData.password,
                                  );

                                  await FlutterSession()
                                      .set('currentUser', currentUserData);
                                  await FlutterSession()
                                      .set('isLoggedIn', false);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PhpConnect(
                                            userData: currentUserData,
                                          )));
                                } //logged in facebook & google
                              },
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
