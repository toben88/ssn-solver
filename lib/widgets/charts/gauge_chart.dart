import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/provision.dart';

class GaugeChart extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const GaugeChart({
    super.key,
    required this.projectedDeficit,
    required this.currentDeficit,
    required this.selectedProvisions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // If no provisions are selected, show placeholder
    if (selectedProvisions.isEmpty) {
      return Center(
        child: Text(
          'Add provisions to see the gauge chart',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final percentReduction = ((projectedDeficit - currentDeficit) / projectedDeficit * 100).clamp(0, 100);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Gauge Chart: Deficit Reduction Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 3,
            child: CustomPaint(
              painter: GaugePainter(
                percentReduction: percentReduction.toDouble(),
                colorScheme: colorScheme,
                isSmallScreen: isSmallScreen,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${percentReduction.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: isSmallScreen ? 32 : 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Reduced',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: isSmallScreen ? 16 : 20,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 40 : 70),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              margin: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 8 : 16,
                horizontal: isSmallScreen ? 8 : 32,
              ),
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Projected Deficit',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: isSmallScreen ? 11 : 14,
                              ),
                            ),
                            Text(
                              '\$${projectedDeficit.toStringAsFixed(1)}T',
                              style: TextStyle(
                                color: colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 16 : 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Current Deficit',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: isSmallScreen ? 11 : 14,
                              ),
                            ),
                            Text(
                              '\$${currentDeficit.toStringAsFixed(1)}T',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 16 : 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Provisions',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: isSmallScreen ? 11 : 14,
                              ),
                            ),
                            Text(
                              '${selectedProvisions.length}',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 16 : 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Savings',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: isSmallScreen ? 11 : 14,
                              ),
                            ),
                            Text(
                              '\$${(projectedDeficit - currentDeficit).toStringAsFixed(1)}T',
                              style: TextStyle(
                                color: colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 16 : 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentReduction;
  final ColorScheme colorScheme;
  final bool isSmallScreen;

  GaugePainter({
    required this.percentReduction,
    required this.colorScheme,
    required this.isSmallScreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.5);
    final radius = math.min(size.width * 0.8, size.height * 0.8) / 2;
    
    // Draw gauge background
    final bgPaint = Paint()
      ..color = colorScheme.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSmallScreen ? 25 : 35
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );
    
    // Draw progress
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [colorScheme.error, colorScheme.primary],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSmallScreen ? 25 : 35
      ..strokeCap = StrokeCap.round;
    
    final progressAngle = (percentReduction / 100) * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      progressAngle,
      false,
      progressPaint,
    );
    
    // Draw tick marks
    final tickPaint = Paint()
      ..color = colorScheme.onSurface.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 10; i++) {
      final angle = math.pi + (i / 10) * math.pi;
      final outerPoint = Offset(
        center.dx + (radius + (isSmallScreen ? 15 : 25)) * math.cos(angle),
        center.dy + (radius + (isSmallScreen ? 15 : 25)) * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius + (isSmallScreen ? 5 : 15)) * math.cos(angle),
        center.dy + (radius + (isSmallScreen ? 5 : 15)) * math.sin(angle),
      );
      
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
      
      // Draw tick labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i * 10}%',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: isSmallScreen ? 10 : 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      final labelPoint = Offset(
        center.dx + (radius + (isSmallScreen ? 35 : 48)) * math.cos(angle) - textPainter.width / 2,
        center.dy + (radius + (isSmallScreen ? 35 : 48)) * math.sin(angle) - textPainter.height / 2,
      );
      
      textPainter.paint(canvas, labelPoint);
    }
    
    // Draw needle
    final needleAngle = math.pi + (percentReduction / 100) * math.pi;
    
    final needlePaint = Paint()
      ..color = colorScheme.secondary
      ..style = PaintingStyle.fill;
    
    final needleLength = radius * 0.8;
    final needleBaseRadius = isSmallScreen ? 10.0 : 15.0;
    
    final needlePoint = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );
    
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(
        center.dx + needleBaseRadius * math.cos(needleAngle + math.pi/2),
        center.dy + needleBaseRadius * math.sin(needleAngle + math.pi/2),
      )
      ..lineTo(needlePoint.dx, needlePoint.dy)
      ..lineTo(
        center.dx + needleBaseRadius * math.cos(needleAngle - math.pi/2),
        center.dy + needleBaseRadius * math.sin(needleAngle - math.pi/2),
      )
      ..close();
    
    canvas.drawPath(path, needlePaint);
    
    // Draw needle center circle
    final centerCirclePaint = Paint()
      ..color = colorScheme.secondary
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, needleBaseRadius, centerCirclePaint);
    
    final centerInnerCirclePaint = Paint()
      ..color = colorScheme.surface
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, needleBaseRadius * 0.7, centerInnerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
