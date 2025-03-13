import 'dart:io';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:random_string/random_string.dart';
import 'package:wikipidea_application/screens/About.dart';
import 'package:wikipidea_application/screens/contents2.dart';
// import 'package:wikipidea_application/screens/dummy.dart';
import 'package:wikipidea_application/screens/homepage.dart';
import 'package:wikipidea_application/service/database.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  String selectedPage = '';
  String downloadURL = '';
  TextEditingController titlename = new TextEditingController();
  TextEditingController discriptiondata = new TextEditingController();
  bool isImageuploaded = false;
  Future<String> _pickAndUploadImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      FirebaseStorage storage = FirebaseStorage.instance;

      String fileName = file.name;
      Reference storageRef = storage.ref().child('testimages/$fileName');

      try {
        Uint8List fileBytes = file.bytes!;
        UploadTask uploadTask = storageRef.putData(fileBytes);
        TaskSnapshot snapshot = await uploadTask;
        downloadURL = await snapshot.ref.getDownloadURL();
        // print("Image uploaded successfully: $downloadURL");
      } catch (e) {
        print("Error uploading image: $e");
      }
    } else {
      print('No file selected');
    }
    return downloadURL;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Data Uploading"),
          backgroundColor: const Color.fromARGB(255, 155, 232, 214),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 155, 232, 214)),
                child: Center(
                    child: Text('DETAILS',
                        style: TextStyle(color: Colors.black, fontSize: 24))),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  setState(() {
                    selectedPage = "current page";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyWikkiApp()));
                    // Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_box_outlined),
                title: const Text('About'),
                onTap: () {
                  setState(() {
                    selectedPage = 'About';
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutPage()));
                    // Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_sharp),
                title: const Text('Upload data'),
                onTap: () {
                  setState(() {
                    selectedPage = 'Data Uploading page ';
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UploadData()));
                    // Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.dataset),
                title: const Text('Contents'),
                onTap: () {
                  setState(() {
                    selectedPage = 'Stored contents';
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Contents()));
                    // Navigator.pop(context);
                  });
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.list),
              //   title: const Text('Dummy'),
              //   onTap: () {
              //     setState(() {
              //       selectedPage = 'Display page';
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => Dummy()));
              //       // Navigator.pop(context);
              //     });
              //   },
              // ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 400,
                child: TextField(
                  controller: titlename,
                  decoration: InputDecoration(
                      labelText: 'Title', labelStyle: TextStyle()),
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                )),
            TextField(
              controller: discriptiondata,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Image: ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal),
            ),
            isImageuploaded
                ? Image.network(
                    downloadURL,
                    height: 200,
                    width: 200,
                    // color: Colors.white,
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    // padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                    child: ElevatedButton(
                        onPressed: () {
                          _pickAndUploadImage().then((value) {
                            print(value);
                            setState(() {
                              downloadURL = value;
                              isImageuploaded = true;
                            });
                          });
                        },
                        // print("Image uploaded");
                        child: Text(
                          "Upload Image",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ))),
                // SizedBox(
                //   height: 20,
                //   width: 20,
                // ),
                // Image.network(
                //   downloadURL,
                //   height: 200,
                //   width: 200,
                // ),
                // SizedBox(
                //   height: 10,
                //   width: 20,
                // ),
                SizedBox(width: 30, height: 30),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2))),
                    child: ElevatedButton(
                        // onPressed: () async {

                        // },
                        onPressed: () async {
                          if (titlename.text.isNotEmpty &&
                              discriptiondata.text.isNotEmpty &&
                              downloadURL.isNotEmpty) {
                            try {
                              String ID = randomAlphaNumeric(100);
                              Map<String, dynamic> uploadinfomap = {
                                "title": titlename.text,
                                "description": discriptiondata.text,
                                "id": ID,
                                'url': downloadURL,
                              };

                              DatabaseMethods().uploadData(
                                uploadinfomap,
                                ID,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Data and image is uploaded successfully!")));
                            } catch (e) {
                              print("Error uploading data: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Error uploading data")));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Please fill in all fields")));
                          }
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ))),
              ],
            )
          ]),
        ));
  }
}
