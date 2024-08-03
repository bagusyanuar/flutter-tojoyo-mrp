import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonFloatingCart extends StatelessWidget {
  final int qty;
  final VoidCallback onTapCart;

  const ButtonFloatingCart({
    Key? key,
    required this.qty,
    required this.onTapCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTapCart,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.brown,
              ),
              color: Colors.white,
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag,
                color: Colors.brown,
                size: 24,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: qty > 0
              ? Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(235, 153, 41, 1),
                  ),
                  child: Center(
                    child: Text(
                      qty.toString(),
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }
}
