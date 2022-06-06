import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  Future openFile({required String url, String? fillname}) async {
    final name = fillname ?? url.split('/').last;
    final file = await descargarPDF(url, name);
    //final file = await seleccionarDoc();

    if (file == null) return;

    OpenFile.open(file.path);
  }

  Future<File?> seleccionarDoc() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;

    return File(result.files.first.path!);
  }

  Future<File?> descargarPDF(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      //await Dio().download(url, '${appStorage.path}/$name');
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
