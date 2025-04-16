import 'package:flutter/material.dart';
import '../../models/provision.dart';

class ProgressBarsChart extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const ProgressBarsChart({
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
          'Add provisions to see the progress bars',
          style: textTheme.titleMedium,
        ),
      );
    }

    final totalReduction = projectedDeficit - currentDeficit;
    final percentReduction = (totalReduction / projectedDeficit * 100).clamp(0, 100);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Progress Bars: Deficit Reduction by Provision',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Main progress bar showing overall reduction
          Text(
            'Overall Deficit Reduction: ${percentReduction.toStringAsFixed(1)}%',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentReduction / 100,
            backgroundColor: colorScheme.error.withOpacity(0.2),
            color: colorScheme.primary,
            minHeight: isSmallScreen ? 20 : 24,
            borderRadius: BorderRadius.circular(4),
          ),
          
          // Breakdown of current vs. projected
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${currentDeficit.toStringAsFixed(1)}T',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontSize: isSmallScreen ? 11 : 14,
                  ),
                ),
                Text(
                  '\$${projectedDeficit.toStringAsFixed(1)}T',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontSize: isSmallScreen ? 11 : 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Individual progress bars for each provision
          Text(
            'Contribution by Provision',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              itemCount: selectedProvisions.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final provision = selectedProvisions[index];
                // In a real app, you would use actual impact values from your data model
                // Here we're distributing the impact evenly for demonstration
                final impact = totalReduction / selectedProvisions.length;
                final percentContribution = (impact / projectedDeficit * 100).clamp(0, 100);
                
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: isSmallScreen ? 12 : 16,
                                height: isSmallScreen ? 12 : 16,
                                decoration: BoxDecoration(
                                  color: _getProvisionColor(provision.id[0], colorScheme),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                provision.id,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${impact.toStringAsFixed(1)}T (${percentContribution.toStringAsFixed(1)}%)',
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: isSmallScreen ? 11 : 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: percentContribution / 100,
                        backgroundColor: colorScheme.surfaceVariant,
                        color: _getProvisionColor(provision.id[0], colorScheme),
                        minHeight: isSmallScreen ? 12 : 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          Text(
            'Longer bars represent larger contributions to deficit reduction',
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
