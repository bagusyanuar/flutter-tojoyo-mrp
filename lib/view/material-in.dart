import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MaterialInPage extends StatefulWidget {
  const MaterialInPage({Key? key}) : super(key: key);

  @override
  State<MaterialInPage> createState() => _MaterialInPageState();
}

class _MaterialInPageState extends State<MaterialInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
