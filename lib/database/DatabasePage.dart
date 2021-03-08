import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:otp_screen/otp_screen.dart';
import 'package:rights_of_child/login.dart';
import 'package:rights_of_child/user_details.dart';
import 'package:rights_of_child/user_info.dart';

class PhpConnect extends StatefulWidget {
  final Data userData;

  const PhpConnect({Key key, this.userData}) : super(key: key);
  @override
  _PhpConnectState createState() => _PhpConnectState();
}

class _PhpConnectState extends State<PhpConnect> {
  var action;
  Random random = new Random();
  int randomNumber;

  sendEmailOTP() async {
    String url =
        'https://delicioustechnoworld.com/send_mail_bfuerbfiebfiuebiufberyifberyber.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'fniuNIUNI7887*&*(JHBJHBUB*YY*(*()*HJJBibewnfiu387483k',
        'userEmail': widget.userData.userEmail,
        'userName': widget.userData.userName,
        'otp': randomNumber.toString(),
      }),
    );
    final res = jsonDecode(response.body);
    if (res[0]['action'].toString() == 'otp send') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VerifyOTP(
                userData: widget.userData,
                originalOTP: randomNumber.toString(),
              )));
    }
    setState(() {
      action = res[0]['action'].toString();
    });
  }

  verifyData() async {
    String url =
        'https://delicioustechnoworld.com/dhbviwubvswiubvuiewnvsuindiuir.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg',
        'AccountId': widget.userData.id,
        'userEmail': widget.userData.userEmail,
        'userName': widget.userData.userName,
        'profileImageUrl': widget.userData.profileImageUrl,
        'loginType': widget.userData.loginType,
        'dob': widget.userData.dob,
        'telephone': widget.userData.telephone,
        'countryCode': widget.userData.countryCode,
        'connectType': widget.userData.connectType,
        'password': widget.userData.password,
      }),
    );
    final profile = jsonDecode(response.body);
    setState(() {
      action = profile[0]['action'].toString();
    });
    Data currentUserData = new Data(
      id: profile[0]['account_id'].toString(),
      userEmail: profile[0]['email'].toString(),
      userName: profile[0]['name'].toString(),
      profileImageUrl: profile[0]['profile'].toString(),
      loginType: profile[0]['logintype'].toString(),
      dob: profile[0]['dob'].toString(),
      countryCode: profile[0]['cc'].toString(),
      telephone: profile[0]['telephone'].toString(),
      connectType: widget.userData.connectType,
      password: widget.userData.password,
    );
    await FlutterSession().set('currentUser', currentUserData);
    reDirectPage(action, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      randomNumber = random.nextInt(100000000);
    });
    widget.userData.loginType.toString().trim().compareTo('twitter'.trim()) ==
                0 &&
            widget.userData.connectType
                    .toString()
                    .trim()
                    .compareTo('login'.trim()) ==
                0
        ? verifyData()
        : sendEmailOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1f186f),
      body: Center(
        child: action != null
            ? Text('')
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class VerifyOTP extends StatefulWidget {
  final Data userData;
  final String originalOTP;

  const VerifyOTP({Key key, this.userData, this.originalOTP}) : super(key: key);
  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  var action = '';

  insertData() async {
    String url = 'https://delicioustechnoworld.com/838947bfjhebrfb283u9unj.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg',
        'AccountId': widget.userData.id,
        'userEmail': widget.userData.userEmail,
        'userName': widget.userData.userName,
        'profileImageUrl': widget.userData.profileImageUrl,
        'loginType': widget.userData.loginType,
        'dob': widget.userData.dob,
        'telephone': widget.userData.telephone,
        'countryCode': widget.userData.countryCode,
        'connectType': widget.userData.connectType,
        'password': widget.userData.password
      }),
    );
    final profile = jsonDecode(response.body);
    setState(() {
      action = profile[0]['action'].toString();
    });
  }

  verifyData() async {
    String url =
        'https://delicioustechnoworld.com/dhbviwubvswiubvuiewnvsuindiuir.php';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'key': 'uybfuoeabgiuebgieorbgioeurbgiurbgieewubfiuwefnurbg',
        'AccountId': widget.userData.id,
        'userEmail': widget.userData.userEmail,
        'userName': widget.userData.userName,
        'profileImageUrl': widget.userData.profileImageUrl,
        'loginType': widget.userData.loginType,
        'dob': widget.userData.dob,
        'telephone': widget.userData.telephone,
        'countryCode': widget.userData.countryCode,
        'connectType': widget.userData.connectType,
        'password': widget.userData.password,
      }),
    );

    final profile = jsonDecode(response.body);
    setState(() {
      action = profile[0]['action'].toString();
    });

    Data currentUserData = new Data(
        id: profile[0]['account_id'].toString(),
        userEmail: profile[0]['email'].toString(),
        userName: profile[0]['name'].toString(),
        profileImageUrl: profile[0]['profile'].toString(),
        loginType: profile[0]['logintype'].toString(),
        dob: profile[0]['dob'].toString(),
        countryCode: profile[0]['cc'].toString(),
        telephone: profile[0]['telephone'].toString(),
        connectType: widget.userData.connectType,
        password: widget.userData.password);
    await FlutterSession().set('currentUser', currentUserData);
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String> validateOtp(String otp) async {
    await Future.delayed(Duration(milliseconds: 2000));
    if (otp == widget.originalOTP) {
      widget.userData.connectType
                  .toString()
                  .trim()
                  .compareTo('signup'.trim()) ==
              0
          ? insertData()
          : verifyData();
      return null;
    } else {
      return "The entered Otp is wrong!";
    }
  }

  void moveToNextScreen(context) async {
    Future.delayed(Duration(seconds: 5), () {
      reDirectPage(action, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryColor: Color(0xFF1f186f),
                    accentColor: Color(0xFF1f186f),
                  ),
                  home: LoginScreen(),
                ),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF1f186f),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF4c41a3).withOpacity(.5),
                Color(0xFF4c41a3).withOpacity(.66),
              ],
            ),
          ),
        ),
      ),
      body: OtpScreen.withGradientBackground(
        topColor: Color(0xFF4c41a3).withOpacity(.5),
        bottomColor: Color(0xFF1f186f),
        otpLength: widget.originalOTP.length,
        validateOtp: validateOtp,
        routeCallback: moveToNextScreen,
        themeColor: Colors.white,
        titleColor: Colors.white,
        title: "OTP Verification",
        subTitle: "Enter the code sent to " + widget.userData.userEmail,
        icon: Image.asset(
          'assets/rc-logo.png',
        ),
      ),
    );
  }
}
