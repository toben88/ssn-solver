import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show max;
import '../models/provision.dart';
import '../providers/provisions_provider.dart';

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
      height: isSmallScreen ? 450 : 320,
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 8),
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
                            // Deficit chart
                            Expanded(
                              child: _buildDeficitChart(context, isImproving),
                            ),
                            const SizedBox(height: 8),
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
                      const SizedBox(height: 16),
                      // Selected provisions (bottom on mobile)
                      Expanded(
                        flex: 3,
                        child: DragTarget<Provision>(
                          onAccept: (provision) {
                            final provider = Provider.of<ProvisionsProvider>(context, listen: false);
                            provider.addSelectedProvision(provision);
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              decoration: BoxDecoration(
                                color: candidateData.isNotEmpty
                                    ? colorScheme.primaryContainer.withOpacity(0.3)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: candidateData.isNotEmpty
                                      ? colorScheme.primary
                                      : colorScheme.outline.withOpacity(0.5),
                                  width: candidateData.isNotEmpty ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer.withOpacity(0.5),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.drag_indicator,
                                            size: 14,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Selected Provisions',
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: colorScheme.primary,
                                                  fontSize: 12,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: selectedProvisions.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Drag provisions here',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: colorScheme.onSurface.withOpacity(0.6),
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          )
                                        : RawScrollbar(
                                            thumbVisibility: true,
                                            trackVisibility: true,
                                            thickness: 8,
                                            thumbColor: colorScheme.primary.withOpacity(0.6),
                                            trackColor: colorScheme.primary.withOpacity(0.1),
                                            radius: const Radius.circular(10),
                                            child: GridView.builder(
                                              padding: EdgeInsets.only(left: 4, right: 4, bottom: 4, top: isSmallScreen ? 0 : 4),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                childAspectRatio: isSmallScreen ? 0.4 : 0.33,
                                                crossAxisSpacing: 2,
                                                mainAxisSpacing: 2,
                                              ),
                                              itemCount: selectedProvisions.length,
                                              itemBuilder: (context, index) {
                                                final provision = selectedProvisions[index];
                                                return Chip(
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  visualDensity: VisualDensity.compact,
                                                  label: Text(
                                                    provision.id,
                                                    style: const TextStyle(fontSize: 10),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                                                  avatar: CircleAvatar(
                                                    backgroundColor: colorScheme.primary,
                                                    radius: 8,
                                                    child: Text(
                                                      provision.id[0],
                                                      style: const TextStyle(fontSize: 8, color: Colors.white),
                                                    ),
                                                  ),
                                                  deleteIcon: const Icon(Icons.close, size: 12),
                                                  onDeleted: () {
                                                    final provider = Provider.of<ProvisionsProvider>(
                                                      context,
                                                      listen: false,
                                                    );
                                                    provider.removeSelectedProvision(provision);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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
                            // Deficit chart
                            Expanded(
                              child: _buildDeficitChart(context, isImproving),
                            ),
                            const SizedBox(height: 8),
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
                      const SizedBox(width: 16),
