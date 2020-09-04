import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class FileView extends StatefulWidget {
  final String fileURL;

  const FileView({Key key, @required this.fileURL}) : super(key: key);

  @override
  _FileViewState createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  PDFDocument _doc;
  bool _loading;

  @override
  void initState() {
    _initFile();
    super.initState();
  }

  _initFile() async {
    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromURL(widget.fileURL);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : PDFViewer(
                document: _doc,
              ),
      ),
    );
  }
}
