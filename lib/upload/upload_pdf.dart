import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadPDF extends StatefulWidget {
  const UploadPDF({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UploadPDFState createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selected file:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: result?.files.length ?? 0,
                        itemBuilder: (context, index) {
                          return Text(
                            result?.files[index].name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 5,);
                        },
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform.pickFiles(allowMultiple: true);
                    if (result == null) {
                      print("No file selected");
                    } else {
                      setState(() {});
                      for (var element in result!.files) {
                        print(element.name);
                      }
                    }
                  },
                  child: const Text("File Picker"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
