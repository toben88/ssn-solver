import 'package:flutter/material.dart';
import '../../models/provision.dart';
import 'dart:math' as math;

class SankeyDiagram extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const SankeyDiagram({
    super.key,
    required this.projectedDeficit,
    required this.currentDeficit,
    required this.selectedProvisions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // If no provisions are selected, show placeholder
    if (selectedProvisions.isEmpty) {
      return Center(
        child: Text(
          'Add provisions to see the Sankey diagram',
          style: textTheme.titleMedium,
        ),
      );
    }

    // Group provisions by category
    final Map<String, List<Provision>> provisionsByCategory = {};
    final Map<String, double> categoryTotals = {};
    final Map<String, String> categoryNames = {
      'A': 'COLA',
      'B': 'Benefits',
      'C': 'Coverage',
      'E': 'Retirement Age',
      'F': 'Family Benefits',
      'G': 'Investments',
      'H': 'Taxation',
    };
    
    for (final provision in selectedProvisions) {
      final category = provision.id[0];
      if (!provisionsByCategory.containsKey(category)) {
        provisionsByCategory[category] = [];
      }
      provisionsByCategory[category]!.add(provision);
    }
    
    // Calculate category impact totals
    final totalReduction = projectedDeficit - currentDeficit;
    for (final category in provisionsByCategory.keys) {
      // Distribute impact evenly among provisions in real app
      categoryTotals[category] = (provisionsByCategory[category]!.length / selectedProvisions.length) * totalReduction;
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sankey Diagram: Deficit Reduction Flow',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              painter: SankeyPainter(
                projectedDeficit: projectedDeficit,
                currentDeficit: currentDeficit,
                categoryTotals: categoryTotals,
                categoryNames: categoryNames,
                colorScheme: colorScheme,
                isSmallScreen: isSmallScreen,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: provisionsByCategory.keys.map((category) {
              final name = categoryNames[category] ?? 'Other';
              final color = _getCategoryColor(category, colorScheme);
              return _buildLegendItem(context, name, color, isSmallScreen);
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Flow width represents deficit reduction contribution by category',
            style: textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: isSmallScreen ? 11 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildLegendItem(BuildContext context, String label, Color color, bool isSmallScreen) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSmallScreen ? 10 : 12,
          height: isSmallScreen ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: isSmallScreen ? 4 : 6),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 10 : 12,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case 'A': return Colors.blue.shade400;
      case 'B': return Colors.green.shade400;
      case 'C': return Colors.orange.shade400;
      case 'E': return Colors.purple.shade400;
      case 'F': return Colors.teal.shade400;
      case 'G': return Colors.indigo.shade400;
      case 'H': return Colors.amber.shade400;
      default: return colorScheme.primary.withOpacity(0.7);
    }
  }
}

class SankeyPainter extends CustomPainter {
  final double projectedDeficit;
  final double currentDeficit;
  final Map<String, double> categoryTotals;
  final Map<String, String> categoryNames;
  final ColorScheme colorScheme;
  final bool isSmallScreen;

  SankeyPainter({
    required this.projectedDeficit,
    required this.currentDeficit,
    required this.categoryTotals,
    required this.categoryNames,
    required this.colorScheme,
    required this.isSmallScreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Setup dimensions
    final leftMargin = size.width * 0.15;
    final rightMargin = size.width * 0.15;
    final middleX = size.width * 0.5;
    final nodeWidth = size.width * 0.1;
    final height = size.height * 0.8;
    final topMargin = size.height * 0.1;
    
    // Scale factors
    final heightScale = height / projectedDeficit;
    
    // Draw projected deficit node (left)
    final projectedRect = Rect.fromLTWH(
      leftMargin - nodeWidth,
      topMargin,
      nodeWidth,
      projectedDeficit * heightScale,
    );
    
    final projectedPaint = Paint()
      ..color = colorScheme.error
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(projectedRect, const Radius.circular(4)),
      projectedPaint,
    );
    
    // Draw current deficit node (right)
    final currentRect = Rect.fromLTWH(
      size.width - rightMargin,
      topMargin,
      nodeWidth,
      currentDeficit * heightScale,
    );
    
    final currentPaint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(currentRect, const Radius.circular(4)),
      currentPaint,
    );
    
    // Draw the flows for each category
    double runningY = topMargin;
    double runningRightY = topMargin;
    
    categoryTotals.forEach((category, impact) {
      final height = impact * heightScale;
      final color = _getCategoryColor(category, colorScheme);
      
      // Left bezier source points
      final leftStart = Offset(leftMargin, runningY);
      final leftEnd = Offset(leftMargin, runningY + height);
      
      // Middle column (category node) 
      final middleTop = Offset(middleX - nodeWidth/2, runningY);
      final middleBottom = Offset(middleX - nodeWidth/2, runningY + height);
      
      // Category node rectangle
      final categoryRect = Rect.fromLTWH(
        middleX - nodeWidth/2,
        runningY,
        nodeWidth,
        height,
      );
      
      final categoryPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      // Draw category node
      canvas.drawRRect(
        RRect.fromRectAndRadius(categoryRect, const Radius.circular(4)),
        categoryPaint,
      );
      
      // Right bezier end points
      final rightStart = Offset(size.width - rightMargin, runningRightY);
      final rightEnd = Offset(size.width - rightMargin, runningRightY + height);
      
      // Draw bezier paths
      final leftPath = Path()
        ..moveTo(leftStart.dx, leftStart.dy)
        ..lineTo(leftEnd.dx, leftEnd.dy)
        ..lineTo(middleBottom.dx, middleBottom.dy)
        ..lineTo(middleTop.dx, middleTop.dy)
        ..close();
      
      final rightPath = Path()
        ..moveTo(middleTop.dx + nodeWidth, middleTop.dy)
        ..lineTo(middleBottom.dx + nodeWidth, middleBottom.dy)
        ..lineTo(rightEnd.dx, rightEnd.dy)
        ..lineTo(rightStart.dx, rightStart.dy)
        ..close();
      
      // Draw flows with gradient opacity
      final leftPaint = Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      
      final rightPaint = Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(leftPath, leftPaint);
      canvas.drawPath(rightPath, rightPaint);
      
      // Draw category label if there's enough space
      if (height > 20) {
        final categoryName = categoryNames[category] ?? 'Other';
        final textPainter = TextPainter(
          text: TextSpan(
            text: categoryName,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 10 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        
        if (textPainter.width < height) {
          // Rotate and position text
          canvas.save();
          final centerX = middleX;
          final centerY = runningY + height/2;
          canvas.translate(centerX, centerY);
          canvas.rotate(-math.pi/2);
          textPainter.paint(
            canvas,
            Offset(-textPainter.width/2, -textPainter.height/2),
          );
          canvas.restore();
        }
      }
      
      runningY += height;
      runningRightY += height;
    });
    
    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // Projected deficit label
    textPainter.text = TextSpan(
      text: 'Projected\nDeficit',
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 11 : 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.textAlign = TextAlign.center;
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        leftMargin - nodeWidth/2 - textPainter.width/2,
        topMargin + projectedDeficit * heightScale + 10,
      ),
    );
    
    // Projected value label
    textPainter.text = TextSpan(
      text: '\$${projectedDeficit.toStringAsFixed(1)}T',
      style: TextStyle(
        color: colorScheme.error,
        fontSize: isSmallScreen ? 12 : 16,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        leftMargin - nodeWidth/2 - textPainter.width/2,
        topMargin + projectedDeficit * heightScale + (isSmallScreen ? 40 : 50),
      ),
    );
    
    // Current deficit label
    textPainter.text = TextSpan(
      text: 'Current\nDeficit',
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 11 : 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width - rightMargin + nodeWidth/2 - textPainter.width/2,
        topMargin + currentDeficit * heightScale + 10,
      ),
    );
    
    // Current value label
    textPainter.text = TextSpan(
      text: '\$${currentDeficit.toStringAsFixed(1)}T',
      style: TextStyle(
        color: colorScheme.primary,
        fontSize: isSmallScreen ? 12 : 16,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width - rightMargin + nodeWidth/2 - textPainter.width/2,
        topMargin + currentDeficit * heightScale + (isSmallScreen ? 40 : 50),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case 'A': return Colors.blue.shade400;
      case 'B': return Colors.green.shade400;
      case 'C': return Colors.orange.shade400;
      case 'E': return Colors.purple.shade400;
      case 'F': return Colors.teal.shade400;
      case 'G': return Colors.indigo.shade400;
      case 'H': return Colors.amber.shade400;
      default: return colorScheme.primary.withOpacity(0.7);
    }
  }
}
