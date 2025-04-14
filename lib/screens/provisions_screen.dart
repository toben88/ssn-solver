import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provisions_provider.dart';
import '../widgets/category_filter.dart';
import '../widgets/provision_card.dart';
import '../widgets/deficit_tracker.dart';
import '../models/provision.dart';

class ProvisionsScreen extends StatelessWidget {
  const ProvisionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Security Solver'),
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
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.provisions.length,
                            itemBuilder: (context, index) {
                              final provision = provider.provisions[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Draggable<Provision>(
                                  data: provision,
                                  feedback: Material(
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: ProvisionCard(
                                        provision: provision,
                                        isDragging: true,
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child: ProvisionCard(
                                      provision: provision,
                                    ),
                                  ),
                                  child: ProvisionCard(
                                    provision: provision,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      // Add a floating action button to reset selections
      floatingActionButton: Consumer<ProvisionsProvider>(
        builder: (context, provider, _) {
          return provider.selectedProvisions.isNotEmpty
              ? FloatingActionButton(
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
    );
  }
}
