import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/provision.dart';
import 'dart:math' as math;

class DonutChart extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const DonutChart({
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
          'Add provisions to see the donut chart',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final totalReduction = projectedDeficit - currentDeficit;
    final percentReduction = (totalReduction / projectedDeficit * 100).clamp(0, 100);
    
    // Build pie chart sections
    final List<PieChartSectionData> sections = [];
    
    // Add sections for each provision
    for (int i = 0; i < selectedProvisions.length; i++) {
      final provision = selectedProvisions[i];
      // In a real app, you would use actual impact values from your data model
      // Here we're distributing the impact evenly for demonstration
      final impact = totalReduction / selectedProvisions.length;
      final sectionValue = (impact / projectedDeficit) * 100;
      
      sections.add(
        PieChartSectionData(
          value: sectionValue,
          color: _getProvisionColor(provision.id[0], colorScheme),
          title: isSmallScreen ? '' : provision.id,
          radius: isSmallScreen ? 55 : 70,
          titleStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 10 : 14,
          ),
          badgeWidget: sectionValue < 5 ? null : Text(
            provision.id,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 9 : 12,
            ),
          ),
          badgePositionPercentageOffset: 0.8,
        ),
      );
    }
    
    // Add remaining deficit section
    final remainingPercentage = 100 - percentReduction;
    if (remainingPercentage > 0) {
      sections.add(
        PieChartSectionData(
          value: remainingPercentage.toDouble(),
          color: colorScheme.error.withOpacity(0.7),
          title: isSmallScreen ? '' : 'Remaining',
          radius: isSmallScreen ? 55 : 70,
          titleStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 10 : 14,
          ),
          badgeWidget: null,
          badgePositionPercentageOffset: 0.8,
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 6.0 : 12.0,
        right: isSmallScreen ? 6.0 : 12.0,
        bottom: isSmallScreen ? 2.0 : 6.0,
        top: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Donut Chart: Deficit Reduction Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: isSmallScreen ? 25 : 35,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentReduction.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Deficit\nReduced',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 16),
          // Legend
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              for (int i = 0; i < selectedProvisions.length; i++)
                _buildLegendItem(
                  context,
                  selectedProvisions[i].id,
                  _getProvisionColor(selectedProvisions[i].id[0], colorScheme),
                  isSmallScreen,
                ),
              if (remainingPercentage > 0)
                _buildLegendItem(
                  context,
                  'Remaining',
                  colorScheme.error.withOpacity(0.7),
                  isSmallScreen,
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'Each segment represents a provision\'s contribution to deficit reduction',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
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
