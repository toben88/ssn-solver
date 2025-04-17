import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show max;
import '../models/provision.dart';
import '../providers/provisions_provider.dart';
import './charts/donut_chart.dart';

class DeficitTracker extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;
  
  const DeficitTracker({
    super.key,
    required this.projectedDeficit,
    required this.currentDeficit,
    required this.selectedProvisions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deficitReduction = projectedDeficit - currentDeficit;
    final percentReduction = (deficitReduction / projectedDeficit * 100).clamp(0, 100);
    final isImproving = currentDeficit < projectedDeficit;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Container(
      height: isSmallScreen ? 360 : 350,
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isImproving ? colorScheme.primary : colorScheme.error,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isImproving 
                    ? 'Improving: ${percentReduction.toStringAsFixed(1)}%'
                    : 'No Change',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 6),
          Expanded(
            child: isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Deficit visualization (top on mobile)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Donut Chart (replacing the original deficit chart)
                            Expanded(
                              child: DonutChart(
                                projectedDeficit: projectedDeficit,
                                currentDeficit: currentDeficit,
                                selectedProvisions: selectedProvisions,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 4 : 6),
                            // Deficit values
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Projected',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                    ),
                                    Text(
                                      '\$${projectedDeficit.toStringAsFixed(1)}T',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Current',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                    ),
                                    Text(
                                      '\$${currentDeficit.toStringAsFixed(1)}T',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: isImproving ? colorScheme.primary : colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      // Selected provisions (bottom on mobile)

                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Deficit visualization (left side on desktop)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Donut Chart (replacing the original deficit chart)
                            Expanded(
                              child: DonutChart(
                                projectedDeficit: projectedDeficit,
                                currentDeficit: currentDeficit,
                                selectedProvisions: selectedProvisions,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 4 : 6),
                            // Deficit values
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Projected',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                    ),
                                    Text(
                                      '\$${projectedDeficit.toStringAsFixed(1)}T',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Current',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                    ),
                                    Text(
                                      '\$${currentDeficit.toStringAsFixed(1)}T',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: isImproving ? colorScheme.primary : colorScheme.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
  
  Color _getProvisionColor(String categoryId, ColorScheme colorScheme) {
    switch (categoryId) {
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
