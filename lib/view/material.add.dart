import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MaterialAddPage extends StatefulWidget {
  const MaterialAddPage({Key? key}) : super(key: key);

  @override
  State<MaterialAddPage> createState() => _MaterialAddPageState();
}

class _MaterialAddPageState extends State<MaterialAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
