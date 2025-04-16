import 'package:flutter/material.dart';
import '../../models/provision.dart';

class TreeMapChart extends StatelessWidget {
  final double projectedDeficit;
  final double currentDeficit;
  final List<Provision> selectedProvisions;

  const TreeMapChart({
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
          'Add provisions to see the tree map',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    // Sort provisions by impact for better visualization
    final totalReduction = projectedDeficit - currentDeficit;
    final List<_TreeMapItem> treeMapItems = [];

    // Build list of tree map items
    for (int i = 0; i < selectedProvisions.length; i++) {
      final provision = selectedProvisions[i];
      // In a real app, you would calculate the actual impact value
      // For demonstration, we're distributing the impact evenly
      final impact = totalReduction / selectedProvisions.length;
      
      treeMapItems.add(_TreeMapItem(
        provision: provision,
        impact: impact,
        color: _getProvisionColor(provision.id[0], colorScheme),
      ));
    }
    
    // Sort by impact (largest first)
    treeMapItems.sort((a, b) => b.impact.compareTo(a.impact));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tree Map: Impact of Selected Provisions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomTreeMap(
              items: treeMapItems,
              maxValue: totalReduction,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Rectangle size represents the relative impact of each provision',
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

class _TreeMapItem {
  final Provision provision;
  final double impact;
  final Color color;

  _TreeMapItem({
    required this.provision,
    required this.impact,
    required this.color,
  });
}

class CustomTreeMap extends StatelessWidget {
  final List<_TreeMapItem> items;
  final double maxValue;

  const CustomTreeMap({
    super.key,
    required this.items,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final textTheme = Theme.of(context).textTheme;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        
        // Create a tree map layout using squarified algorithm
        final layout = _computeSquarifiedLayout(items, width, height);
        
        return Stack(
          children: [
            for (final cell in layout)
              Positioned(
                left: cell.x,
                top: cell.y,
                width: cell.width,
                height: cell.height,
                child: Container(
                  decoration: BoxDecoration(
                    color: cell.item.color,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cell.width >= 60 && cell.height >= 40) ...[
                        Text(
                          cell.item.provision.id,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 12 : 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${cell.item.impact.toStringAsFixed(1)}T',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 10 : 14,
                          ),
                        ),
                      ] else if (cell.width >= 40 && cell.height >= 30) ...[
                        Text(
                          cell.item.provision.id,
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 10 : 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
  
  // Simplified implementation of the squarified treemap algorithm
  List<_TreeMapCell> _computeSquarifiedLayout(
    List<_TreeMapItem> items,
    double width,
    double height,
  ) {
    final List<_TreeMapCell> result = [];
    
    // Base case for simple layout
    double x = 0;
    double y = 0;
    double remainingWidth = width;
    double remainingHeight = height;
    
    for (final item in items) {
      // Calculate area proportion based on impact
      final proportion = item.impact / maxValue;
      final area = proportion * width * height;
      
      double cellWidth, cellHeight;
      
      // Decide whether to stack horizontally or vertically
      if (remainingWidth > remainingHeight) {
        // Stack horizontally
        cellWidth = area / remainingHeight;
        cellHeight = remainingHeight;
        
        result.add(_TreeMapCell(
          item: item,
          x: x,
          y: y,
          width: cellWidth,
          height: cellHeight,
        ));
        
        x += cellWidth;
        remainingWidth -= cellWidth;
      } else {
        // Stack vertically
        cellWidth = remainingWidth;
        cellHeight = area / remainingWidth;
        
        result.add(_TreeMapCell(
          item: item,
          x: x,
          y: y,
          width: cellWidth,
          height: cellHeight,
        ));
        
        y += cellHeight;
        remainingHeight -= cellHeight;
      }
    }
    
    return result;
  }
}

class _TreeMapCell {
  final _TreeMapItem item;
  final double x;
  final double y;
  final double width;
  final double height;

  _TreeMapCell({
    required this.item,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}
