import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provisions_provider.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<ProvisionsProvider>(
      builder: (context, provider, child) {
        if (!provider.isInitialized) {
          return const SizedBox.shrink();
        }

        final categories = provider.categories;
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        // Define category icons and colors
        final Map<String, IconData> categoryIcons = {
          'all': Icons.category,
          'cola': Icons.trending_up,
          'benefit_level': Icons.attach_money,
          'retirement_age': Icons.calendar_today,
          'payroll_tax': Icons.account_balance,
        };
        
        final Map<String, Color> categoryColors = {
          'all': colorScheme.primary,
          'cola': Colors.blue,
          'benefit_level': Colors.green,
          'retirement_age': Colors.orange,
          'payroll_tax': Colors.purple,
        };

        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
              bottom: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
            ),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildFilterChip(
                context,
                'all',
                'All Provisions',
                provider.selectedCategory == 'all',
                provider,
                categoryIcons['all'] ?? Icons.category,
                categoryColors['all'] ?? colorScheme.primary,
              ),
              ...categories.entries.map((entry) => _buildFilterChip(
                    context,
                    entry.key,
                    entry.value,
                    provider.selectedCategory == entry.key,
                    provider,
                    categoryIcons[entry.key] ?? Icons.policy,
                    categoryColors[entry.key] ?? colorScheme.primary,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String id,
    String label,
    bool isSelected,
    ProvisionsProvider provider,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => provider.selectCategory(id),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? color : colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: isSelected ? color : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
