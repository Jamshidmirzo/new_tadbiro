import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pageviewbuilder extends StatefulWidget {
  final String question;
  final List<dynamic> answers;
  final int index;
  final int correct;
  final Function nextquestion;
  List correctanswer;
  String imageurl;

  Pageviewbuilder(
      {super.key,
      required this.answers,
      required this.question,
      required this.index,
      required this.nextquestion,
      required this.correct,
      required this.correctanswer,
      required this.imageurl});

  @override
  State<Pageviewbuilder> createState() => _PageviewbuilderState();
}

class _PageviewbuilderState extends State<Pageviewbuilder> {
  bool isChecked = false;
  int correctIndex = -1;
  bool isCorrect = false;

  void checkAnswer(int index) {
    setState(() {
      isChecked = true;
      correctIndex = index;
      isCorrect = (index == widget.correct);
      if (isCorrect) {
        widget.correctanswer.add('value');
        print(widget.correctanswer.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(widget.imageurl),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.question,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: widget.answers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return ZoomTapAnimation(
                onTap: () {
                  checkAnswer(index);
                  widget.nextquestion();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.answers[index],
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


 // return Column(
    //   children: [
    //     Container(
    //       width: double.infinity,
    //       height: 200,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: NetworkImage(widget.imageurl),
    //         ),
    //       ),
    //     ),
    //     Text(
    //       widget.question,
    //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
    //     ),
    //     for (int i = 0; i < widget.answers.length; i++)
    //       ListTile(
    //         title: Text(
    //           widget.answers[i],
    //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //         ),
    //         trailing: IconButton(
    //           onPressed: isChecked
    //               ? null
    //               : () {
    //                   checkAnswer(i);
    //                   Future.delayed(const Duration(seconds: 1), () {
    //                     widget.nextquestion();
    //                   });
    //                 },
    //           icon: i == correctIndex
    //               ? const Icon(Icons.check_box)
    //               : const Icon(Icons.check_box_outline_blank),
    //         ),
    //       ),
    //     if (isChecked)
    //       isCorrect
    //           ? Lottie.asset('assets/lotties/done.json',
    //               width: 200, height: 200)
    //           : Lottie.asset('assets/lotties/incorrect.json',
    //               width: 100, height: 100),
    //   ],
    // );
   