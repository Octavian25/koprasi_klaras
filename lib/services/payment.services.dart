import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("payment");
  Future<List<String>> streamAllPayment() async {
    var stream = await firestore.get();
    List<Map<String, dynamic>> data =
        stream.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    return data.map((e) => e['nama'] as String).toList();
  }
}
