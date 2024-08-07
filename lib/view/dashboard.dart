import 'package:app_tojoyo_mrp/components/card/card.menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            padding: const EdgeInsets.only(bottom: 60),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1 / 1,
            children: [
              CardMenu(
                text: "Bahan Baku",
                onCardTap: () {
                  Navigator.pushNamed(context, "/material");
                },
              ),
              CardMenu(
                text: "Product",
                onCardTap: () {
                  Navigator.pushNamed(context, "/product");
                },
              ),
              CardMenu(
                text: "Resep",
                onCardTap: () {
                  Navigator.pushNamed(context, "/recipe");
                },
              ),
              CardMenu(
                text: "MRP",
                onCardTap: () {
                  Navigator.pushNamed(context, "/mrp");
                },
              ),
              CardMenu(
                text: "Bahan Baku Masuk",
                onCardTap: () {
                  Navigator.pushNamed(context, "/material-in");
                },
              ),
              CardMenu(
                text: "Product Keluar",
                onCardTap: () {
                  Navigator.pushNamed(context, "/product-out");
                },
              ),
              CardMenu(
                text: "Laporan Bahan Baku Masuk",
                onCardTap: () {
                  Navigator.pushNamed(context, "/report-material-in");
                },
              ),
              CardMenu(
                text: "Laporan Product Keluar",
                onCardTap: () {
                  Navigator.pushNamed(context, "/report-product-out");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
