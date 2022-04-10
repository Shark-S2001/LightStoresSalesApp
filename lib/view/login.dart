
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/login.dart';

class LoginFunction extends StatefulWidget {
  const LoginFunction({Key? key}) : super(key: key);

  @override
  _LoginFunctionState createState() => _LoginFunctionState();
}

class _LoginFunctionState extends State<LoginFunction> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordVisible = true;

  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Close App',
          style: TextStyle(fontSize: 14, color: Colors.deepOrange),
        ),
        content: Text(
          'Are you sure you want to close the app ?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            ),
          ),
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            ),
          ),
        ],
      ),
    ) ??
        false; //if show dialog returns null, then return false
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          body:SafeArea(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child:  GestureDetector(
                child: Stack(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(250,250,235,0),
                                  Color.fromRGBO(250,250,235,0),
                                ]
                            )
                        ),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(30,70,30,0),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: height * 0.04,
                                      child: Text("Moon Investments Ltd",
                                        style: TextStyle(
                                            color: Colors.pinkAccent,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold
                                        ),)
                                  ),
                                  SizedBox(
                                    height: height * 0.04,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Sign In",
                                          style: TextStyle(
                                              color: Colors.pinkAccent,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.14,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Username",
                                          style: TextStyle(
                                              color:Colors.pinkAccent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                color:Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:Colors.black26,
                                                      blurRadius: 6,
                                                      offset: Offset(0,2)
                                                  )
                                                ]
                                            ),
                                            child: TextField(
                                              controller: username,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                suffixIcon:
                                                Icon(Icons.person_outline_rounded),
                                                hintText: "Username",
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.12,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Password",
                                          style: TextStyle(
                                              color:Colors.pinkAccent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              color:Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color:Colors.black26,
                                                    blurRadius: 6,
                                                    offset: Offset(0,2)
                                                )
                                              ]
                                          ),
                                          child: TextField(
                                            controller: password,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() => isPasswordVisible =
                                                    !isPasswordVisible);
                                                  },
                                                  icon: isPasswordVisible
                                                      ? Icon(Icons.visibility_off_rounded)
                                                      : Icon(Icons.visibility_rounded)),
                                              hintText: "Password",
                                            ),
                                            obscureText: isPasswordVisible,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.13,
                                    child:Container(
                                      padding: EdgeInsets.symmetric(vertical:25),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          SizedBox(width: MediaQuery.of(context).size.width*0.3,
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.login,color: Colors.pinkAccent,),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.white,

                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                )
                                            ),
                                            onPressed: (){
                                              if(username.text != "" && password.text !=""){

                                                  login(username.text,password.text,context);

                                              }else{
                                                if(username.text == ""){
                                                  Fluttertoast.showToast(
                                                      msg: "Username is required",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }else if(password.text == ""){
                                                  Fluttertoast.showToast(
                                                      msg: "Password is required",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }
                                              }
                                            },
                                            label: Text("Login",
                                              style: TextStyle(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),),
                                          SizedBox(width: MediaQuery.of(context).size.width*0.10,),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.width*0.35,
                                            width: MediaQuery.of(context).size.width*0.4,
                                            child:   TextButton(
                                                onPressed: () {},
                                                child: Text("Forgot Password ?"),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.pinkAccent,
                                                    textStyle: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: MaterialButton(
                                        onPressed: () => {},
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Visibility(
                                              child: Row(
                                                children: [
                                                  Text("Powered by:  ",
                                                    style: TextStyle(
                                                        color: Colors.pinkAccent,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.normal
                                                    ),),
                                                  Image.asset(
                                                    "images/logo.png",
                                                    width: 35,
                                                    height: 35,
                                                  )
                                                ],
                                              ),
                                              visible: isKeyboardShowing ? false : true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}

