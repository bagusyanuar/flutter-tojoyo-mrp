import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MaterialEditPage extends StatefulWidget {
  const MaterialEditPage({Key? key}) : super(key: key);

  @override
  State<MaterialEditPage> createState() => _MaterialEditPageState();
}

class _MaterialEditPageState extends State<MaterialEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
