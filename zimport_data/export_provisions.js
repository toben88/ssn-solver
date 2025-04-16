// One-time script to export provisions data to CSV
const fs = require('fs');
const path = require('path');

// Helper function to extract string literals from array syntax
function extractStringLiterals(text) {
  const results = [];
  const regex = /'([^']+)'/g;
  let match;
  
  while ((match = regex.exec(text)) !== null) {
    results.push(match[1]);
  }
  
  return results;
}

// Read the provisions data file
const filePath = path.join(__dirname, '..', 'lib', 'data', 'provisions_data.dart');
const fileContent = fs.readFileSync(filePath, 'utf8');

// Manual extraction of data from provisions_data.dart
// This approach doesn't rely on JSON parsing which is error-prone with Dart syntax

// Extract categories
const categoryRegex = /'id':\s*'([^']+)',\s*'name':\s*'([^']+)'/g;
let categoryMatch;
const categories = {};

while ((categoryMatch = categoryRegex.exec(fileContent)) !== null) {
  const categoryId = categoryMatch[1];
  const categoryName = categoryMatch[2];
  categories[categoryId] = categoryName;
}

// Extract provisions with all their details
const provisions = [];

// Use regex to find each provision block
const provisionBlockRegex = /'id':\s*'([^']+)',[\s\S]*?'title':\s*'([^']*)',[\s\S]*?'description':\s*'([^']*)',[\s\S]*?'impacts':\s*\[([\s\S]*?)\],[\s\S]*?'relatedLinks':\s*\{([\s\S]*?)\}/g;
let provisionMatch;

while ((provisionMatch = provisionBlockRegex.exec(fileContent)) !== null) {
  const provisionId = provisionMatch[1];
  const title = provisionMatch[2];
  const description = provisionMatch[3];
  const impactsBlock = provisionMatch[4];
  const linksBlock = provisionMatch[5];
  
  // Find which category this provision belongs to
  let categoryId = '';
  let categoryName = '';
  
  for (const id in categories) {
    const pattern = new RegExp(`'id':\s*'${id}'[\\s\\S]*?'provisions':\s*\\[[\\s\\S]*?'id':\s*'${provisionId}'`);
    if (pattern.test(fileContent)) {
      categoryId = id;
      categoryName = categories[id];
      break;
    }
  }
  
  // Extract impacts as an array of strings
  const impacts = extractStringLiterals(impactsBlock);
  
  // Extract specific actuarial metrics from impacts
  let longRangeEffect = '';
  let year75Effect = '';
  let longRangeShortfallEliminated = '';
  let year75ShortfallEliminated = '';
  
  // Parse out specific actuarial values from impacts
  impacts.forEach(impact => {
    if (impact.includes('Long-range effect:')) {
      longRangeEffect = impact.replace('Long-range effect:', '').trim();
    } else if (impact.includes('75th year effect:')) {
      year75Effect = impact.replace('75th year effect:', '').trim();
    } else if (impact.includes('Long-range shortfall eliminated:')) {
      longRangeShortfallEliminated = impact.replace('Long-range shortfall eliminated:', '').trim();
    } else if (impact.includes('75th year shortfall eliminated:')) {
      year75ShortfallEliminated = impact.replace('75th year shortfall eliminated:', '').trim();
    }
  });
  
  // Extract links directly from the links block
  const graphLinkMatch = linksBlock.match(/'graph':\s*'([^']*)'/);
  const tableLinkMatch = linksBlock.match(/'table':\s*'([^']*)'/);
  
  const graphLink = graphLinkMatch ? graphLinkMatch[1] : '';
  const tableLink = tableLinkMatch ? tableLinkMatch[1] : '';
  
  provisions.push({
    categoryId,
    categoryName,
    provisionId,
    title,
    description,
    impacts,
    longRangeEffect,
    year75Effect,
    longRangeShortfallEliminated,
    year75ShortfallEliminated,
    graphLink,
    tableLink
  });
}

// Create CSV header
let csvContent = 'Category,CategoryName,ProvisionID,Title,Description,Impact1,Impact2,Impact3,Impact4,Impact5,Impact6,LongRangeEffect,Year75Effect,LongRangeShortfallEliminated,Year75ShortfallEliminated,GraphLink,TableLink\n';

// Process each provision
provisions.forEach(provision => {
  const row = [
    provision.categoryId,
    provision.categoryName,
    provision.provisionId,
    provision.title,
    provision.description || '',
  ];
  
  // Add impacts (up to 6)
  const impacts = provision.impacts || [];
  for (let i = 0; i < 6; i++) {
    row.push(impacts[i] || '');
  }
  
  // Add actuarial balance data
  row.push(provision.longRangeEffect || '');
  row.push(provision.year75Effect || '');
  row.push(provision.longRangeShortfallEliminated || '');
  row.push(provision.year75ShortfallEliminated || '');
  
  // Add related links
  row.push(provision.graphLink || '');
  row.push(provision.tableLink || '');
  
  // Add row to CSV
  csvContent += row.map(field => {
    // Escape quotes and wrap in quotes if needed
    if (typeof field === 'string' && (field.includes(',') || field.includes('"'))) {
      return `"${field.replace(/"/g, '""')}"`;
    }
    return field;
  }).join(',') + '\n';
});

// Write to file
const outputPath = path.join(__dirname, 'export.csv');
fs.writeFileSync(outputPath, csvContent);

console.log(`Exported provisions data to ${outputPath}`);
