import 'dart:convert' as JSON;
import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart' as fl;
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:rights_of_child/Get_Additional_Details.dart';
import 'package:rights_of_child/HomePage.dart';
import 'package:rights_of_child/database/DatabasePage.dart';
import 'package:rights_of_child/user_details.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final TextEditingController emailController2 = new TextEditingController();
  final TextEditingController passwordController2 = new TextEditingController();
  final TextEditingController forgetPassword = new TextEditingController();
  bool isLoggedIn = false;
  bool _isVisible1 = false;
  bool _isVisible2 = false;

  // bool _isLoggedIn = false;
  fl.FacebookLogin fbLogin = new fl.FacebookLogin();

  final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: '4oa6eJq76ayNPfP3bgPqa6UAZ',
    consumerSecret: 'CwY6JJCC7PPVlSAkL5G1K9NsJp2TLMobhVUbSS5s4LD0TtbhZq',
  );

  final googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      FlutterSession().get('isLoggedIn').then(
          (value) => value == null ? isLoggedIn = false : isLoggedIn = value);
      FlutterSession().set('isLoggedIn', isLoggedIn);
    });
    isLoggedIn
        ? Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Color(0xFF1f186f),
                  accentColor: Color(0xFF1f186f),
                ),
                home: HomePage(action: 'sucess'),
              ),
            ),
          )
        : null;
  }

  useGoogleApi() async {
    await googleSignIn.signIn();

    final authHeaders = await googleSignIn.currentUser.authHeaders;

    // custom IOClient from below
    final httpClient = GoogleHttpClient(authHeaders);

    var data = await PeopleApi(httpClient).people.connections.list(
          'people/me',
          personFields: 'names,addresses',
          pageSize: 100,
        );
    Data currentUserData = new Data(
      id: googleSignIn.currentUser.id.toString(),
      userEmail: googleSignIn.currentUser.email,
      userName: googleSignIn.currentUser.displayName,
      profileImageUrl: googleSignIn.currentUser.photoUrl,
      loginType: 'google',
      dob: '',
      countryCode: '',
      telephone: '',
      connectType: 'signup',
      password: '',
    );

    await FlutterSession().set('currentUser', currentUserData);
    await FlutterSession().set('isLoggedIn', false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdditionalDetails(
                  userData: currentUserData,
                )));
  }

  _logoutwithGoogle() async {
    await googleSignIn.signOut();
  }

  _loginWithTwitter() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    String newMessage;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        newMessage = 'Logged in! username: ${result.session.username}';
        Data currentUserData = new Data(
          id: result.session.userId,
          userEmail: '',
          userName: result.session.username,
          profileImageUrl: '',
          loginType: 'twitter',
          dob: '',
          countryCode: '',
          telephone: '',
          connectType: 'signup',
          password: '',
        );
        await FlutterSession().set('currentUser', currentUserData);
        await FlutterSession().set('isLoggedIn', false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdditionalDetails(
                      userData: currentUserData,
                    )));
        break;
      case TwitterLoginStatus.cancelledByUser:
        newMessage = 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        newMessage = 'Login error: ${result.errorMessage}';
        break;
    }

    setState(() {
      // _message = newMessage;
    });
  }

  _logoutTwitter() async {
    await twitterLogin.logOut();

    setState(() {
      // _message = 'Logged out.';
    });
  }

  _loginWithFacebook() async {
    final result = await fbLogin.logIn(['email']);

    switch (result.status) {
      case fl.FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        Data currentUserData = new Data(
          id: profile["id"],
          userEmail: profile["email"],
          userName: profile["name"],
          profileImageUrl: profile["picture"]["data"]["url"],
          loginType: 'facebook',
          dob: '',
          countryCode: '',
          telephone: '',
          connectType: 'signup',
          password: '',
        );
        await FlutterSession().set('currentUser', currentUserData);
        await FlutterSession().set('isLoggedIn', false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdditionalDetails(
                      userData: currentUserData,
                    )));
        break;

      case fl.FacebookLoginStatus.cancelledByUser:
        await FlutterSession().set('currentUser', null);
        await FlutterSession().set('isLoggedIn', false);
        break;
      case fl.FacebookLoginStatus.error:
        await FlutterSession().set('currentUser', null);
        await FlutterSession().set('isLoggedIn', false);
        break;
    }
  }

  _logoutWithFacebook() {
    fbLogin.logOut();
  }

  useGoogleApi_Login() async {
    await googleSignIn.signIn();

    final authHeaders = await googleSignIn.currentUser.authHeaders;

    // custom IOClient from below
    final httpClient = GoogleHttpClient(authHeaders);

    var data = await PeopleApi(httpClient).people.connections.list(
          'people/me',
          personFields: 'names,addresses',
          pageSize: 100,
        );
    print("UD: " + googleSignIn.currentUser.id.toString());
    Data currentUserData = new Data(
      id: googleSignIn.currentUser.id.toString(),
      userEmail: googleSignIn.currentUser.email,
      userName: googleSignIn.currentUser.displayName,
      profileImageUrl: googleSignIn.currentUser.photoUrl,
      loginType: 'google',
      dob: '',
      countryCode: '',
      telephone: '',
      connectType: 'login',
      password: '',
    );

    await FlutterSession().set('currentUser', currentUserData);
    await FlutterSession().set('isLoggedIn', false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhpConnect(
                  userData: currentUserData,
                )));
  }

  void _loginWithTwitter_Login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    String newMessage;

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        newMessage = 'Logged in! username: ${result.session.username}';
        Data currentUserData = new Data(
          id: result.session.userId,
          userEmail: '',
          userName: result.session.username,
          profileImageUrl: '',
          loginType: 'twitter',
          dob: '',
          countryCode: '',
          telephone: '',
          connectType: 'login',
          password: '',
        );
        await FlutterSession().set('currentUser', currentUserData);
        await FlutterSession().set('isLoggedIn', false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhpConnect(
                      userData: currentUserData,
                    )));
        //builder: (context) => DiscussionScreen(result.session.userId)));
        break;
      case TwitterLoginStatus.cancelledByUser:
        newMessage = 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        newMessage = 'Login error: ${result.errorMessage}';
        break;
    }

    setState(() {
      // _message = newMessage;
    });
  }

  _loginWithFacebook_Login() async {
    final result = await fbLogin.logIn(['email']);

    switch (result.status) {
      case fl.FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        Data currentUserData = new Data(
          id: profile["id"],
          userEmail: profile["email"],
          userName: profile["name"],
          profileImageUrl: profile["picture"]["data"]["url"],
          loginType: 'facebook',
          dob: '',
          countryCode: '',
          telephone: '',
          connectType: 'login',
          password: '',
        );
        await FlutterSession().set('currentUser', currentUserData);
        await FlutterSession().set('isLoggedIn', false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhpConnect(
                      userData: currentUserData,
                    )));
        //builder: (context) => DiscussionScreen(profile["id"])));
        break;

      case fl.FacebookLoginStatus.cancelledByUser:
        await FlutterSession().set('currentUser', null);
        await FlutterSession().set('isLoggedIn', false);
        break;
      case fl.FacebookLoginStatus.error:
        await FlutterSession().set('currentUser', null);
        await FlutterSession().set('isLoggedIn', false);
        break;
    }
  }

  _signupWithCredentials() async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String ran = String.fromCharCodes(Iterable.generate(
        10, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))).toString();
    Data currentUserData = new Data(
      id: DateTime.now().millisecondsSinceEpoch.toString() + ran,
      userEmail: emailController.text.trim().toString(),
      userName: '',
      profileImageUrl: '',
      loginType: 'credentials',
      dob: '',
      countryCode: '',
      telephone: '',
      connectType: 'signup',
      password: passwordController.text.trim().toString(),
    );
    await FlutterSession().set('currentUser', currentUserData);
    await FlutterSession().set('isLoggedIn', false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdditionalDetails(
                  userData: currentUserData,
                )));
  }

  _loginWithCredentials() async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String ran = String.fromCharCodes(Iterable.generate(
        10, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))).toString();
    Data currentUserData = new Data(
      id: DateTime.now().millisecondsSinceEpoch.toString() + ran,
      userEmail: emailController2.text.trim().toString(),
      userName: '',
      profileImageUrl: '',
      loginType: 'credentials',
      dob: '',
      countryCode: '',
      telephone: '',
      connectType: 'login',
      password: passwordController2.text.trim().toString(),
    );
    await FlutterSession().set('currentUser', currentUserData);
    await FlutterSession().set('isLoggedIn', false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhpConnect(
                  userData: currentUserData,
                )));
  }

  // ignore: non_constant_identifier_names
  Widget HomeP() {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF1f186f).withOpacity(.2),
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage('assets/images/mountains.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 150.0),
                  child: Center(
                    child: Image.asset(
                      'assets/rc-logo.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Save Young ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        " India",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 150.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new OutlineButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Color(0xFF00796b),
                          highlightedBorderColor: Colors.white,
                          onPressed: () => gotoSignup(),
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "SIGN UP",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF1f186f),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.white,
                          onPressed: () => gotoLogin(),
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "LOGIN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF1f186f),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SignupPage() {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.05), BlendMode.dstATop),
              image: AssetImage('assets/images/mountains.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 120.0, left: 120.0, right: 120.0, bottom: 50),
                  child: Center(
                    child: Image.asset(
                      'assets/rc-logo.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "EMAIL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1f186f),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: emailController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            errorText:
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(emailController.text) ||
                                        emailController.text.length < 1
                                    ? null
                                    : 'Invalid Email Address',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            hintText: 'abc@xyz.com',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "PASSWORD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1f186f),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          obscureText: !_isVisible1,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVisible1 = !_isVisible1;
                                });
                              },
                              child: Icon(
                                _isVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                            errorText:
                                RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(
                                                passwordController.text) ||
                                        passwordController.text.length < 1
                                    ? null
                                    : 'Invalid Password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 5,
                    left: 30,
                    right: 30,
                  ),
                  child: RichText(
                    text: TextSpan(
                        text: 'By signing up, you agree to our ',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Terms of Service',
                            style: TextStyle(
                                color: Color(0xFF1f186f), fontSize: 12),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL();
                              },
                          ),
                          TextSpan(
                              text: ' and that you have read our',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(
                            text: ' Privacy Policy',
                            style: TextStyle(
                                color: Color(0xFF1f186f), fontSize: 12),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL();
                              },
                          ),
                        ]),
                    softWrap: true,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: new FlatButton(
                        child: new Text(
                          "Already Have An Account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1f186f),
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        onPressed: gotoLogin,
                      ),
                    ),
                  ],
                ),
                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text) &&
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(passwordController.text)
                    ? new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 20.0),
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: Color(0xFF1f186f),
                                onPressed: _signupWithCredentials,
                                child: new Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 20.0,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "SIGN UP",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.all(8.0),
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.25)),
                        ),
                      ),
                      Text(
                        "OR CONNECT WITH",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.all(8.0),
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.25)),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(right: 8.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  color: Color(0Xff3B5998),
                                  onPressed: () => {},
                                  child: new Container(
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: new FlatButton(
                                            onPressed: _loginWithFacebook,
                                            padding: EdgeInsets.only(
                                              top: 20.0,
                                              bottom: 20.0,
                                            ),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Icon(
                                                  const IconData(0xea90,
                                                      fontFamily: 'icomoon'),
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 8.0),
                          alignment: Alignment.center,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new FlatButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  color: Color(0Xff00acee),
                                  onPressed: () => {},
                                  child: new Container(
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: new FlatButton(
                                            onPressed: _loginWithTwitter,
                                            padding: EdgeInsets.only(
                                              top: 20.0,
                                              bottom: 20.0,
                                            ),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Icon(
                                                  const IconData(0xea96,
                                                      fontFamily: 'icomoon'),
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // new Expanded(
                      //   child: new Container(
                      //     margin: EdgeInsets.only(left: 8.0),
                      //     alignment: Alignment.center,
                      //     child: new Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: <Widget>[
                      //         new Expanded(
                      //           child: new FlatButton(
                      //             shape: new RoundedRectangleBorder(
                      //               borderRadius:
                      //                   new BorderRadius.circular(30.0),
                      //             ),
                      //             color: Color(0Xffdb3236),
                      //             onPressed: () => {},
                      //             child: new Container(
                      //               child: new Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: <Widget>[
                      //                   new Expanded(
                      //                     child: new FlatButton(
                      //                       onPressed: useGoogleApi,
                      //                       padding: EdgeInsets.only(
                      //                         top: 20.0,
                      //                         bottom: 20.0,
                      //                       ),
                      //                       child: new Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.spaceEvenly,
                      //                         children: <Widget>[
                      //                           Icon(
                      //                             const IconData(0xea88,
                      //                                 fontFamily: 'icomoon'),
                      //                             color: Colors.white,
                      //                             size: 15.0,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget LoginPage() {
    return Scaffold(
      body: new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstATop),
            image: AssetImage('assets/images/mountains.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 100,
                  bottom: 50,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/rc-logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f186f),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        controller: emailController2,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          errorText:
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(emailController2.text) ||
                                      emailController2.text.length < 1
                                  ? null
                                  : 'Invalid Email Address',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: 'abc@xyz.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f186f),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextField(
                        obscureText: !_isVisible2,
                        controller: passwordController2,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isVisible2 = !_isVisible2;
                              });
                            },
                            child: Icon(
                              _isVisible2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          errorText:
                              RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                          .hasMatch(passwordController2.text) ||
                                      passwordController2.text.length < 1
                                  ? null
                                  : 'Invalid Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: new FlatButton(
                      child: new Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f186f),
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      onPressed: () => {showAlertDialog(context)},
                    ),
                  ),
                ],
              ),
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(emailController2.text) &&
                      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(passwordController2.text)
                  ? new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 50.0),
                      alignment: Alignment.center,
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new FlatButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              color: Color(0xFF1f186f),
                              onPressed: _loginWithCredentials,
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "LOGIN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.all(8.0),
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                    Text(
                      "OR CONNECT WITH",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.all(8.0),
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.only(right: 8.0),
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xff3B5998),
                                onPressed: () => {},
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new FlatButton(
                                          onPressed: _loginWithFacebook_Login,
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                const IconData(0xea90,
                                                    fontFamily: 'icomoon'),
                                                color: Colors.white,
                                                size: 15.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.only(left: 8.0),
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xff00acee),
                                onPressed: () => {},
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new FlatButton(
                                          onPressed: _loginWithTwitter_Login,
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Icon(
                                                const IconData(0xea96,
                                                    fontFamily: 'icomoon'),
                                                color: Colors.white,
                                                size: 15.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // new Expanded(
                    //   child: new Container(
                    //     margin: EdgeInsets.only(left: 8.0),
                    //     alignment: Alignment.center,
                    //     child: new Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: <Widget>[
                    //         new Expanded(
                    //           child: new FlatButton(
                    //             shape: new RoundedRectangleBorder(
                    //               borderRadius: new BorderRadius.circular(30.0),
                    //             ),
                    //             color: Color(0Xffdb3236),
                    //             onPressed: () => {},
                    //             child: new Container(
                    //               child: new Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   new Expanded(
                    //                     child: new FlatButton(
                    //                       onPressed: useGoogleApi_Login,
                    //                       padding: EdgeInsets.only(
                    //                         top: 20.0,
                    //                         bottom: 20.0,
                    //                       ),
                    //                       child: new Row(
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.spaceEvenly,
                    //                         children: <Widget>[
                    //                           Icon(
                    //                             const IconData(0xea88,
                    //                                 fontFamily: 'icomoon'),
                    //                             color: Colors.white,
                    //                             size: 15.0,
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog2(BuildContext context, String title, String content) {
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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget closeButton = FlatButton(
      child: Text("CLOSE"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget okButton = FlatButton(
      child: Text("SUBMIT"),
      onPressed: () async {
        if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(forgetPassword.text) &&
            forgetPassword.text.length > 1) {
          String url =
              'https://delicioustechnoworld.com/forget_pass_bYubYhbjbhjbHBYIUYYUY.php';
          final http.Response response = await http.post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'key': 'fniuNIUNI7887*&*(JHBJHBUB*YY*(*()*HJJBibewnfiu387483k',
              'fpmail': forgetPassword.text,
            }),
          );
          final res = jsonDecode(response.body);
          if (res[0]['action'].toString().compareTo('sucess') == 0) {
            showAlertDialog2(
                context, 'Success!', 'Check your email for password!');
          } else {
            showAlertDialog2(context, 'Warning', res[0]['action'].toString());
          }
        } else {
          showAlertDialog2(context, 'Warning', 'Invalid Email!');
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Forget Password'),
      content: Container(
        height: 100,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: forgetPassword,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  errorText:
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(forgetPassword.text) ||
                              forgetPassword.text.length < 1
                          ? null
                          : 'Invalid Email Address',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        closeButton,
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

  _launchURL() async {
    const url = 'https://delicioustechnoworld.com/privacy-policy.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  gotoSignup() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoLogin() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
//      child: new GestureDetector(
//        onHorizontalDragStart: _onHorizontalDragStart,
//        onHorizontalDragUpdate: _onHorizontalDragUpdate,
//        onHorizontalDragEnd: _onHorizontalDragEnd,
//        behavior: HitTestBehavior.translucent,
//        child: Stack(
//          children: <Widget>[
//            new FractionalTranslation(
//              translation: Offset(-1 - (scrollPercent / (1 / numCards)), 0.0),
//              child: SignupPage(),
//            ),
//            new FractionalTranslation(
//              translation: Offset(0 - (scrollPercent / (1 / numCards)), 0.0),
//              child: HomePage(),
//            ),
//            new FractionalTranslation(
//              translation: Offset(1 - (scrollPercent / (1 / numCards)), 0.0),
//              child: LoginPage(),
//            ),
//          ],
//        ),
//      ),
        child: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            LoginPage(),
            HomeP(),
            SignupPage(),
          ],
          scrollDirection: Axis.horizontal,
        ));
  }
}
