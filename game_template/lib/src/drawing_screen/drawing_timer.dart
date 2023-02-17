// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:monstermaker/controllers/game_controller.dart';
// import 'package:monstermaker/app_constants.dart';
//
// class DrawingTimer extends StatefulWidget {
//   const DrawingTimer({Key? key, required this.time, this.onTimesUp}) : super(key: key);
//   final DrawingTimerMinutes? time;
//   final VoidCallback? onTimesUp;
//
//   @override
//   _TimerWidgetState createState() => _TimerWidgetState();
// }
//
// class _TimerWidgetState extends State<DrawingTimer> {
//   int drawingTimeInSeconds = 0;
//   int secondsLeft = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     switch (widget.time) {
//       case DrawingTimerMinutes.one:
//         drawingTimeInSeconds = 60;
//         break;
//       case DrawingTimerMinutes.three:
//         drawingTimeInSeconds = 60 * 3;
//         break;
//       case DrawingTimerMinutes.five:
//         drawingTimeInSeconds = 60 * 5;
//         break;
//       case DrawingTimerMinutes.noLimit:
//       case null:
//         break;
//     }
//     secondsLeft = drawingTimeInSeconds;
//     if (drawingTimeInSeconds != 0) {
//       Timer.periodic(const Duration(seconds: 1), (Timer t) {
//         if (mounted) {
//           setState(() {
//             secondsLeft -= 1;
//           });
//         } else {
//           t.cancel();
//         }
//         if (t.tick >= drawingTimeInSeconds) {
//           if (mounted) {
//             widget.onTimesUp?.call();
//           }
//           t.cancel();
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final durationLeft = Duration(seconds: secondsLeft);
//     final media = MediaQuery.of(context);
//
//     return Text(
//       _durationText(durationLeft),
//       style: AppConstants.drawingTimerTextStyle(media: media),
//     );
//   }
//
//   String _durationText(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitMinutes:$twoDigitSeconds";
//   }
// }
