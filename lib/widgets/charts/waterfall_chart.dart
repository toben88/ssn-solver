import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/provision.dart';

class WaterfallChart extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const WaterfallChart({
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
          'Add provisions to see the waterfall chart',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    // Generate waterfall data
    final List<BarChartGroupData> barGroups = [];
    final List<String> labels = [];
    double runningTotal = projectedDeficit;
    
    // Start with projected deficit
    barGroups.add(BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: projectedDeficit,
          color: colorScheme.error,
          width: isSmallScreen ? 20 : 30,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        )
      ],
    ));
    labels.add('Projected');
    
    // Add each provision's contribution
    for (int i = 0; i < selectedProvisions.length; i++) {
      final provision = selectedProvisions[i];
      // In a real app, you would calculate the actual impact value
      // For demonstration, we're distributing the impact evenly
      final impact = (projectedDeficit - currentDeficit) / selectedProvisions.length;
      runningTotal -= impact;
      
      // Add negative bar to represent deficit reduction
      barGroups.add(BarChartGroupData(
        x: i + 1,
        barRods: [
          BarChartRodData(
            toY: -impact, // Negative value for reduction
            color: _getProvisionColor(provision.id[0], colorScheme),
            width: isSmallScreen ? 20 : 30,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          )
        ],
      ));
      labels.add(provision.id);
    }
    
    // End with current deficit
    barGroups.add(BarChartGroupData(
      x: selectedProvisions.length + 1,
      barRods: [
        BarChartRodData(
          toY: currentDeficit,
          color: colorScheme.primary,
          width: isSmallScreen ? 20 : 30,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        )
      ],
    ));
    labels.add('Current');
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Waterfall Chart: Deficit Reduction Steps',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                // Extend range to accommodate negative values
                minY: -(projectedDeficit - currentDeficit),
                maxY: projectedDeficit * 1.1,
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.abs().toStringAsFixed(1)}T',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontSize: isSmallScreen ? 9 : 12,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= labels.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            labels[value.toInt()],
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontSize: isSmallScreen ? 9 : 12,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.outlineVariant.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Each bar shows the incremental effect of each provision on the deficit',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
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
