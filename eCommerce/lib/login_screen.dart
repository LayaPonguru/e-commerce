import 'dart:convert';

import 'package:ecommerce/constant_file.dart';
import 'package:ecommerce/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerPhoneNo = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  bool _passwordVisible = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.white,
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: Center(
                child: Image.asset("assets/images/logo_text_remove_bg.png", width: size.width * 0.7,),
              )
            ),
            Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    const Text("Welcome User",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'OpenSans'),
                        maxLines: 1,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 7,),
                    const Text("Enter your details to login to your Account",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black38,
                            fontSize: 14,
                            fontFamily: 'OpenSans'),
                        maxLines: 1,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 35,),
                    TextField(
                      controller:
                      controllerPhoneNo,
                      enabled: true,
                      keyboardType: TextInputType.text,
                      cursorColor: primaryBlue,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'OpenSans'),
                      decoration: const InputDecoration(
                          hintText: 'Enter Username / Email ID',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              //color: primaryBlue,
                              fontSize: 16,
                              fontFamily: 'OpenSans'),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.account_circle_outlined, color: primaryBlue, size: 25,)
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: controllerPassword,
                      enabled: true,
                      obscureText: !_passwordVisible,
                      keyboardType: TextInputType.text,
                      cursorColor: primaryBlue,
                      style:const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'OpenSans'),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            //color: primaryBlue,
                            fontSize: 16,
                            fontFamily: 'OpenSans'),
                        border: const OutlineInputBorder(),
                        /*focusedBorder: const OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: primaryBlue)),*/
                        prefixIcon: const Icon(Icons.lock_outline, color: primaryBlue, size: 25,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryBlue,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: const Text("Forgot Password ?",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primaryBlue,
                                fontSize: 18,
                                fontFamily: 'OpenSans'),
                            maxLines: 1,
                            textAlign: TextAlign.center),
                      ),
                    )
                  ],
                ),
              )
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: (){
                    _validateLoginData(context);
                  },
                  child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(20),
                      color: primaryBlue,
                      child: const Text('LOGIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w900),
                      )),
                ),
              ),
            ),
          ],
        )
    );
  }


  // Doing basic validations on Login input data
  void _validateLoginData(BuildContext context) {
    if (controllerPhoneNo.text.isEmpty) {
      displaySnackBar("User Name cannot be empty.", "f");
    } else if (controllerPassword.text == "") {
      displaySnackBar("Password cannot be empty.", "f");
    } else if (controllerPassword.text.length != 8) {
      displaySnackBar("Password have to be 8 digits.", "f");
    }
    else {
      userLogin(controllerPhoneNo.text, controllerPassword.text);
    }
  }

  // Login API
  userLogin(String userName, String password) async {
    final prefs = await SharedPreferences.getInstance();

    var userLoginUrl = Uri.parse(LOGIN_URL);
    //print(userLoginUrl);

    var dataInput = {
      'phone_no': userName,
      'password': password,
    };

    String body = json.encode(dataInput);
    //print(body);

    await http
        .post(userLoginUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body)
        .then((response) {
      // String Response
      String responseBody = utf8.decoder.convert(response.bodyBytes).trim();
      //print(responseBody);
      // Convert to json
      var data = json.decode(responseBody);
      //print(data.toString());

      if(data.toString().contains("error")){
        displaySnackBar(data["error"], "f");
      } else {

        // If login success - Storing user data using shared preference and navigation to Home screen

        prefs.setString("ACCESS_TOKEN", data["access_token"].toString());
        prefs.setString("USER_ID", data["user_id"].toString());
        prefs.setString("USER_NAME", data["name"].toString());
        prefs.setString("TOKEN_TYPE", data["token_type"].toString());
        prefs.setString("UUID", data["uuid"].toString());
        prefs.setString("EXPIRE_IN", data["expires_in"].toString());
        prefs.setString("REFERAL_STATUS", data["referal_status"].toString());
        prefs.setBool("LOGGED_IN", true);

        displaySnackBar(data["message"], "t");

        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const HomeScreen(title: 'Ecommerce',),
          ),
              (route) => false,//if you want to disable back feature set to false
        );
      }
    });
  }

  // For displaying snackbar
  displaySnackBar(String msg, String t_f) {
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: t_f == 'f' ? primaryRed : primaryGreen,
      content: Text(
        msg,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}