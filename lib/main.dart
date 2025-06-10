import 'dart:convert';

import 'package:flutterar/env.dart';
import 'package:flutterar/products.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<dynamic> products = [];
  bool isLoading = true;

  final List<Map<String, String>> categories = [
    {
      "image": "assets/covers/SlidingCoverPage.jpg",
      "title": "Sliding Door",
      "description": "Modern sliding door solutions"
    },
    {
      "image": "assets/covers/SwingDoorCoverPage.jpg",
      "title": "Swing Door",
      "description": "Classic swing door designs"
    },
    {
      "image": "assets/covers/ShowerCoverPage.jpg",
      "title": "Shower",
      "description": "Premium shower enclosures"
    },
    {
      "image": "assets/covers/WardrobeCoverPage.jpg",
      "title": "Wardrobe",
      "description": "Custom wardrobe solutions"
    },
    {
      "image": "assets/covers/RailingCoverPage.jpg",
      "title": "Railing",
      "description": "Elegant railing systems"
    },
    {
      "image": "assets/covers/MirrorCoverPage.jpg",
      "title": "Mirror",
      "description": "High-quality mirror installations"
    },
    {
      "image": "assets/covers/WardrobeCoverPage.jpg",
      "title": "Wall Cladding",
      "description": "Decorative wall cladding"
    },
    {
      "image": "assets/covers/OtherCoverPage.jpg",
      "title": "Other",
      "description": "Additional services"
    },
  ];

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$serverURL/api/products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final responseBody = jsonDecode(response.body);
          setState(() {
            products = responseBody;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching products: $e');
    }
  }

  Widget _buildCategoryCard(
      Map<String, String> category, BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductPage(productName: category['title']!),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    category['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['description']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AlignAR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "AlignAR",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey[200],
              height: 1,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildCategoryCard(categories[index], context);
                        },
                        childCount: categories.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }
}
