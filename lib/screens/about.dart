import 'package:flutter/material.dart';
import 'package:wikipidea_application/screens/contents.dart';
import 'package:wikipidea_application/screens/homepage.dart';
import 'package:wikipidea_application/screens/upload_data.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String selectedPage = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 155, 232, 214),
          title: const Text('About'),
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
                    // Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => AboutPage()));
                    Navigator.pop(context);
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
            ],
          ),
        ),
        body: Container(
            width: screenWidth,
            padding: EdgeInsets.all(8),
            // color: Colors.amber,
            child: Column(
              children: [
                Text(
                  "Welcome to our comprehensive information hub, where you can explore a wide range of topics, from entertainment to health and beyond. Whether you're looking for the latest movie reviews, trending music, wellness tips, or insights into healthy living, our curated content offers quick and reliable summaries.Also the most effective thing is you can upload the data which gets stored in our database and gets reflected in contents page, Stay informed and inspired with up-to-date articles that simplify complex topics, providing you with the knowledge you need in a concise and engaging format.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                // Text(
                //   "Write Quireis To:",
                //   style: Theme.of(context).textTheme.headlineLarge,
                // )
              ],
            ))

        // body: Center(
        //   child: Container(
        //     width: screenWidth,
        //     // color: const Color.fromARGB(255, 255, 255, 255),
        //     child: Column(
        //       // mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(

        //           // child: Center(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text(
        //                   "Welcome to our comprehensive information hub,
        //                   where you can explore a wide range of topics,
        //                   from entertainment to health and beyond.
        //                   Whether you're looking for the latest movie reviews, trending music,
        //                   wellness tips, or insights into healthy living, our curated content offers
        //                   quick and reliable summaries. Stay informed and inspired with up-to-date
        //                   articles that simplify complex topics,
        //                   providing you with the knowledge you need in a concise and engaging format.",
        //                   style: Theme.of(context).textTheme.bodyText2
        //                 ),

        //               ],
        //             ),
        //           ),

        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
