import 'package:final_exam/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/product_controller.dart';

class AuctionProductsPage extends StatefulWidget {
  const AuctionProductsPage({super.key});

  @override
  State<AuctionProductsPage> createState() => _AuctionProductsPageState();
}

class _AuctionProductsPageState extends State<AuctionProductsPage> {
  ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff27215C),
            )),
        title: const Text(
          'Auction Products',
          style:
              TextStyle(color: Color(0xff27215C), fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirestoreService.firestoreService.fetchData(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff27215C)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          snapshot.data!.docs[index]['products'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xff27215C),
                        ),
                        onPressed: () {
                          FirestoreService.firestoreService
                              .deleteProducts(snapshot.data!.docs[index].id);
                        },
                      ),
                    ],
                  ));
            },
          );
        },
      ),
    );
  }
}
