import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MaterialUnitPage extends StatefulWidget {
  const MaterialUnitPage({Key? key}) : super(key: key);

  @override
  State<MaterialUnitPage> createState() => _MaterialUnitPageState();
}

class _MaterialUnitPageState extends State<MaterialUnitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
