import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data_model.dart';
import 'intro_slider/intro_slider_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: IntroSliderScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _data = [];
  List<List<DataModel>> csvData = [];
  List<List<String>> selectedData = [];

  List<String> rowDataSelected = [];
  List<String> rowDataUnSelected = [];
  List<List<String>> unSelectedData = [];

  Future<void> _genCSVs() async {
    for (int i = 0; i < csvData.length; i++) {
      rowDataSelected = [];
      rowDataUnSelected = [];
      for (int j = 0; j < csvData[i].length; j++) {
        if (j == 0) {
          rowDataSelected.add(csvData[i][j].title);
          rowDataUnSelected.add(csvData[i][j].title);
        } else {
          if (csvData[i][j].isSelected) {
            rowDataSelected.add(csvData[i][j].title);
          } else {
            rowDataUnSelected.add(csvData[i][j].title);
          }
        }
      }
      selectedData.add(rowDataSelected);
      unSelectedData.add(rowDataUnSelected);
    }
    storeCSV(selectedData, "similar_csv.csv");
    storeCSV(unSelectedData, "non_similar_csv.csv");
  }

  void storeCSV(List<List<String>> list, String fileName) async {
    if ((await Permission.storage.request().isGranted)) {
      /* final directory = await getTemporaryDirectory();
       //String p=directory.path;
       final String dirPath = directory.path.toString().substring(0,20);
       await Directory(dirPath).create(recursive: true);
       final String filePath = '$dirPath'+'$fileName';
       print(filePath);
       File file= File(filePath);
 final file = await File(await ('${getTemporaryDirectory()}'.create(recursive: true); */
      final dir = await getExternalStorageDirectories(type: StorageDirectory.dcim);
      print("dir $dir");
      String path = "$dir";

      File file = File(dir![0].path+ "/$fileName");
      Fluttertoast.showToast(msg: 'CSV files are stored in ${dir[0].path+ '/$fileName'}',toastLength: Toast.LENGTH_LONG);
      await file.writeAsString(const ListToCsvConverter().convert(list));
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  // This function is triggered when the floating button is pressed
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/inpu_list.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });
    for (int index = 0; index < _data.length; index++) {
      var innerData = _data[index][0].toString().split(';');
      List<DataModel> dataModels = [];
      for (String title in innerData) {
        dataModels.add(DataModel(isSelected: false, title: title));
      }
      csvData.add(dataModels);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CSV"),
        actions: [
          TextButton(
              onPressed: () {
                _genCSVs();
              },
              child: Text(
                "Generate CSVs",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      // Display the contents from the CSV file
      body: ListView.builder(
        itemCount: csvData.length,
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.all(8),
            height: 60,
            child: ListView.builder(
                itemCount: csvData[index].length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, innerIndex) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    // color: index == 0 ? Colors.amber : Colors.white,
                    child:
                        // Row(children: [

                        //   Text(_data[index][0].toString()),
                        //   //  Text(_data[index][1].toString()),
                        //   // Text(_data[index][2].toString()),
                        //   //  Text(_data[index][3].toString()),
                        //   //   Text(_data[index][4].toString()),

                        // ],)
                        InkWell(
                      onTap: () {
                        if (innerIndex != 0) {
                          setState(() {
                            csvData[index][innerIndex].isSelected =
                                !csvData[index][innerIndex].isSelected;
                          });
                        }
                      },
                      child: Container(
                          color: csvData[index][innerIndex].isSelected
                              ? Colors.red
                              : Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Text(csvData[index][innerIndex].title)),
                    ),
                  );
                }),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: _loadCSV),
    );
  }
}
