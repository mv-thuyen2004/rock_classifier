import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class PushExcel extends StatefulWidget {
  const PushExcel({super.key});

  @override
  State<PushExcel> createState() => _PushExcelState();
}

class _PushExcelState extends State<PushExcel> {
  bool _isUpLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<File?> pickExcelFile() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    }

    Future<void> upLoadExcelToFirebase(File file) async {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null || sheet.rows.length < 2) return;

      final headers = sheet.rows.first
          .map(
            (e) => e?.value.toString(),
          )
          .toList();

      for (int i = 0; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        final Map<String, dynamic> data = {};

        for (int j = 0; j < headers.length; j++) {
          final key = headers[j];
          final value = row[j]?.value?.toString();
          data[key ?? 'field#j'] = value;
        }
        await FirebaseFirestore.instance.collection('_rocks').add(data);
      }
    }

    void handleUpLoad() async {
      setState(() {
        _isUpLoading = true;
      });
      final file = await pickExcelFile();
      if (file != null) {
        try {
          await upLoadExcelToFirebase(file);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Tải dữ liệu lên từ firebase thành công !")),
          );
        } catch (e) {
          print('ERROR : $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tải dữ liệu không thành công ! "),
            ),
          );
        }
      }
      setState(() {
        _isUpLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Up load firebse"),
      ),
      body: Center(
        child: _isUpLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: handleUpLoad,
                icon: const Icon(Icons.upload),
                label: const Text("Chọn và upLoad File"),
              ),
      ),
    );
  }
}
