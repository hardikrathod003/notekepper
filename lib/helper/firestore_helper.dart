import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference notekepperRef;
  void connectWithCollection() {
    notekepperRef = firebaseFirestore.collection("notekepper");
  }

  Future<void> insertrecord({required Map<String, dynamic> data}) async {
    connectWithCollection();

    await notekepperRef.doc().set(data);
    // DocumentReference res = await notekepperRef.add(data);
  }

  Stream<QuerySnapshot> selectrecord() {
    connectWithCollection();

    return notekepperRef.snapshots();
  }

  Future<void> updateRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectWithCollection();

    await notekepperRef.doc(id).update(data);
  }

  Future<void> deleterecord({required String id}) async {
    connectWithCollection();

    await notekepperRef.doc(id).delete();
  }
}
