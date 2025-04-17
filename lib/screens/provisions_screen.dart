import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provisions_provider.dart';
import '../widgets/category_filter.dart';
import '../widgets/provision_card.dart';
import '../widgets/deficit_tracker_donut.dart';
import '../models/provision.dart';
import 'visualizations_screen.dart';

class ProvisionsScreen extends StatelessWidget {
  const ProvisionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Security Solver', style: TextStyle(fontSize: isSmallScreen ? 18 : 20)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Social Security Solver',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 48),
                applicationLegalese: '© 2025 SSN Solver',
                children: [
                  const SizedBox(height: 16),
                  const Text('A tool to model and solve the Social Security shortfall through various policy provisions.'),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ProvisionsProvider>(
          builder: (context, provider, child) {
            if (!provider.isInitialized) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading provisions...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Deficit Tracker at the top
                DeficitTracker(
                  projectedDeficit: provider.projectedDeficit,
                  currentDeficit: provider.currentDeficit,
                  selectedProvisions: provider.selectedProvisions,
                ),
                // Category filter below the deficit tracker
                const CategoryFilter(),
                // Main content area
                Expanded(
                  child: provider.provisions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No provisions found',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => provider.refresh(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Refresh'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          onRefresh: () async {
                            provider.refresh();
                          },
                          child: RawScrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            thickness: 8,
                            thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                            trackColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            radius: const Radius.circular(10),
                            child: ListView.builder(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              itemCount: provider.provisions.length,
                              itemBuilder: (context, index) {
                                final provision = provider.provisions[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                                  child: ProvisionCard(
                                    provision: provision,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      // Add a floating action button to reset selections
      // Reset selections button (original position)
      // Use a custom approach for both buttons with absolute positioning
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          // Visualize button (left-most)
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              mini: isSmallScreen,
              heroTag: 'visualize',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VisualizationsScreen(),
                  ),
                );
              },
              tooltip: isSmallScreen ? 'Visualize' : 'Visualizations',
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Theme.of(context).colorScheme.onTertiary,
              child: const Icon(Icons.auto_graph),
            ),
          ),
          
          // Actuarial data button (middle)
          Positioned(
            left: isSmallScreen ? 72 : 96,
            bottom: 16,
            child: FloatingActionButton(
              mini: isSmallScreen,
              heroTag: 'actuarial',
              onPressed: () {
                Navigator.pushNamed(context, '/actuarial');
              },
              tooltip: isSmallScreen ? 'Real Data' : 'Actuarial Data',
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.data_usage),
            ),
          ),
          
          // Reset button on the right
          Positioned(
            right: 16,
            bottom: 16,
            child: Consumer<ProvisionsProvider>(
              builder: (context, provider, _) {
                return provider.selectedProvisions.isNotEmpty
                    ? FloatingActionButton(
                        mini: isSmallScreen,
                        heroTag: 'reset',
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Reset Selections?'),
                              content: const Text('This will remove all selected provisions and reset the deficit to its original value.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    provider.resetSelections();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        tooltip: 'Reset selections',
                        child: const Icon(Icons.restart_alt),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
