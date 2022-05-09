import 'dart:io';

import 'package:filemanager/providers/central.dart';
import 'package:filemanager/utils/utility.dart';
import 'package:filemanager/view/folderview.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // static const platform = MethodChannel('samples.flutter.dev/battery');
  // Future<void> _getBatteryLevel() async {
  //   String batteryLevel;
  //   try {
  //     final int result = await platform.invokeMethod('getBatteryLevel');
  //     batteryLevel = 'Battery level at $result % .';
  //     print(batteryLevel);
  //   } on PlatformException catch (e) {
  //     batteryLevel = "Failed to get battery level: '${e.message}'.";
  //   }
  // }

  List<FileSystemEntity>? filesAndFolder;

  void initialze() async {
    List<Directory> storageDrive = await Utility.getStorageList();
    print(storageDrive);

    filesAndFolder = await Utility.getFilesAndFolder(storageDrive[0].path);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    // _getBatteryLevel();
    initialze();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final central = Provider.of<CentralProvider>(context);
    return filesAndFolder == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 / .3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      print(filesAndFolder![index] is Directory ? "yes" : "no");
                      if (filesAndFolder![index] is Directory) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return FolderView(
                              filePath: filesAndFolder![index].path);
                        }));
                      } else {
                        OpenResult res =
                            await OpenFilex.open(filesAndFolder![index].path);
                      }
                      // String mime =
                      //     Utility.getMime(filesAndFolder![index].path);
                      // Utility.openFile(filesAndFolder![index].path, mime);
                    },
                    child: ListTile(
                      focusColor: Colors.blue,
                      leading: filesAndFolder![index] is Directory
                          ? Icon(Icons.folder)
                          : Icon(Icons.insert_drive_file),
                      title: Text(filesAndFolder![index].path.split('/').last),
                    ),
                  );
                },
                itemCount: filesAndFolder!.length),
          );
  }
}
