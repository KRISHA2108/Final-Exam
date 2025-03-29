import 'package:final_exam/helper/db_helper.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var auctionProducts = <Product>[].obs;

  Future<void> addProduct(Product product) async {
    products.value = await SQLHelper.instance.fetchData();
  }

  void fetchData() async {
    products.value = await SQLHelper.instance.fetchData();
  }

  void deleteProduct(int index) async {
    SQLHelper.instance.deleteData(index);
    update();
  }

  Future<void> updateProduct(int index, Product product) async {
    await SQLHelper.instance.updateProduct(index, product);
    update();
    // products[index] = product;
  }

  void addToAuction(Product product) {
    auctionProducts.add(product);
    FirebaseFirestore.instance.collection('auctionProducts').add({
      'name': product.name,
      'category': product.category,
      'price': product.price,
      'timestamp': DateTime.now(),
    });
  }

  void removeFromAuction(Product product) {
    auctionProducts.remove(product);
    FirebaseFirestore.instance
        .collection('auctionProducts')
        .where('name', isEqualTo: product.name)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
