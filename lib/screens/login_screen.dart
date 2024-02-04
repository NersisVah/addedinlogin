import 'dart:convert';

import 'package:autoroom_mobile/components/text_field_with_title_widget.dart';
import 'package:autoroom_mobile/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {
  String token = '';
  bool? isEmailValid;
  bool? isPasswordValid;
  String? _email;
  String? _password;
  bool obscureText = true;
  SharedPreferences? sharedPreferences;

  Future<http.Response> loginWithEmailAndPassword(
      String email, String password) async {
    String body = jsonEncode({'username': email, 'password': password});
    http.Response response = await http.post(
      Uri.parse(kAPIBasedUrl + '/login'),
      body: body,
    );
    return response;
  }
  void getInstance() async {
    sharedPreferences =  await SharedPreferences.getInstance();
    print(sharedPreferences!.getKeys());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Center(
              child: Text(
            'Login',
            style: kAppBarTextStyle,
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: ListView(
            children: [
              TextFieldWithTitle(
                isValid: isEmailValid,
                value: 'E-mail',
                validate: (inputText) {
                  if (EmailValidator.validate(inputText!) == true) {
                    setState(() {
                      isEmailValid = true;
                    });
                  } else {
                    setState(() {
                      isEmailValid = false;
                    });
                  }
                },
                onChanged: (inputText) {
                  setState(() {
                    _email = inputText;
                  });
                },
                errorText: 'Email is invalid',
                keyboardType: TextInputType.emailAddress,
              ),
              TextFieldWithTitle(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (obscureText == true) {
                            obscureText = false;
                          } else {
                            obscureText = true;
                          }
                        });
                      },
                      child: obscureText
                          ? Icon(
                              CupertinoIcons.eye_slash_fill,
                              color: Colors.white,
                            )
                          : Icon(
                              CupertinoIcons.eye_fill,
                              color: Colors.white,
                            )),
                ),
                isValid: isPasswordValid,
                value: 'Password',
                obscureText: obscureText,
                validate: (inputText) {
                  setState(() {
                    if (inputText!.length >= 6) {
                      isPasswordValid = true;
                    } else {
                      isPasswordValid = false;
                    }
                  });
                },
                onChanged: (inputText) {
                  setState(() {
                    _password = inputText;
                  });
                },
                errorText: 'Invalid Password',
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  fillColor: (isEmailValid == true && isPasswordValid == true)
                      ? kButtonColor
                      : Color(0xFF232131) /*Colors.grey*/,
                  constraints: BoxConstraints(minHeight: 50.0),
                  onPressed: (isEmailValid == true && isPasswordValid == true)
                      ? () async {
                          http.Response resp = await loginWithEmailAndPassword(
                              _email!, _password!);
                          if (resp.statusCode == 200) {
                            token = jsonDecode(resp.body)['token'];
                          } else if (resp.statusCode == 400) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Invalid username or password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          }
                          print(token);
                        }
                      : null,
                  child: Text(
                    'Login',
                    style: kAppBarTextStyle,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  fillColor: (isEmailValid == true && isPasswordValid == true)
                      ? kButtonColor
                      : Color(0xFF232131) /*Colors.grey*/,
                  constraints: BoxConstraints(minHeight: 50.0),
                  onPressed: (isEmailValid == true && isPasswordValid == true)
                      ? () async {
                        sharedPreferences!.setString('email', _email!);
                        sharedPreferences!.setString('password', _password!);

                          }

                      : null,
                  child: Text(
                    'Login',
                    style: kAppBarTextStyle,
                  ),
                ),
              ),

              Container(child: sharedPreferences == null ?Text('null') : sharedPreferences!.getString('email') == null ? Text('empty '):Text( '  ' + sharedPreferences!.getString('email')! + '  ' + sharedPreferences!.getString('password')! ),)
            ],
          ),
        ),
      ),
    );
  }
}
