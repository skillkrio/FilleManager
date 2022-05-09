import 'dart:io';

import 'package:filemanager/utils/utility.dart';
import 'package:flutter/foundation.dart';

class CentralProvider extends ChangeNotifier {
  int number = 0;

  void changeNumber() {
    number++;
    notifyListeners();
  }

  List<String> categories = [
    'Downloads',
    'Music',
    'Pictures',
    'Videos',
    'Documents hhhjhjkhkhkhkhkjhkh',
    'Other'
  ];

  Future<List<FileSystemEntity>> getAllFilesAndFolder() async {
    List<Directory> storageDrive = await Utility.getStorageList();
    List<FileSystemEntity> filesAndFolder =
        await Utility.getFilesAndFolder(storageDrive[0].path);
    return filesAndFolder;
  }
}
