import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutterar/arviewer.dart';
import 'package:flutterar/env.dart';
import 'package:http/http.dart' as http;

class Details extends StatefulWidget {
  final String productId;
  const Details({super.key, required this.productId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map<String, dynamic> product = {};

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  Future<void> _getProduct() async {
    final response = await http.get(
      Uri.parse('$serverURL/api/product?productId=${widget.productId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      if (mounted) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          product = responseBody;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Page"),
      ),
      body: product.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(height: 200.0),
                  items: (product["image"] as List<dynamic>?)
                      ?.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  "$serverURL/api/$i",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      })
                      .toList()
                      .cast<Widget>(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product["name"],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArViewer(
                              modelUrl: "$serverURL/api/${product["modelUrl"]}",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 8.0,
                        shadowColor: Colors.black45,
                      ),
                      child: Text("View in AR"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
