import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_firebase/models/event.dart';
import 'package:new_firebase/views/screens/eventInfo_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class EvetsItem extends StatefulWidget {
  final Event event;

  EvetsItem({required this.event});

  @override
  State<EvetsItem> createState() => _EvetsItemState();
}

class _EvetsItemState extends State<EvetsItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EventInfoScreen(event: widget.event);
            },
          ),
        );
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.event.imageUrl),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.event.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(widget.event.time.toDate()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.event.locationName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              isLiked = !isLiked;
                              setState(() {});
                            },
                            icon: Icon(
                              CupertinoIcons.heart_circle_fill,
                              size: 30,
                              color: isLiked ? Colors.red : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
