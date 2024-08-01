import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReportMaterialInPage extends StatefulWidget {
  const ReportMaterialInPage({Key? key}) : super(key: key);

  @override
  State<ReportMaterialInPage> createState() => _ReportMaterialInPageState();
}

class _ReportMaterialInPageState extends State<ReportMaterialInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
