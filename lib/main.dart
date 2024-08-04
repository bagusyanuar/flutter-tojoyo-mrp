import 'package:app_tojoyo_mrp/view/dashboard.dart';
import 'package:app_tojoyo_mrp/view/login.dart';
import 'package:app_tojoyo_mrp/view/material-in.dart';
import 'package:app_tojoyo_mrp/view/material.add.dart';
import 'package:app_tojoyo_mrp/view/material.dart';
import 'package:app_tojoyo_mrp/view/mrp.dart';
import 'package:app_tojoyo_mrp/view/product-out.dart';
import 'package:app_tojoyo_mrp/view/product.add.dart';
import 'package:app_tojoyo_mrp/view/product.dart';
import 'package:app_tojoyo_mrp/view/recipe.dart';
import 'package:app_tojoyo_mrp/view/recipe.detail.add.dart';
import 'package:app_tojoyo_mrp/view/recipe.detail.dart';
import 'package:app_tojoyo_mrp/view/report-material-in.dart';
import 'package:app_tojoyo_mrp/view/report-product-out.dart';
import 'package:app_tojoyo_mrp/view/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginPage(),
        "/dashboard": (context) => const DashboardPage(),
        "/material": (context) => const MaterialUnitPage(),
        "/material-add": (context) => const MaterialAddPage(),
        "/product": (context) => const ProductPage(),
        "/product-add": (context) => const ProductAddPage(),
        "/recipe": (context) => const RecipePge(),
        "/recipe-detail": (context) => const RecipeDetailPage(),
        "/recipe-detail-add": (context) => const RecipeDetailAddPage(),
        "/mrp": (context) => const MRPPage(),
        "/material-in": (context) => const MaterialInPage(),
        "/product-out": (context) => const ProductOutPage(),
        "/report-material-in": (context) => const ReportMaterialInPage(),
        "/report-product-out": (context) => const ReportProductOut(),
      },
    );
  }
}
