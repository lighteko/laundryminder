import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryminder/pages/main_page.dart';
import 'package:laundryminder/utils/notification_service.dart';
import 'package:laundryminder/utils/prefs.dart';

class CurrentDryer extends StatefulWidget {
  const CurrentDryer({super.key, required this.machine});

  final Map<String, dynamic> machine;
  @override
  State<CurrentDryer> createState() => _CurrentDryerState();
}

class _CurrentDryerState extends State<CurrentDryer> {
  late int remainingTime;
  // ignore: non_constant_identifier_names
  late final int MAX_TIME;
  Timer? timer;

  void startTimer() {
    if (widget.machine["remainingTime"] != null) {
      MAX_TIME = remainingTime = widget.machine["remainingTime"];
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (mounted) {
            setState(() {
              if (remainingTime > 0) {
                remainingTime--;
                if (remainingTime == 300) {
                  NotificationService().show5mNotification();
                }
              } else {
                setState(() {
                  widget.machine["isRunning"] = false;
                  NotificationService().showEndedNotification("Dry");
                });
                return;
              }
            });
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didUpdateWidget(covariant CurrentDryer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      timer?.cancel();
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isRunning = widget.machine["isRunning"];
    Image icon = isRunning
        ? Image.asset(
            "assets/dryer_running.gif",
            width: screenWidth * 0.25,
          )
        : Image.asset(
            "assets/dryer_vacant.png",
            width: screenWidth * 0.25,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.84 * 0.67,
              height: screenWidth * 0.462,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.045),
                color: const Color(0xff761111),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.025),
                    child: icon,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.025),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Washer No.${widget.machine["code"]}",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                            height: 0.3,
                          ),
                        ),
                        Text(
                          remainingTime > 0
                              ? "${remainingTime ~/ 60} m ${remainingTime % 60} s"
                              : "VACANT",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: screenWidth * 0.84 * 0.03,
            ),
            Column(
              children: [
                Container(
                  width: screenWidth * 0.84 * 0.3,
                  height: screenWidth * 0.462 * 0.25,
                  decoration: BoxDecoration(
                    color: const Color(0xff761111),
                    borderRadius: BorderRadius.circular(screenWidth * 0.045),
                  ),
                  child: Center(
                    child: Text(
                      "${remainingTime / MAX_TIME * 100} %",
                      style: GoogleFonts.inter(
                        color: const Color(0xff1B3D71),
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.84 * 0.05,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenWidth * 0.462 * 0.05,
                ),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.045),
                    ),
                    disabledBackgroundColor: const Color(0xff7C7C7C),
                    backgroundColor: const Color(0xff761111),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.84 * 0.3,
                    height: screenWidth * 0.462 * 0.325,
                    child: const Center(
                      child: Icon(
                        size: 50,
                        Icons.bug_report_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenWidth * 0.462 * 0.05,
                ),
                ElevatedButton(
                  onPressed: remainingTime > 0
                      ? null
                      : () {
                          Prefs.removeValue("current");
                          State<MainPage>? parent = context
                              .findAncestorStateOfType<State<MainPage>>();
                          parent?.setState(() {});
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.045),
                    ),
                    disabledBackgroundColor: const Color(0xff7C7C7C),
                    backgroundColor: const Color(0xff761111),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.84 * 0.3,
                    height: screenWidth * 0.462 * 0.325,
                    child: const Center(
                      child: Icon(
                        size: 50,
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
