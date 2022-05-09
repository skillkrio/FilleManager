import 'dart:io';

import 'package:filemanager/utils/utility.dart';
import 'package:flutter/material.dart';

class FolderView extends StatefulWidget {
  final String filePath;
  const FolderView({Key? key, required this.filePath}) : super(key: key);

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  List<FileSystemEntity>? filesAndFolder;
  void initialze() async {
    print(widget.filePath);
    filesAndFolder = await Utility.getFilesAndFolder(widget.filePath);
    print(filesAndFolder);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    initialze();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.filePath.split('/').last),
      ),
      body: filesAndFolder == null
          ? Center(child: CircularProgressIndicator())
          : filesAndFolder!.length == 0
              ? Center(
                  child: Text(
                  "No Directory or Files Found",
                  style: TextStyle(fontFamily: 'RobotoMono', fontSize: 20),
                ))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1 / .3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return FolderView(
                              filePath: filesAndFolder![index].path);
                        }));
                      },
                      child: ListTile(
                        focusColor: Colors.blue,
                        leading: filesAndFolder![index] is Directory
                            ? Icon(Icons.folder)
                            : Icon(Icons.insert_drive_file),
                        title:
                            Text(filesAndFolder![index].path.split('/').last),
                      ),
                    );
                  },
                  itemCount: filesAndFolder!.length),
    );
  }
}
