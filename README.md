# Social Security Calculator

A Flutter application designed to model and analyze solutions for the Social Security shortfall.

## Overview

The Social Security Solver app allows users to:

- Explore different policy provisions that could help solve the Social Security funding shortfall
- Drag and drop provisions to see their combined impact on the deficit
- Filter provisions by category (COLA, Benefit Level, Retirement Age, etc.)
- View detailed information about each provision, including its fiscal impact
- Track progress toward eliminating the projected deficit

## Features

- **Interactive Deficit Tracker**: Visual representation of the current deficit and progress toward solvency
- **Drag-and-Drop Interface**: Intuitive way to select and combine different policy provisions
- **Category Filtering**: Easy navigation through different types of reform options
- **Detailed Provision Cards**: Comprehensive information about each policy option
- **Impact Visualization**: Clear display of how each provision affects the long-term deficit

## Data Structure

The app uses a structured data model to represent Social Security reform provisions:

- **Data Source**: All provision data is stored in `lib/data/provisions_data.dart` as a Dart constant map
- **Organization**: Provisions are organized by categories (COLA, benefit level, retirement age, etc.)
- **Provision Model**: Each provision contains:
  - Unique identifier (e.g., 'A1', 'B1.1')
  - Title and detailed description
  - Impact metrics (long-range effect, 75th year effect, etc.)
  - Links to related resources

### Example Provision Data Structure

```dart
{
  'id': 'A1',
  'title': 'Starting December 2025, reduce the annual COLA by 1 percentage point',
  'description': 'Reduce the annual COLA by 1 percentage point from what would otherwise be paid under current law.',
  'impacts': [
    'Long-term reduction in benefits',
    'Affects all current and future beneficiaries',
    'Long-range effect: 1.95% of payroll',
    '75th year effect: 2.54% of payroll'
  ],
  'relatedLinks': { ... }
}
```

## Project Structure

- `lib/` - Main application code
  - `data/` - Static data files including provisions_data.dart
  - `models/` - Business logic and data models
    - `provision.dart` - Model class for Social Security provisions
  - `providers/` - State management
    - `provisions_provider.dart` - Manages provision selection and deficit calculation
  - `screens/` - UI screens
    - `provisions_screen.dart` - Main screen with deficit tracker and provisions list
  - `services/` - Backend services
    - `provisions_service.dart` - Loads and processes provision data
  - `widgets/` - Reusable UI components
    - `deficit_tracker.dart` - Visualizes current deficit and progress
    - `provision_card.dart` - Displays individual provision details
    - `category_filter.dart` - Filters provisions by category
- `assets/` - Static resources
  - `images/` - Image assets
- `test/` - Unit and widget tests
- `zimport_data/` - Additional data files for importing

## Implementation Details

- **State Management**: Uses the Provider pattern for state management
- **Data Flow**: Provisions are loaded from static data, processed by services, and managed by providers
- **UI Components**: Custom widgets for visualizing deficit and displaying provisions
- **Deficit Calculation**: Each provision contributes to reducing the projected deficit based on its impact metrics

## Getting Started

1. Ensure Flutter is installed on your machine
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Data Sources

Provision data is based on analysis from the Social Security Administration's Office of the Chief Actuary, which provides estimates of how various policy changes would affect the program's long-term financial outlook.

## Visualization

The app includes several data visualization features:

- **Stacked Bar Chart**: Shows how each provision contributes to deficit reduction in a space-efficient layout
- **Color-Coded Segments**: Each provision category has a unique color for easy identification
- **Interactive Legend**: Scrollable legend showing all selected provisions
- **Responsive Design**: Visualizations adapt to both desktop and mobile screen sizes

## Responsive Design

The Social Security Solver is fully responsive and optimized for various screen sizes:

- **Mobile Layout**: Vertical arrangement with compact UI elements
- **Desktop Layout**: Horizontal arrangement with expanded visualization
- **Touch-Friendly**: All interactive elements are properly sized for touch input
- **Adaptive Typography**: Text scales appropriately across devices

## License and Copyright

© 2025 Rico Vision LLC. All rights reserved.

This software and its content are protected by copyright law. Unauthorized reproduction or distribution of this software, or any portion of it, may result in severe civil and criminal penalties, and will be prosecuted to the maximum extent possible under law.
