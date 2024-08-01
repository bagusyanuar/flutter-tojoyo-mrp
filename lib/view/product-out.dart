import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProductOutPage extends StatefulWidget {
  const ProductOutPage({Key? key}) : super(key: key);

  @override
  State<ProductOutPage> createState() => _ProductOutPageState();
}

class _ProductOutPageState extends State<ProductOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
