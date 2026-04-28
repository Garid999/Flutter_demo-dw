import 'package:flutter/material.dart';

class PaintingDemo extends StatefulWidget {
  const PaintingDemo({super.key});

  @override
  State<PaintingDemo> createState() => _PaintingDemoState();
}

class _PaintingDemoState extends State<PaintingDemo> {
  // Start and end points (fixed)
  final Offset p0 = const Offset(30, 150);
  final Offset p3 = const Offset(270, 150);

  // Control points (adjustable via sliders)
  double cp1x = 80;
  double cp1y = 20;
  double cp2x = 220;
  double cp2y = 280;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Cubic Bezier Curve')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Canvas
            Center(
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: BezierPainter(
                    p0: p0,
                    p1: Offset(cp1x, cp1y),
                    p2: Offset(cp2x, cp2y),
                    p3: p3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(Colors.green, 'P0 / P3 (fixed)'),
                const SizedBox(width: 16),
                _legendDot(Colors.blue, 'CP1'),
                const SizedBox(width: 16),
                _legendDot(Colors.red, 'CP2'),
              ],
            ),
            const SizedBox(height: 20),

            // Sliders for Control Point 1
            _sectionLabel('Control Point 1 (blue)', Colors.blue),
            _slider('CP1 X', cp1x, 0, 300, (v) => setState(() => cp1x = v)),
            _slider('CP1 Y', cp1y, 0, 300, (v) => setState(() => cp1y = v)),
            const SizedBox(height: 12),

            // Sliders for Control Point 2
            _sectionLabel('Control Point 2 (red)', Colors.red),
            _slider('CP2 X', cp2x, 0, 300, (v) => setState(() => cp2x = v)),
            _slider('CP2 Y', cp2y, 0, 300, (v) => setState(() => cp2y = v)),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _slider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text('$label: ${value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12))),
        Expanded(
          child: Slider(min: min, max: max, value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}

class BezierPainter extends CustomPainter {
  final Offset p0;
  final Offset p1;
  final Offset p2;
  final Offset p3;

  const BezierPainter({
    required this.p0,
    required this.p1,
    required this.p2,
    required this.p3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final curvePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final guidePaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);

    // Draw guide lines from endpoints to their control points
    canvas.drawLine(p0, p1, guidePaint);
    canvas.drawLine(p3, p2, guidePaint);

    // Draw the bezier curve
    canvas.drawPath(path, curvePaint);

    // Draw control points
    _drawPoint(canvas, p0, Colors.green, 'P0');
    _drawPoint(canvas, p3, Colors.green, 'P3');
    _drawPoint(canvas, p1, Colors.blue, 'CP1');
    _drawPoint(canvas, p2, Colors.red, 'CP2');
  }

  void _drawPoint(Canvas canvas, Offset point, Color color, String label) {
    final dotPaint = Paint()..color = color;
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(point, 7, dotPaint);
    canvas.drawCircle(point, 7, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(text: label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, point + const Offset(9, -8));
  }

  @override
  bool shouldRepaint(BezierPainter old) {
    return old.p0 != p0 || old.p1 != p1 || old.p2 != p2 || old.p3 != p3;
  }
}
