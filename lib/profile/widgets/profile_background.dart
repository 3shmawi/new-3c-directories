import 'package:flutter/material.dart';

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF6A25C), Color(0xFFD66B4B)],
                ),
              ),
            ),

            // White area with curved TOP edge
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: TopArcClipper(arcHeight: 60), // tweak height to taste
                child: Container(
                  height: size.height * .8,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopArcClipper extends CustomClipper<Path> {
  final double arcHeight; // how "deep" the smile is
  TopArcClipper({this.arcHeight = 60});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // start at top-left corner, then drop to arc start
    path.lineTo(0, arcHeight);
    // draw a single smooth upward arc to the right edge
    path.quadraticBezierTo(w / 2, -arcHeight, w, arcHeight);
    // finish the rectangle
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TopArcClipper oldClipper) =>
      oldClipper.arcHeight != arcHeight;
}
