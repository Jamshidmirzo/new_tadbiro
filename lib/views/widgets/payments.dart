import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Payments extends StatefulWidget {
  final String imageUrl;
  final String name;
  Payments({super.key, required this.imageUrl, required this.name});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  bool isChoice = false;

  bool isChoice2 = false;

  bool isChoice3 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ZoomTapAnimation(
          onTap: () {
            isChoice = !isChoice;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.only(right: 40),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isChoice ? Colors.green : null,
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(widget.imageUrl),
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
