import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wikipidea_application/service/database.dart';
import 'about.dart';
import 'contents.dart';
import 'upload_data.dart';

class MyWikkiApp extends StatefulWidget {
  const MyWikkiApp({Key? key}) : super(key: key);

  @override
  State<MyWikkiApp> createState() => _MyWikkiAppState();
}

class _MyWikkiAppState extends State<MyWikkiApp> {
  Stream<QuerySnapshot>? getuploaded;
  String selectedPage = '';
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    getuploadeddata();
  }

  getuploadeddata() async {
    getuploaded = await DatabaseMethods().getuploadeddata();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 155, 232, 214),
          title: const Text('INFO VERSE '),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 155, 232, 214)),
                child: Center(
                  child: Text(
                    'DETAILS',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // setState(() {
                  //   selectedPage = "Current page";
                  // });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyWikkiApp()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_box_outlined),
                title: const Text('About'),
                onTap: () {
                  //  setState(() {
                  //   selectedPage = "About";
                  // });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_sharp),
                title: const Text('Upload Data'),
                onTap: () {
                  //  setState(() {
                  //   selectedPage = "upload data";
                  // });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadData()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.dataset),
                title: const Text('Contents'),
                onTap: () {
                  //    setState(() {
                  //     selectedPage = "contents page";
                  //   });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Contents()));
                },
              ),
            ],
          ),
        ),

        // body: Center(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SearchAnchor(
        //       builder: (BuildContext context, SearchController controller) {
        //         return SearchBar(
        //           controller: controller,
        //           padding: const WidgetStatePropertyAll<EdgeInsets>(
        //             EdgeInsets.symmetric(horizontal: 20.0),
        //           ),
        //
        //           leading: const Icon(Icons.search),
        //           trailing: <Widget>[
        //             Tooltip(
        //               message: 'Change brightness mode',
        //               child: IconButton(
        //                 isSelected: isDark,
        //                 onPressed: () {
        //                   setState(() {
        //                     isDark = !isDark;
        //                   });
        //                 },
        //                 icon: const Icon(Icons.wb_sunny_outlined),
        //                 selectedIcon: const Icon(Icons.brightness_2_outlined),
        //               ),
        //             ),
        //           ],
        //         );
        //       },
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                  trailing: <Widget>[
                    Tooltip(
                      message: 'Change brightness mode',
                      child: IconButton(
                        isSelected: isDark,
                        onPressed: () {
                          setState(() {
                            isDark = !isDark;
                          });
                        },
                        icon: const Icon(Icons.wb_sunny_outlined),
                        selectedIcon: const Icon(Icons.brightness_2_outlined),
                      ),
                    ),
                  ],
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                return [
                  StreamBuilder<QuerySnapshot>(
                    stream: getuploaded,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(title: Text('Loading...'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const ListTile(title: Text('No data'));
                      }

                      List<DocumentSnapshot> documents = snapshot.data!.docs;

                      final filteredItems = documents.where((doc) {
                        String title =
                            (doc['title'] ?? '').toString().toLowerCase();
                        return title.contains(controller.text.toLowerCase());
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const ListTile(title: Text('No results found'));
                      }

                      return Column(
                        children: List<Widget>.generate(filteredItems.length,
                            (int index) {
                          String title = filteredItems[index]['title'];
                          String description =
                              filteredItems[index]['description'];
                          String imageUrl = filteredItems[index]['url'] ?? '';

                          return ListTile(
                            title: Text(title),
                            subtitle: Text(description),
                            leading: imageUrl.isNotEmpty
                                ? Image.network(imageUrl,
                                    width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.image_not_supported),
                            onTap: () {
                              setState(() {
                                controller.closeView(title);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Contents()));
                              });
                            },
                          );
                        }),
                      );
                    },
                  ),
                ];
              },
              // suggestionsBuilder:
              //     (BuildContext context, SearchController controller) {
              //   return StreamBuilder(
              //     stream: getuploaded,
              //     builder: (context, AsyncSnapshot snapshot) {
              //       List<DocumentSnapshot> documents = snapshot.data.docs;
              //       final filteredItems = documents.where((doc) {
              //         String title = doc['title'].toString().toLowerCase();
              //         return title.contains(controller.text.toLowerCase());
              //       }).toList();

              //       if (filteredItems.isEmpty) {
              //         return [ListTile(title: Text('No results found'))];
              //       }

              //       return List<ListTile>.generate(filteredItems.length,
              //           (int index) {
              //         final String item = filteredItems[index]['title'];
              //         return ListTile(
              //           title: Text(item),
              //           onTap: () {
              //             setState(() {
              //               controller.closeView(item);
              //             });
              //           },
              //         );
              //       });
              //     },
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }
}
