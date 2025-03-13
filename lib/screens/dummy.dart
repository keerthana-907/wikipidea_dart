import 'package:flutter/material.dart';
import 'package:wikipidea_application/screens/about.dart';
import 'package:wikipidea_application/screens/contents2.dart';
import 'package:wikipidea_application/screens/homepage.dart';
import 'package:wikipidea_application/screens/upload_data.dart';

class Dummy extends StatefulWidget {
  final String title;

  final String description;

  final String imageUrl;

  const Dummy({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  String selectedPage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 155, 232, 214),
        title: const Text('Display data'),
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
                //  setState(() {
                //   selectedPage = "About";
                // });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.imageUrl.isNotEmpty
                ? Center(
                    child: Image.network(widget.imageUrl,
                        width: 200, height: 200, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Icon(Icons.image_not_supported, size: 100)),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
