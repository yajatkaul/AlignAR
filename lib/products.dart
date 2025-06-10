import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterar/details.dart';
import 'package:flutterar/env.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final String productName;
  const ProductPage({super.key, required this.productName});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> products = [];
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    super.dispose();
    _searchQuery.dispose();
  }

  Future<void> _getProducts() async {
    final response = await http.get(
      Uri.parse(
          '$serverURL/api/products?type=${widget.productName}&filter=${_searchQuery.text}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      if (mounted) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          products = responseBody;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _getProducts();
              },
              controller: _searchQuery,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                            productId: product["_id"],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            "$serverURL/api/${product["image"][0]}",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            product["name"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
