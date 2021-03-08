import 'package:flutter/cupertino.dart';

class Data {
  final String id;
  final String profileImageUrl;
  final String userEmail;
  final String userName;
  final String loginType;
  final String dob;
  final String telephone;
  final String countryCode;
  final String connectType;
  final String password;
  Data(
      {this.profileImageUrl,
      this.userEmail,
      this.userName,
      this.id,
      this.loginType,
      this.dob,
      this.telephone,
      this.countryCode,
      @required this.connectType,
      this.password});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = this.id;
    data["profileImageUrl"] = this.profileImageUrl;
    data["userEmail"] = this.userEmail;
    data["userName"] = this.userName;
    data['loginType'] = this.loginType;
    data['dob'] = this.dob;
    data['telephone'] = this.telephone;
    data['countryCode'] = this.countryCode;
    data['connectType'] = this.connectType;
    data['password'] = this.password;
    return data;
  }
}
