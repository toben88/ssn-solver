import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provisions_provider.dart';
import '../models/provision.dart';
import 'package:fl_chart/fl_chart.dart';

// Import chart widgets
import '../widgets/charts/waterfall_chart.dart';
import '../widgets/charts/tree_map_chart.dart';
import '../widgets/charts/donut_chart.dart';
import '../widgets/charts/gauge_chart.dart';
import '../widgets/charts/progress_bars_chart.dart';
import '../widgets/charts/sankey_diagram.dart';
import '../widgets/charts/timeline_view.dart';

class VisualizationsScreen extends StatefulWidget {
  const VisualizationsScreen({super.key});

  @override
  State<VisualizationsScreen> createState() => _VisualizationsScreenState();
}

class _VisualizationsScreenState extends State<VisualizationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final colorScheme = Theme.of(context).colorScheme;
    final provider = Provider.of<ProvisionsProvider>(context);
    
    // Get the provider data for visualizations
    final selectedProvisions = provider.selectedProvisions;
    
    // For demo purposes - in a real app, these would be actual values from your data model
    final projectedDeficit = 20.0; // Example: $20 trillion projected deficit
    final reducedDeficit = selectedProvisions.isEmpty 
        ? projectedDeficit 
        : projectedDeficit - (selectedProvisions.length * 0.5); // Each provision reduces by 0.5T for demo

    return Scaffold(
      appBar: AppBar(
        title: Text('Deficit Visualizations', style: TextStyle(fontSize: isSmallScreen ? 16 : 18)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Waterfall Chart'),
            Tab(text: 'Tree Map'),
            Tab(text: 'Donut Chart'),
            Tab(text: 'Gauge Chart'),
            Tab(text: 'Progress Bars'),
            Tab(text: 'Sankey Diagram'),
            Tab(text: 'Timeline'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Waterfall Chart
          WaterfallChart(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
          
          // 2. Tree Map
          TreeMapChart(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
          
          // 3. Donut Chart
          DonutChart(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
          
          // 4. Gauge Chart
          GaugeChart(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
          
          // 5. Progress Bars
          ProgressBarsChart(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
          
          // 6. Sankey Diagram
          SankeyDiagram(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
          
          // 7. Timeline
          TimelineView(
            projectedDeficit: projectedDeficit,
            currentDeficit: reducedDeficit,
            selectedProvisions: selectedProvisions,
          ),
        ],
      ),
    );
  }
  
  // Method removed as we're now using implemented visualization widgets
}
