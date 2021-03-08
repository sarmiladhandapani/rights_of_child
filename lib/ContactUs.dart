import 'package:flutter/material.dart';
import 'package:rights_of_child/contact.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFF1f186f),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xffe6e2ff),
        body: ContactUs(
          cardColor: Colors.white,
          textColor: Color(0xFF1f186f),
          email: 'cr.appchildrights@gmail.com',
          companyName: 'Save Young India',
          companyColor: Color(0xFF1f186f),
          phoneNumber: '+918344819100',
          //website: 'https://delicioustechnoworld.com',
          //githubUserName: 'sarmiladhandapani',
          //linkedinURL: 'https://www.linkedin.com/in/sarmiladhandapani/',
          taglineColor: Color(0xFF1f186f),
          //twitterHandle: '',
          //instagram: '_abhishek_doshi',
        ),
      ),
    );
  }
}
