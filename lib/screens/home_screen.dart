import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/screens/product_list.dart';
import 'package:_99ads/widgets/banner_widget.dart';
import 'package:_99ads/widgets/category_widget.dart';
import 'package:_99ads/widgets/custom_appbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class HomeScreen extends StatefulWidget {
  static const String id = "Home-screen";

  // ignore: use_key_in_widget_constructors
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    _catProvider.clearSelectedCat();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: SafeArea(child: CustomAppBar()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 8),
                child: Column(
                  children: const [
                    BannerWidget(),
                    CategoryWidget(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const ProductList(false),
            //
          ],
        ),
      ),
    );
  }
}
