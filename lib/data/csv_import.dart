import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';

class ProvisionModel {
  final String categoryId;
  final String categoryName;
  final String provisionId;
  final String title;
  final String description;
  final String impacts;
  final double longRangeEffectRaw;
  final double year75EffectRaw;
  final int longRangeShortfallPct;
  final int year75ShortfallPct;
  final String longRangeEffect;
  final String year75Effect;
  final String graphLink;
  final String tableLink;

  ProvisionModel({
    required this.categoryId,
    required this.categoryName,
    required this.provisionId,
    required this.title,
    required this.description,
    required this.impacts,
    required this.longRangeEffectRaw,
    required this.year75EffectRaw,
    required this.longRangeShortfallPct,
    required this.year75ShortfallPct,
    required this.longRangeEffect,
    required this.year75Effect,
    required this.graphLink,
    required this.tableLink,
  });

  factory ProvisionModel.fromRow(List<dynamic> row) {
    try {
      return ProvisionModel(
        categoryId: row[0].toString(),
        categoryName: row[1].toString(),
        provisionId: row[2].toString(),
        title: row[3].toString(),
        description: row[4].toString(),
        impacts: row[5].toString(),
        longRangeEffectRaw: double.tryParse(row[6].toString()) ?? 0.0,
        year75EffectRaw: double.tryParse(row[7].toString()) ?? 0.0,
        longRangeShortfallPct: int.tryParse(row[8].toString()) ?? 0,
        year75ShortfallPct: int.tryParse(row[9].toString()) ?? 0,
        longRangeEffect: row.length > 10 ? row[10].toString() : '',
        year75Effect: row.length > 11 ? row[11].toString() : '',
        graphLink: row.length > 12 ? row[12].toString() : '',
        tableLink: row.length > 13 ? row[13].toString() : '',
      );
    } catch (e) {
      print('Error parsing row: $row');
      print('Error: $e');
      rethrow;
    }
  }

  // Convert to map for easier use in the app
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'provisionId': provisionId,
      'title': title,
      'description': description,
      'impacts': impacts,
      'longRangeEffectRaw': longRangeEffectRaw,
      'year75EffectRaw': year75EffectRaw,
      'longRangeShortfallPct': longRangeShortfallPct, 
      'year75ShortfallPct': year75ShortfallPct,
      'longRangeEffect': longRangeEffect,
      'year75Effect': year75Effect,
      'graphLink': graphLink,
      'tableLink': tableLink,
    };
  }
}

class ProvisionData {
  // Load CSV from assets
  static Future<List<ProvisionModel>> loadFromAssets(String path) async {
    final csvString = await rootBundle.loadString(path);
    return _processCSV(csvString);
  }

  // Load CSV from local file system (for testing on desktop)
  static Future<List<ProvisionModel>> loadFromFile(String path) async {
    if (kIsWeb) {
      throw Exception('Loading from file not supported on web');
    }
    final file = File(path);
    final csvString = await file.readAsString();
    return _processCSV(csvString);
  }

  // Process CSV string into list of models
  static List<ProvisionModel> _processCSV(String csvString) {
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
    
    // Skip header row
    List<ProvisionModel> provisions = [];
    
    for (var i = 1; i < csvTable.length; i++) {
      try {
        if (csvTable[i].length >= 10) { // Ensure minimum required fields
          provisions.add(ProvisionModel.fromRow(csvTable[i]));
        }
      } catch (e) {
        print('Error on row $i: $e');
      }
    }
    
    return provisions;
  }

  // Group provisions by category for easier UI organization
  static Map<String, List<ProvisionModel>> groupByCategory(List<ProvisionModel> provisions) {
    final Map<String, List<ProvisionModel>> groupedData = {};
    
    for (var provision in provisions) {
      if (!groupedData.containsKey(provision.categoryId)) {
        groupedData[provision.categoryId] = [];
      }
      groupedData[provision.categoryId]!.add(provision);
    }
    
    return groupedData;
  }
}
