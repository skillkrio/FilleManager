import 'package:filemanager/main.dart';
import 'package:filemanager/utils/utility.dart';
import 'package:filemanager/view/dummy.dart';
import 'package:filemanager/view/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  var box = Hive.box('credentials');
  @override
  void initState() {
    requestPermission();
    // TODO: implement initState
    // requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  LoginScreen();
                },
                child: const Text(
                  "Tippil",
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Minimal File Manager",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
      ),
    );
  }

  Future<void> requestPermission() async {
    PermissionStatus permissonStatus = await Permission.storage.request();
    if (permissonStatus == PermissionStatus.granted) {
      await Future.delayed(Duration(seconds: 2), null);
      LoginScreen();
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      // print("granted");
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Utility.showAlertDialog(
        context,
        "Permission Denied",
        "Please grant storage permission to use this app",
      );
    }
  }

  Future<dynamic> LoginScreen() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 30),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Verification")],
              ),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "Please Enter the User Name",
                          labelText: 'UserName',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          if (value!.length == 0)
                            return "Fields can't be empty";
                          if (value.length > 15) return 'Password too long';

                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passWordController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "Please Enter the password",
                          labelText: 'password',
                        ),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String? value) {
                          if (value!.length == 0)
                            return "Fields can't be empty";
                          if (value.length > 15) return 'Password too long';

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("success");
                            } else {
                              print("failure");
                              return;
                            }
                            if (box.get("firstTimeLogged") == null) {
                              box.put("userName", userNameController.text);
                              box.put("passWord", passWordController.text);
                              box.put("firstTimeLogged", false);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            } else {
                              if (box.get("userName") ==
                                      userNameController.text &&
                                  box.get("passWord") ==
                                      passWordController.text) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Wrong Credentials"),
                                  ),
                                );
                              }
                            }
                          },
                          child: box.get("firstTimeLogged") == null
                              ? Text("Create ")
                              : Text("Login")),
                    ],
                  ),
                ),
              ]);
        });
  }
}

//  RichText(
//             text: const TextSpan(
//               text: 'Tippil\n',
//               style: TextStyle(
//                 fontSize: 50,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'Simple File Manager',
//                   style: TextStyle(
//                     fontSize: 50,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),