import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/product_controller.dart';
import '../../firestore.dart';
import '../../firestore.dart';
import '../../helper/db_helper.dart';
import '../../model/product_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    ProductController productController = Get.put(ProductController());
    productController.fetchData();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Color(0xff27215C)),
        centerTitle: true,
        title: const Text(
          'HomePage',
          style:
              TextStyle(color: Color(0xff27215C), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xff27215C)),
            onPressed: () {
              Navigator.pushNamed(context, '/auction');
            },
          ),
        ],
      ),
      body: Obx(
        () {
          return ListView.builder(
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              var product = productController.products[index];
              return GetBuilder<ProductController>(
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff27215C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          product.name,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${product.category} - ${product.price}",
                          style: const TextStyle(color: Colors.white54),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            productController.deleteProduct(product.id);
                            productController.fetchData();
                          },
                        ),
                        onTap: () {
                          FirestoreService.firestoreService
                              .addProduct(product.name);
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              nameController.text = product.name;
                              categoryController.text = product.category;
                              priceController.text = product.price.toString();

                              return AlertDialog(
                                title: const Text("Edit Product"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          labelText: "Name"),
                                    ),
                                    TextField(
                                      controller: categoryController,
                                      decoration: const InputDecoration(
                                          labelText: "Category"),
                                    ),
                                    TextField(
                                      controller: priceController,
                                      decoration: const InputDecoration(
                                          labelText: "Price"),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff27215C),
                                    ),
                                    onPressed: () {
                                      productController.updateProduct(
                                        product.id,
                                        Product(
                                          name: nameController.text,
                                          category: categoryController.text,
                                          price: double.parse(
                                              priceController.text),
                                          id: product.id,
                                        ),
                                      );
                                      productController.fetchData();
                                    },
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff27215C),
        onPressed: () {
          _showAddProductDialog(context, productController);
          Get.back();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddProductDialog(
      BuildContext context, ProductController productController) {
    TextEditingController nameController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff27215C),
              ),
              onPressed: () {
                SQLHelper.instance.insertProduct(
                  Product(
                    id: productController.products.value.length + 1,
                    name: nameController.text,
                    category: categoryController.text,
                    price: double.parse(
                      priceController.text,
                    ),
                  ),
                );
                productController.fetchData();
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
