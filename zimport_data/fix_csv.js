// Improved script to normalize the CSV data
const fs = require('fs');
const path = require('path');

// Read the CSV file
const inputFile = path.join(__dirname, 'unifiedimport.csv');
const outputFile = path.join(__dirname, 'normalized_import.csv');

let csvData = fs.readFileSync(inputFile, 'utf8').split('\n');
let header = csvData[0];
let normalizedRows = [header];

// Category name mapping
const categoryNames = {
  'cola': 'Cost-of-Living Adjustment',
  'benefit_level': 'Level of Monthly Benefits (PIA)',
  'retirement_age': 'Retirement Age',
  'family_benefits': 'Benefits for Family Members',
  'payroll_tax': 'Payroll Tax',
  'coverage': 'Coverage of Employment',
  'investments': 'Investment in Marketable Securities',
  'taxation': 'Taxation of Benefits'
};

// Copy first 68 rows as-is
for (let i = 1; i <= 68; i++) {
  if (i < csvData.length) {
    normalizedRows.push(csvData[i]);
  }
}

// Re-process each row after 68
for (let i = 69; i < csvData.length; i++) {
  let row = csvData[i];
  if (!row.trim()) continue; // Skip empty rows
  
  // Split into columns, handling commas in quoted fields
  let columns = parseCSVRow(row);
  
  // Fix any encoding issues
  columns = columns.map(col => col.replace(/\s+/g, ' ').trim());
  
  // Get category ID and set category name
  const categoryId = columns[0].trim();
  if (categoryId && categoryNames[categoryId]) {
    columns[1] = categoryNames[categoryId];
  }
  
  // Format the long range and 75th year effects
  if (columns[6] && columns[7]) {
    // Add formatted text if missing
    if (!columns[10]) {
      columns[10] = `Long-range effect: ${columns[6]}% of payroll`;
    }
    if (!columns[11]) {
      columns[11] = `75th year effect: ${columns[7]}% of payroll`;
    }
    
    // Add impacts if missing
    if (!columns[5]) {
      let impact = generateImpactDescription(categoryId, parseFloat(columns[6]), parseFloat(columns[7]));
      columns[5] = impact;
    }
  }
  
  // Generate placeholder URLs for graphs and tables if missing
  if (!columns[12] && columns[2]) {
    const provisionId = columns[2].trim();
    let runNumber = generateRunNumber(provisionId);
    columns[12] = `https://www.ssa.gov/oact/solvency/provisions/charts/chart_run${runNumber}.html`;
    columns[13] = `https://www.ssa.gov/oact/solvency/provisions/tables/table_run${runNumber}.html`;
  }
  
  // Join columns back together
  let normalizedRow = columns.map(c => {
    // Quote fields with commas
    return c.includes(',') ? `"${c}"` : c;
  }).join(',');
  
  normalizedRows.push(normalizedRow);
}

// Write the normalized data to a new file
fs.writeFileSync(outputFile, normalizedRows.join('\n'), 'utf8');
console.log('Normalized CSV file created: ' + outputFile);

// Helper function to parse a CSV row while preserving quotes
function parseCSVRow(row) {
  const columns = [];
  let inQuotes = false;
  let currentValue = '';
  
  for (let i = 0; i < row.length; i++) {
    const char = row[i];
    
    if (char === '"') {
      inQuotes = !inQuotes;
      currentValue += char;
    } else if (char === ',' && !inQuotes) {
      columns.push(currentValue);
      currentValue = '';
    } else {
      currentValue += char;
    }
  }
  
  columns.push(currentValue); // Add the last column
  
  // Clean up the quotes
  let cleanColumns = columns.map(col => {
    if (col.startsWith('"') && col.endsWith('"')) {
      return col.substring(1, col.length - 1);
    }
    return col;
  });
  
  // Make sure we have all columns (adding empty strings if needed)
  while (cleanColumns.length < 20) {
    cleanColumns.push('');
  }
  
  return cleanColumns;
}

// Generate impact description based on category and values
function generateImpactDescription(category, longRange, year75) {
  let impact = '';
  
  if (category === 'cola') {
    if (longRange > 0) {
      impact = `Reduces benefits over time; Affects all beneficiaries; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
    } else {
      impact = `Increases benefits over time; Protects against inflation; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
    }
  } else if (category === 'benefit_level') {
    if (longRange > 0) {
      impact = `Reduces future benefit levels; Progressive approach to solvency; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
    } else {
      impact = `Increases benefits for targeted groups; Addresses adequacy concerns; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
    }
  } else if (category === 'retirement_age') {
    impact = `Adjusts retirement age based on longevity; Affects future retirees; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
  } else if (category === 'family_benefits') {
    if (longRange > 0) {
      impact = `Adjusts auxiliary benefits; Targets specific family situations; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
    } else {
      impact = `Enhances benefits for family members; Addresses specific needs; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
    }
  } else if (category === 'payroll_tax') {
    impact = `Increases revenue through payroll tax changes; Broadens funding base; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
  } else if (category === 'coverage') {
    impact = `Expands coverage to additional workers; Increases system revenue; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
  } else if (category === 'investments') {
    impact = `Modifies trust fund investment strategy; Seeks higher returns; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
  } else if (category === 'taxation') {
    impact = `Adjusts taxation of benefits; Increases revenue progressively; Long-range effect: ${longRange}% of payroll; 75th year effect: ${year75}% of payroll`;
  }
  
  return impact;
}

// Generate a run number for URLs based on provision ID
function generateRunNumber(provisionId) {
  // Extract the category letter and number
  const matches = provisionId.match(/([A-Z])(\d+)/);
  if (!matches) return '000';
  
  const letter = matches[1];
  const number = parseInt(matches[2]);
  
  // Generate a base number based on category
  let baseNum = 0;
  switch(letter) {
    case 'A': baseNum = 94; break;
    case 'B': baseNum = 103; break;
    case 'C': baseNum = 120; break;
    case 'D': baseNum = 130; break;
    case 'E': baseNum = 150; break;
    case 'F': baseNum = 165; break;
    case 'G': baseNum = 175; break;
    case 'H': baseNum = 185; break;
    default: baseNum = 200;
  }
  
  // Add the provision number
  const runNum = baseNum + number;
  return runNum.toString().padStart(3, '0');
}
