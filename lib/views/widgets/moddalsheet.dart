// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_firebase/models/event.dart';
import 'package:new_firebase/services/event_http_service.dart';
import 'package:new_firebase/views/widgets/payments.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Moddalsheet extends StatefulWidget {
  Event event;
  Moddalsheet({super.key, required this.event});

  @override
  State<Moddalsheet> createState() => _ModdalsheetState();
}

class _ModdalsheetState extends State<Moddalsheet> {
  int number = 0;
  showbottomSheet() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Lottie.asset('assets/lotties/done.json',
                    width: 500, height: 500),
              ),
              Text(
                'Tabriklaymiz!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text('Siz ${widget.event.name} eventiga royhatan o`tdingiz !'),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ZoomTapAnimation(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    elevation: 6,
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Home pagega",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Joylar sonini kirg`izing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ZoomTapAnimation(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade500),
                    child: Icon(Icons.remove_circle_outline_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    number++;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  number.toString(),
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    number--;
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.remove,
                    size: 40,
                  ),
                ),
              ],
            ),
            Text(
              'Tolov turinig tanlang',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Payments(
                imageUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIpQuT1nh0X3giwHR2a0d05o2Jm2pGD3ymJg&s',
                name: 'Click'),
            Payments(
                imageUrl:
                    'https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw',
                name: 'Hayolan'),
            Payments(
                imageUrl:
                    'https://daryo.uz/cache/2021/12/pul-som-3-1280x853.jpg',
                name: 'Naqd'),
            Center(
              child: ZoomTapAnimation(
                onTap: () {
                  Navigator.pop(context, {'number': number});
                  showbottomSheet();
                },
                child: Card(
                  elevation: 6,
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Keyingisi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
