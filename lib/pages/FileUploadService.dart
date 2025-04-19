import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class FileUploadService {
  Future<void> uploadFile(BuildContext context, String filePath) async {
    final file = File(filePath);
    final fileName = basename(file.path);
    final mimeType = lookupMimeType(file.path);

    if (mimeType == null || !mimeType!.contains("pdf")) {
      _showAlert(context, 'Could not determine MIME type of $fileName');
      return;
    }
    var request = http.MultipartRequest('POST', Uri.parse("${Preferences.baseUrl}/upload"));
    request.headers['Authorization'] = Preferences.bearer;
    request.headers['Content-Type'] = 'application/json';
    request.fields['fileName'] = fileName;
    request.files.add(await http.MultipartFile.fromPath('file', file.path, contentType: MediaType.parse(mimeType!)));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status: ${response.statusCode}');
    }
  }

  Future<void> uploadPhoto(BuildContext context, String filePath) async {
    final file = File(filePath);
    final fileName = basename(file.path);
    final mimeType = lookupMimeType(file.path);

    if (mimeType == null || !mimeType!.contains("jpg")) {
      _showAlert(context, 'Could not determine MIME type of $fileName');
      return;
    }
    var request = http.MultipartRequest('POST', Uri.parse("${Preferences.baseUrl}/upload/photo"));
    request.headers['Authorization'] = Preferences.bearer;
    request.headers['Content-Type'] = 'application/json';
    request.fields['fileName'] = fileName;
    request.files.add(await http.MultipartFile.fromPath('file', file.path, contentType: MediaType.parse(mimeType!)));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status: ${response.statusCode}');
    }
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final FileUploadService _fileUploadService = FileUploadService();

  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      await _fileUploadService.uploadFile(context, filePath);
    } else {
      // User canceled the picker
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      await _fileUploadService.uploadFile(context, photo.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _pickFile(context),
              child: Text('Pick and Upload File'),
            ),
            ElevatedButton(
              onPressed: () => _takePhoto(context),
              child: Text('Take Photo and Upload'),
            ),
          ],
        ),
      ),
    );
  }

}