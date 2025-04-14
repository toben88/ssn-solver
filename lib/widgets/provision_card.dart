import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/provision.dart';
import '../providers/provisions_provider.dart';

class ProvisionCard extends StatelessWidget {
  final Provision provision;
  final bool isDragging;

  const ProvisionCard({
    super.key,
    required this.provision,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    // Determine the category color based on the provision's category
    Color categoryColor;
    IconData categoryIcon;
    
    switch (provision.id[0]) {
      case 'A':
        categoryColor = Colors.blue;
        categoryIcon = Icons.trending_up;
        break;
      case 'B':
        categoryColor = Colors.green;
        categoryIcon = Icons.attach_money;
        break;
      case 'C':
        categoryColor = Colors.orange;
        categoryIcon = Icons.calendar_today;
        break;
      case 'E':
        categoryColor = Colors.purple;
        categoryIcon = Icons.account_balance;
        break;
      default:
        categoryColor = colorScheme.primary;
        categoryIcon = Icons.policy;
    }
    
    return Card(
      elevation: isDragging ? 4 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor.withOpacity(0.2),
          child: Icon(categoryIcon, color: categoryColor, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: categoryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    provision.id,
                    style: textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    provision.category,
                    style: textTheme.labelMedium?.copyWith(
                      color: categoryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              provision.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        initiallyExpanded: isDragging,
        maintainState: true,
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: isDragging
            ? []
            : [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          provision.description,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      
                      // Impacts section
                      if (provision.impacts.isNotEmpty) ...[                        
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.insights, size: 16, color: categoryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Impacts',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...provision.impacts.map(
                          (impact) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.arrow_right, size: 16, color: colorScheme.onSurface.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    impact,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      // Related links section
                      if (provision.relatedLinks.isNotEmpty) ...[                        
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.link, size: 16, color: categoryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Related Links',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: provision.relatedLinks.entries.map(
                            (entry) => ActionChip(
                              avatar: Icon(
                                entry.key == 'graph' ? Icons.bar_chart : Icons.table_chart,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              label: Text(
                                entry.key.substring(0, 1).toUpperCase() + entry.key.substring(1),
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
                              onPressed: () => _launchUrl(entry.value),
                            ),
                          ).toList(),
                        ),
                      ],
                      
                      // Add to selection button
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: categoryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            final provider = Provider.of<ProvisionsProvider>(
                              context, 
                              listen: false
                            );
                            provider.addSelectedProvision(provision);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add to Selection'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
