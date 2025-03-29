// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FirestoreService {
//   FirestoreService._();
//
//   static FirestoreService instance = FirestoreService._();
//   final CollectionReference productCollection =
//       FirebaseFirestore.instance.collection('products');
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//   Future<void> addProduct(String name, double price) async {
//     await productCollection.add({'name': name, 'price': price});
//   }
//
//   Stream<QuerySnapshot> fetchProducts() {
//     return productCollection.snapshots();
//   }
//
//   Future<void> deleteProduct(String docId) async {
//     await productCollection.doc(docId).delete();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_exam/model/product_model.dart';

class FirestoreService {
  FirestoreService._();
  static FirestoreService firestoreService = FirestoreService._();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String products = 'products';

  Future<void> addProduct(String product) async {
    await _db.collection(products).add({'products': product});
  }

  Stream<QuerySnapshot> fetchData() {
    return _db.collection(products).snapshots();
  }

  void deleteProducts(String id) async {
    await _db.collection(products).doc(id).delete();
  }
}
