import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProductMaterialPage extends StatefulWidget {
  const ProductMaterialPage({Key? key}) : super(key: key);

  @override
  State<ProductMaterialPage> createState() => _ProductMaterialPageState();
}

class _ProductMaterialPageState extends State<ProductMaterialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
