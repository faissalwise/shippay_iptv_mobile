import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show get;

class StreamFilePicker {
  static const TYPE = FileType.custom;

  StreamFilePicker();

  // private
  String _path;
  String _m3uText;

  Future<File> _openFileExplorer() async {
    try {
      _path = await FilePicker.getFilePath(type: FileType.any);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    return _path == null ? null : File(_path);
  }

  // public
  Future<String> file() async {
    File _file = await _openFileExplorer();
    try {
      _m3uText = await _file?.readAsString();
    } on FileSystemException catch (e) {
      _m3uText = null;
      print('Can\'t read file: $e');
    }
    return _m3uText;
  }

  Future<String> link(String link) async {
    var response = await get(link);
    return response.body;
  }
}
