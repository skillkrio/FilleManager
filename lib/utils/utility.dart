import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Utility extends ChangeNotifier {
  //get the storage directory
  static Future<List<Directory>> getStorageList() async {
    List<Directory> dirList = (await getExternalStorageDirectories())!;
    List<Directory> filteredList = <Directory>[];
    for (Directory dir in dirList) {
      filteredList.add(removeDataDirectory(dir.path));
    }
    return filteredList;
  }

  static Directory removeDataDirectory(String path) {
    return Directory(path.split('Android')[0]);
  }

  static Future<List<FileSystemEntity>> getFilesAndFolder(String path) async {
    Directory dir = Directory(path);

    return dir.listSync();
  }

  static String getMime(String path) {
    File file = File(path);
    String mimeType = mime(file.path) ?? '';
    return mimeType;
  }

  static Future<void> openFile(String path, String mime) async {
    var filePath = path;

    final _result = await OpenFile.open(filePath, type: mime);
    print(_result.message);
  }

  static Future showAlertDialog(
      BuildContext context, String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
