import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:random_string/random_string.dart';
import 'package:wikipidea_application/screens/About.dart';
// import 'package:wikipidea_application/screens/dummy.dart';
import 'package:wikipidea_application/screens/homepage.dart';
import 'package:wikipidea_application/screens/upload_data.dart';
import 'package:wikipidea_application/service/database.dart';

class Contents extends StatefulWidget {
  const Contents({super.key});

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  Stream? getuploaded;
  List<TextEditingController> titlename = [];

  List<TextEditingController> discriptiondata = [];
  List<String> downloadURL = [];
  List<bool> editMode = [];

  void _pickAndUploadImage(int index) async {
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
        snapshot.ref.getDownloadURL().then((v) {
          setState(() {
            downloadURL[index] = (v);
          });
          print('downloadURL ${downloadURL[index]}');
        });

        print("Image uploaded successfully: $downloadURL");
      } catch (e) {
        print("Error uploading image: $e");
      }
    } else {
      print('No file selected');
    }
  }

  getuploadeddata() async {
    DatabaseMethods().getuploadeddata().then((value) {
      setState(() {
        getuploaded = value;
      });
    });
  }

  @override
  void initState() {
    getuploadeddata();

    super.initState();
  }

  Widget uploadedata() {
    return StreamBuilder(
        stream: getuploaded,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print("The length is ${snapshot.data!.docs.length}");
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              titlename.add(TextEditingController());
              discriptiondata.add(TextEditingController());
              downloadURL.add(snapshot.data!.docs[i]["url"]);
              editMode.add(true);
            }
            return snapshot.data != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          print("the snapshot is ${snapshot.data!.docs}");
                          print("index is $index");

                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          print("yesssss ${ds}");
                          print("*******${titlename.length}");
                          titlename[index].text = ds["title"];
                          discriptiondata[index].text = ds['description'];
                          return Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Title:  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              width: 200,
                                              child: TextField(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                controller:
                                                    TextEditingController(
                                                        text: ds['title'] ??
                                                            'null'),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none),
                                                maxLines: 1,
                                                onChanged: (value) {
                                                  titlename[index].text = value;
                                                },
                                                readOnly: editMode[index],
                                              ),
                                            ),

                                            // SizedBox(
                                            //   width: 10.0,
                                            //   height: 10.0,
                                            // ),
                                          ],
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              editMode[index] =
                                                  !editMode[index];
                                            });

                                            print('bool $editMode');
                                          },
                                          icon: Icon(Icons.edit),
                                          color: editMode[index]
                                              ? Colors.black
                                              : Colors.lightBlue,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Confirmation on deletion"),
                                                    content: Text(
                                                        "Are sure you want to delete"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      TextButton(
                                                        onPressed: () {
                                                          DatabaseMethods()
                                                              .deleteData(
                                                                  ds["id"]);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      "DELETED!")));
                                                        },
                                                        child: Text("Ok",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )
                                                    ],
                                                  );
                                                });
                                            // print("button clicked");

                                            // DatabaseMethods().deleteData(ds["id"]);
                                            // print("data deleted");
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //         content: Text("DELETED!")));
                                          },
                                          child: Icon(Icons.delete),
                                        ),
                                        // SizedBox(
                                        //   width: 10.0,
                                        // ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigator.pop(context);
                                        //     // print("button clicked");

                                        //     // DatabaseMethods().deleteData(ds["id"]);
                                        //     // print("data deleted");
                                        //     // ScaffoldMessenger.of(context)
                                        //     //     .showSnackBar(SnackBar(
                                        //     //         content: Text("DELETED!")));
                                        //   },
                                        //   child: Icon(Icons.cancel),
                                        // )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Description:  ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          // width: 800,
                                          child: TextField(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.normal),
                                            controller: TextEditingController(
                                                text: ds['description'] ??
                                                    'null'),
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                            maxLines: null,
                                            onChanged: (value) {
                                              discriptiondata[index].text =
                                                  value;
                                            },
                                            readOnly: editMode[index],
                                          ),
                                        ),
                                        // ElevatedButton(
                                        //   onPressed: () async {
                                        //     Map<String, dynamic> updateinfo = {
                                        //       "title": titlename.text,
                                        //       "description": discriptiondata.text,
                                        //       // "id"=id
                                        //       "url": downloadURL.isNotEmpty
                                        //           ? downloadURL
                                        //           : ds['url'],
                                        //     };
                                        //     //  Text("Image uploaded Successfully");
                                        //     DatabaseMethods()
                                        //         .updateData(
                                        //       updateinfo,
                                        //       ds["id"],
                                        //     )
                                        //         .then(
                                        //       (value) {
                                        //         print("$value");
                                        //         // Navigator.pop(context);
                                        //       },
                                        //     );
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(SnackBar(
                                        //             content: Text(
                                        //                 "Data and image is uploaded successfully!")));
                                        //   },
                                        //   child: Text("Update"),
                                        // ),
                                      ],
                                    ),
                                    Text(
                                      "Image: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.network(
                                      downloadURL.isEmpty
                                          ? ''
                                          : downloadURL[index],
                                      height: 200,
                                      width: 200,
                                    ),
                                    SizedBox(height: 5.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        // print('previous url ${downloadURL[index]}');
                                        _pickAndUploadImage(index);
                                        // setState(() {
                                        //   String url = downloadURL[index];
                                        // });
                                      },
                                      child: Text(
                                        "Replace image",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Center(
                                    //   child: SizedBox(
                                    //       width: 50,
                                    //       height: 50,
                                    //       child: CircularProgressIndicator()),
                                    // ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            print('updated url ${downloadURL}');
                                            Map<String, dynamic> updateinfo = {
                                              "title": titlename[index].text,
                                              "description":
                                                  discriptiondata[index].text,
                                              // "id"=id
                                              "url": downloadURL.isNotEmpty
                                                  ? downloadURL[index]
                                                  : ds['url'],
                                            };
                                            //  Text("Image uploaded Successfully");
                                            DatabaseMethods()
                                                .updateData(
                                              updateinfo,
                                              ds["id"],
                                            )
                                                .then(
                                              (value) {
                                                print("$value");
                                                // Navigator.pop(context);
                                              },
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Data and image is uploaded successfully!")));
                                          },
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Image.network(
                                    //     'https://firebasestorage.googleapis.com/v0/b/stayon-51caa.appspot.com/o/testimages%2Fdownload.png?alt=media&token=898affa5-d043-4456-849e-c67184b4ee84')
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator()),
                  );
          }
          // for (int i = 0; i < snapshot.data.docs.length; i++) {
          //   titlename.add(TextEditingController());
          //   discriptiondata.add(TextEditingController());
          //   downloadURL.add(snapshot.data.docs[i]["url"]);
          // }
        });
  }

  String selectedPage = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Contents"),
          backgroundColor: const Color.fromARGB(255, 155, 232, 214),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 155, 232, 214),
          tooltip: 'Create data',
          onPressed: () {
            //  setState(() {
            //   selectedPage = "upload data";
            // });
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UploadData()));
          },
          child: const Icon(Icons.add, color: Colors.black, size: 25),
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
              //   title: const Text('Data'),
              //   onTap: () {
              //     //    setState(() {
              //     //     selectedPage = "contents page";
              //     //   });
              //     Navigator.push(
              //         context, MaterialPageRoute(builder: (context) => Dummy()));
              //   },
              // ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              Expanded(child: uploadedata()),
            ],
          ),
        ),
      ),
    );
  }

//  String currentTitle, String Currentd

  // Future EditData(String id, String url) => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           content: Container(
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     GestureDetector(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                         child: Icon(Icons.cancel)),
  //                     SizedBox(width: 50.0),
  //                     Text(
  //                       "Edit information",
  //                       style: TextStyle(
  //                         fontStyle: FontStyle.normal,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18.0,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 20.0),
  //                 TextField(
  //                   controller: titlename,
  //                   decoration: InputDecoration(
  //                     labelText: 'Title',
  //                   ),
  //                   maxLines: 1,
  //                   onChanged: (value) {
  //                     titlename.text = value;
  //                   },
  //                   readOnly: false,
  //                 ),
  //                 TextField(
  //                   controller: discriptiondata,
  //                   decoration: InputDecoration(
  //                     labelText: 'Description',
  //                   ),
  //                   maxLines: null,
  //                   onChanged: (value) {
  //                     discriptiondata.text = value;
  //                   },
  //                   readOnly: false,
  //                 ),
  //                 SizedBox(height: 20.0),
  //                 Text(
  //                   "Image:",
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 18.0,
  //                       fontWeight: FontWeight.normal),
  //                 ),
  //                 Image.network(
  //                   url,
  //                   width: 200,
  //                   height: 200,
  //                 ),
  //                 SizedBox(height: 20.0),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     _pickAndUploadImage();
  //                     setState(() {
  //                       url = downloadURL;
  //                     });
  //                   },
  //                   child: Text("Replace image"),
  //                 ),
  //                 SizedBox(height: 30.0),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     Map<String, dynamic> updateinfo = {
  //                       "title": titlename.text,
  //                       "description": discriptiondata.text,
  //                       // "id"=id
  //                       "url": downloadURL.isNotEmpty ? downloadURL : url,
  //                     };
  //                     //  Text("Image uploaded Successfully");
  //                     DatabaseMethods().updateData(updateinfo, id).then(
  //                       (value) {
  //                         print("$value");
  //                         Navigator.pop(context);
  //                       },
  //                     );
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                         content: Text(
  //                             "Data and image is uploaded successfully!")));
  //                   },
  //                   child: Text("Update"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ));
}
