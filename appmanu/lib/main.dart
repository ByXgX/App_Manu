import 'dart:io';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';


String getDocumentsDirectory() {
  return Directory.systemTemp.path; // Cambia esto al directorio deseado
}

void main() {
  runApp(MyHomePage());
  final documentsPath = getDocumentsDirectory();
  final filePath = '$documentsPath/excel_file.xlsx';
  print('Ruta completa del archivo: $filePath');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void readExcelFile() async {
    var file = 'Path_to_pre_existing_Excel_File/excel_file.xlsx';
    var bytes = File(file).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print('Sheet Name: $table');
      if (excel.tables[table] != null) {
        print('Max Columns: ${excel.tables[table]!.maxColumns}');
        print('Max Rows: ${excel.tables[table]!.maxRows}');

        for (var row in excel.tables[table]!.rows) {
          for (var cell in row) {
            if (cell!.rowIndex != null && cell.columnIndex != null) {
              print('Cell ${cell.rowIndex}/${cell.columnIndex}');
            } else {
              print('Invalid cell data.');
            }

            final value = cell.value;
            final numFormat = cell.cellStyle?.numberFormat ?? NumFormat.standard_0;

            switch (value.runtimeType) {
              case TextCellValue:
                print('  Text: ${value.value}');
                break;
              case FormulaCellValue:
                print('  Formula: ${value.formula}');
                print('  Format: ${numFormat}');
                break;
              case IntCellValue:
                print('  Int: ${value.value}');
                print('  Format: ${numFormat}');
                break;
              // ... other cases for different cell value types
            }
          }
        }
      } else {
        print('Table is null or empty.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call the method to read the Excel file
    readExcelFile();

    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Reader Example'),
      ),
      body: Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
