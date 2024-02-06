import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DormButton extends StatefulWidget {
  const DormButton({
    super.key,
    required this.width,
    required this.type,
  });

  final double width;
  final int type;
  @override
  State<DormButton> createState() => _DormButtonState();
}

class _DormButtonState extends State<DormButton> {
  Color color = const Color(0xffA0A2BA);

  @override
  Widget build(BuildContext context) {
    String sex = widget.type % 2 == 0 ? "Women" : "Men";
    String dorm = widget.type < 2 ? "A" : "B";

    return ElevatedButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        List<String> dorms = ["Women A", "Men A", "Women B", "Men B"];
        prefs.setString("dorm", dorms[widget.type]);
        color = const Color(0xff2E3784);
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: const Color(0xff2E3784),
        backgroundColor: color,
        foregroundColor: const Color(0xffA0A2BA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.width * 0.2),
        ),
        maximumSize: Size(widget.width, widget.width),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dorm,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 58,
                color: Colors.white,
              ),
            ),
            Text(
              sex,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
