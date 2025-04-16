import 'package:flutter/material.dart';
import '../../models/provision.dart';

class TimelineView extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const TimelineView({
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
          'Add provisions to see the timeline view',
          style: textTheme.titleMedium,
        ),
      );
    }

    // Create milestone years
    final milestoneYears = [
      _Milestone(year: 2024, label: 'Current', isStart: true),
      _Milestone(year: 2030, label: 'Mid-term'),
      _Milestone(year: 2035, label: 'Trust Fund\nDepletion'),
      _Milestone(year: 2040, label: 'Long-term'),
      _Milestone(year: 2050, label: 'Extended'),
      _Milestone(year: 2060, label: 'Future'),
    ];
    
    // Total reduction and percentage calculations
    final totalReduction = projectedDeficit - currentDeficit;
    final percentReduction = (totalReduction / projectedDeficit * 100).clamp(0, 100);
    
    // Sort provisions by their timeline impact
    // In a real app, you would have more complex timeline data
    // For now, we'll just simulate different provisions affecting different time periods
    final timelineProvisions = <_TimelineProvision>[];
    
    for (int i = 0; i < selectedProvisions.length; i++) {
      final provision = selectedProvisions[i];
      
      // Simulate timeline impact based on provision ID for demonstration
      // In a real app, this would come from actual provision data
      int startYear, endYear;
      double impact;
      
      switch (provision.id[0]) {
        case 'A': // COLA provisions - immediate impact
          startYear = 2024;
          endYear = 2060;
          impact = totalReduction * 0.2 / (selectedProvisions.length / 2);
          break;
        case 'B': // Benefit provisions - mid-term impact
          startYear = 2030;
          endYear = 2060;
          impact = totalReduction * 0.15 / (selectedProvisions.length / 2);
          break;
        case 'C': // Coverage provisions - short to mid-term impact
          startYear = 2024;
          endYear = 2040;
          impact = totalReduction * 0.1 / (selectedProvisions.length / 2);
          break;
        case 'E': // Retirement age - long-term impact
          startYear = 2035;
          endYear = 2060;
          impact = totalReduction * 0.2 / (selectedProvisions.length / 2);
          break;
        case 'F': // Family benefits - mid-term impact
          startYear = 2030;
          endYear = 2050;
          impact = totalReduction * 0.1 / (selectedProvisions.length / 2);
          break;
        case 'G': // Investment - long-term impact
          startYear = 2030;
          endYear = 2060;
          impact = totalReduction * 0.15 / (selectedProvisions.length / 2);
          break;
        case 'H': // Taxation - immediate impact
          startYear = 2024;
          endYear = 2050;
          impact = totalReduction * 0.1 / (selectedProvisions.length / 2);
          break;
        default:
          startYear = 2030;
          endYear = 2050;
          impact = totalReduction * 0.1 / selectedProvisions.length;
      }
      
      timelineProvisions.add(_TimelineProvision(
        provision: provision,
        startYear: startYear,
        endYear: endYear,
        impact: impact,
        color: _getProvisionColor(provision.id[0], colorScheme),
      ));
    }
    
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Timeline View: Deficit Reduction Over Time',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: isSmallScreen ? 16 : 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Timeline axis
          Container(
            height: isSmallScreen ? 60 : 80,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Timeline line
                Positioned(
                  left: 0,
                  right: 0,
                  top: isSmallScreen ? 25 : 35,
                  child: Container(
                    height: 2,
                    color: colorScheme.outline,
                  ),
                ),
                
                // Timeline milestones
                for (int i = 0; i < milestoneYears.length; i++)
                  Positioned(
                    left: i / (milestoneYears.length - 1) * (isSmallScreen ? 0.95 : 0.96) * MediaQuery.of(context).size.width,
                    top: isSmallScreen ? 15 : 20,
                    child: _buildMilestone(
                      context,
                      milestoneYears[i],
                      i == 0,
                      isSmallScreen,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Timeline bars for each provision
          Expanded(
            child: ListView.builder(
              itemCount: timelineProvisions.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = timelineProvisions[index];
                return _buildTimelineProvisionBar(
                  context,
                  item,
                  milestoneYears,
                  isSmallScreen,
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Summary section
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Timeline Insights',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInsightCard(
                        context,
                        'Near-term Impact',
                        '${_calculateNearTermImpact(timelineProvisions, 2024, 2030, projectedDeficit).toStringAsFixed(1)}%',
                        colorScheme.primary,
                        isSmallScreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInsightCard(
                        context,
                        'Long-term Impact',
                        '${percentReduction.toStringAsFixed(1)}%',
                        colorScheme.tertiary,
                        isSmallScreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          Text(
            'Bars show when and how each provision impacts the deficit over time',
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
  
  double _calculateNearTermImpact(
    List<_TimelineProvision> provisions,
    int startYear,
    int endYear,
    double projectedDeficit,
  ) {
    double totalImpact = 0;
    for (final item in provisions) {
      if (item.startYear <= endYear && item.endYear >= startYear) {
        // Calculate proportional impact for the period
        final yearsInPeriod = math.min(item.endYear, endYear) - math.max(item.startYear, startYear) + 1;
        final totalYears = item.endYear - item.startYear + 1;
        totalImpact += item.impact * yearsInPeriod / totalYears;
      }
    }
    return (totalImpact / projectedDeficit * 100).clamp(0, 100);
  }
  
  Widget _buildMilestone(
    BuildContext context,
    _Milestone milestone,
    bool isFirst,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: isSmallScreen ? 12 : 16,
          height: isSmallScreen ? 12 : 16,
          decoration: BoxDecoration(
            color: milestone.isStart
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          milestone.year.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 10 : 12,
          ),
        ),
        SizedBox(
          width: isSmallScreen ? 50 : 70,
          child: Text(
            milestone.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 9 : 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTimelineProvisionBar(
    BuildContext context,
    _TimelineProvision item,
    List<_Milestone> milestones,
    bool isSmallScreen,
  ) {
    // Calculate position and width based on start and end years
    final startYear = milestones.first.year;
    final endYear = milestones.last.year;
    final totalYears = endYear - startYear;
    
    final startPos = (item.startYear - startYear) / totalYears;
    final endPos = (item.endYear - startYear) / totalYears;
    final barWidth = endPos - startPos;
    
    // Calculate impact percentage for this provision
    final impact = (item.impact / projectedDeficit * 100).clamp(0, 10);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: isSmallScreen ? 56 : 70,
            child: Text(
              item.provision.id,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 11 : 13,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: isSmallScreen ? 24 : 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width * startPos * 0.65,
                    width: MediaQuery.of(context).size.width * barWidth * 0.65,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: impact >= 3 && MediaQuery.of(context).size.width * barWidth * 0.7 > 40
                            ? Text(
                                '${impact.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 10 : 12,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInsightCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: color,
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

class _Milestone {
  final int year;
  final String label;
  final bool isStart;

  _Milestone({
    required this.year,
    required this.label,
    this.isStart = false,
  });
}

class _TimelineProvision {
  final Provision provision;
  final int startYear;
  final int endYear;
  final double impact;
  final Color color;

  _TimelineProvision({
    required this.provision,
    required this.startYear,
    required this.endYear,
    required this.impact,
    required this.color,
  });
}

// Basic math import since we need min/max functions
class math {
  static int min(int a, int b) => a < b ? a : b;
  static int max(int a, int b) => a > b ? a : b;
}
