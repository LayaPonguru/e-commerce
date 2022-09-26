import 'dart:convert';

import 'package:ecommerce/constant_file.dart';
import 'package:ecommerce/image_gallery_screen.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var responseList = [];

  String userName = "";

  @override
  void initState() {
    getSharedPrefValues();
    super.initState();
  }

  void getSharedPrefValues() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("USER_NAME")!;
      //print('userName $userName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        title: Align(
          alignment: Alignment.center,
            child: Text(widget.title,)),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 45,
            margin: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: Focus(
              autofocus: false,
              child: TextField(
                keyboardType: TextInputType.text,
                cursorColor: primaryBlue,
                style:const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'OpenSans'),
                decoration: InputDecoration(
                  hintText: 'Select date and time',
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      //color: primaryBlue,
                      fontSize: 14,
                      fontFamily: 'OpenSans'),
                  prefixIcon: const Icon(Icons.calendar_month_rounded, color: Colors.black38, size: 25,),
                  border: InputBorder.none,
                  suffixIcon: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      Container(width: 1, height: 30, color: Colors.grey.shade400,),
                      const SizedBox(width: 7,),
                      Image.asset('assets/images/control.png', width: 25, height: 20, fit: BoxFit.fitWidth,),
                        const SizedBox(width: 7,),
                    ],),
                  )
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: DrawerHeader(
                    padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 8.0),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        colors: [
                          primaryBlue,
                          primaryBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 35.0,
                          child: Image.asset(
                            'assets/images/e_logo.png',
                            width: 50,
                            height: 50,
                            //fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Text(userName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    )),
              ),
              Flexible(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    /*UserAccountsDrawerHeader(
                accountName: Text("John Doe"),
                accountEmail: Text("johndoe@email.com"),
                currentAccountPicture: GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(mainProfilePic),
                      ),
                      onTap: () => print("Current User")
                ),

                //.. This line of code provides the usage of multiple accounts
                /* otherAccountsPictures: <Widget>[
              GestureDetector(
                onTap: ()=> switchUser(),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(otherProfilePic)
                ),
              ),
            ], */

                decoration: BoxDecoration(
                  image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage("https://png.pngtree.com/thumb_back/fh260/background/20190828/pngtree-dark-vector-abstract-background-image_302715.jpg")
                  ),
                ),
              ),*/

                    //Home
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        leading: const Icon(
                          Icons.home_outlined,
                          size: 25,
                          color: primaryBlue,
                        ),
                        title: const Text("Home",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500
                          ),),
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    //About Me & Add students
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        leading: const Icon(
                          Icons.image_outlined,
                          size: 25,
                          color: primaryBlue,
                        ),
                        title: const Text("Image Gallary",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500
                          ),),
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const ImageGallery(title: 'Image gallery',),
                          ));
                        },
                      ),
                    ),


                    //Logout
                    SizedBox(
                      height: 45,
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout,
                          size: 25,
                          color: primaryBlue,
                        ),
                        title: const Text("Logout",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500
                          ),),
                        onTap: () => _showDialogLogout(),
                      ),
                    ),

                  ],
                ),
              )
            ],
          )),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: GestureDetector(
                child: Container(
                  height: 50,
                  color: primaryGreen,
                  child: const Align(
                    child: Text(
                      "Optimize route",
                      style:TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OpenSans'),
                    ),
                  ),
                ),
              )
          ),
          Expanded(
              child: GestureDetector(
                child: Container(
                  height: 50,
                  color: primaryRed,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Reset",
                      style:TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OpenSans'),
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                    child: Row(
                      children: const [
                        Text(
                          "Destination Zip Code: ",
                          style:TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 13,
                              fontFamily: 'OpenSans'),
                        ),
                        Expanded(
                          child: Text(
                            "25949",
                            style:TextStyle(
                                fontWeight: FontWeight.w500,
                                color: primaryBlue,
                                fontSize: 14,
                                fontFamily: 'OpenSans',
                              decoration: TextDecoration.underline,),
                            maxLines: 1,
                          ),
                        )
                      ],
                    )
                ),
                const Expanded(
                  flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Bulk Dispatch",
                        style:TextStyle(
                          fontWeight: FontWeight.w500,
                          color: primaryBlue,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          decoration: TextDecoration.underline,),
                      ),
                    )
                )
              ],
            ),
            const SizedBox(height: 10,),
            FutureBuilder(
                future: _fetchList(),
                builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                snapshot.hasData
                    ? Flexible(
                      child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  // render the list
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) => Card(
                      margin: const EdgeInsets.fromLTRB(0,5,0,5),
                      // render list item
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                    child: Text(
                                        snapshot.data![index]["name"].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: primaryBlue,
                                          fontSize: 16,
                                          fontFamily: 'OpenSans'),
                                      maxLines: 1,
                                    ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    snapshot.data![index]["field_of_expertise"].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'OpenSans'),
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7,),
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.phone, size: 20, color: primaryBlue,),
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Text(
                                              snapshot.data![index]["phone_no"].toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'OpenSans',
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.mail_outline, size: 20, color: primaryBlue,),
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Text(
                                              snapshot.data![index]["email"].toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'OpenSans',
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_city, size: 20, color: primaryBlue,),
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Text(
                                              (snapshot.data![index]["address"].toString() != "" ? snapshot.data![index]["address"].toString()+ ", " : "")
                                              + snapshot.data![index]["state"].toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'OpenSans',
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                        "assets/images/call.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            const Divider(thickness: 1,),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    "Rank : " + snapshot.data![index]["ranking"].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'OpenSans'),
                                    maxLines: 1,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.star, size: 20, color: primaryGreen,),
                                      const SizedBox(width: 5,),
                                      Text(
                                        snapshot.data![index]["rating"].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'OpenSans'),
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ),
                    )
                    : const Center(
                  // render the loading indicator
                  child: CircularProgressIndicator(),
                )
            )
          ],
        ),
      )
    );
  }

  // Loading the list data
  Future<List> _fetchList() async {
    final prefs = await SharedPreferences.getInstance();

    var authKey = prefs.getString("ACCESS_TOKEN").toString();
    //print("authKey-- $authKey");

    var getListUrl = Uri.parse(LIST_URL);
    //print(getListUrl);

    await http.get(
      getListUrl,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $authKey",
      },
    ).then((response) {

      print(response.body.toString());
      // String Response
      String responseBody = utf8.decoder.convert(response.bodyBytes).trim();
      //print(responseBody);
      // Convert to json
      var responseData = json.decode(responseBody);
      //print(responseData.toString());

      //print("*************************************");

      responseList = responseData["data"];
      //print(responseList.toString());

    });

    return responseList;
  }

  // Dialog to get confirmation for Logout
  _showDialogLogout(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0),),
            ),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      const Icon(
                        Icons.logout,
                        size: 25,
                        color: primaryBlue,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      new Text(
                        "Logout",
                        style: const TextStyle(
                            color: primaryBlue,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 70,
                    child: new Text(
                      "Do you want to logout from the application?",
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 70,
                            //height: 50,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26 ),
                              //color: Primary_Green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:  Text( "No",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                color: Colors.red[700],
                                fontSize: 14,
                              ),
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();

                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => const MyApp(),
                            ),
                                (route) => false,//if you want to disable back feature set to false
                          );

                          //userLogout();
                        },
                        child: Container(
                            width: 70,
                            //height: 50,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26 ),
                              //color: Primary_Green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:  const Text( "Yes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                color: primaryBlue,
                                fontSize: 14,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}