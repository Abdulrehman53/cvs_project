import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/data_model.dart';

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
    for (int index = 0; index < csvData.length; index++) {
      rowDataSelected = [];
      rowDataUnSelected = [];
      for (int innerIndex = 0; innerIndex < csvData[index].length; innerIndex++) {
        ///Make true strings non selectable 
        if (innerIndex == 0) {
          rowDataSelected.add(csvData[index][innerIndex].title);
          rowDataUnSelected.add(csvData[index][innerIndex].title);
        } else {
          if (csvData[index][innerIndex].isSelected) {
            ///Selected data from user
            rowDataSelected.add(csvData[index][innerIndex].title);
          } else {
            ///Un-selected data from user
            rowDataUnSelected.add(csvData[index][innerIndex].title);
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
      final dir =
          await getExternalStorageDirectories(type: StorageDirectory.dcim);
      File file = File(dir![0].path + "/$fileName");
      Fluttertoast.showToast(
          msg: 'CSV files are stored in ${dir[0].path + '/$fileName'}',
          toastLength: Toast.LENGTH_LONG);
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
              child: const Text(
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
            padding: const EdgeInsets.all(8),
            height: 60,
            child: ListView.builder(
                itemCount: csvData[index].length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, innerIndex) {
                  return Card(
                    margin: const EdgeInsets.all(3),
                    child: InkWell(
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
                          padding: const EdgeInsets.all(8),
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
