import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Verification extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passWordController = TextEditingController();
  var box = Hive.box('credentials');
  Verification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                box.put("username", "krio");
              }),
          IconButton(
              icon: Icon(Icons.password),
              onPressed: () {
                print(box.get("username"));
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
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
                                if (value.length > 15)
                                  return 'Password too long';

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
                                if (value.length > 15)
                                  return 'Password too long';

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
                                  if (box.get("firstTimeLogged")) {
                                    box.put(
                                        "userName", userNameController.text);
                                    box.put(
                                        "passWord", passWordController.text);
                                    box.put("firstTimeLogged", false);
                                  } else {
                                    if (box.get("userName") ==
                                            userNameController.text &&
                                        box.get("passWord") ==
                                            passWordController.text) {
                                      Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Wrong Credentials"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: box.get("firstTimeLogged")
                                    ? Text("Create ")
                                    : Text("Login")),
                          ],
                        ),
                      ),
                    ]);
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
