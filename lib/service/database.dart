import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  String? get id => null;

  Future uploadData(Map<String, dynamic> uploadinfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Uploaded data")
        .doc(id)
        .set(uploadinfomap);
  }

  Future<Stream<QuerySnapshot>> getuploadeddata() async {
    return await FirebaseFirestore.instance
        .collection("Uploaded data")
        .snapshots();
  }

  Future updateData(Map<String, dynamic> updateinfo, String id) async {
    print("iddddd $id");
    return await FirebaseFirestore.instance
        .collection("Uploaded data")
        .doc(id)
        .update(updateinfo);
  }

  Future deleteData(String id) async {
    print("iddddd $id");
    return await FirebaseFirestore.instance
        .collection("Uploaded data")
        .doc(id)
        .delete();
  }
}
