const Map<String, dynamic> provisionsData = {
  'categories': [
    {
      'id': 'cola',
      'name': 'Cost-of-Living Adjustment',
      'provisions': [
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
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run094.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run094.html'
          }
        },
        {
          'id': 'A2',
          'title': 'Starting December 2025, reduce the annual COLA by 0.5 percentage point',
          'description': 'Reduce the annual COLA by 0.5 percentage point from what would otherwise be paid under current law.',
          'impacts': [
            'Moderate reduction in benefits',
            'Affects all current and future beneficiaries',
            'Long-range effect: 1.01% of payroll',
            '75th year effect: 1.33% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run095.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run095.html'
          }
        },
        {
          'id': 'A3',
          'title': 'Starting December 2025, compute the COLA using a chained CPI-W',
          'description': 'Starting December 2025, compute the COLA using a chained CPI-W, estimated to reduce COLA by -0.3 percentage points.',
          'impacts': [
            'Moderate reduction in benefits',
            'Affects all beneficiaries',
            'Long-range effect: 0.62% of payroll',
            '75th year effect: 0.82% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run096.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run096.html'
          }
        },
        {
          'id': 'A4',
          'title': 'Starting December 2027, compute the COLA using a chained CPI-W (not applicable to DI benefits)',
          'description': 'Starting December 2027, compute the COLA using a chained CPI-W (not applicable to DI benefits).',
          'impacts': [
            'Targeted reduction in benefits',
            'Does not affect disability benefits',
            'Long-range effect: 0.49% of payroll',
            '75th year effect: 0.66% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run097.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run097.html'
          }
        },
        {
          'id': 'A5',
          'title': 'Starting December 2025, add 1 percentage point to COLA for beneficiaries living past a specified age',
          'description': 'Starting December 2025, add 1 percentage point to COLA for beneficiaries living past a specified age.',
          'impacts': [
            'Increases benefits for the oldest beneficiaries',
            'Targets support to those with longest lifespans',
            'Long-range effect: -0.14% of payroll',
            '75th year effect: -0.14% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run098.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run098.html'
          }
        },
        {
          'id': 'A6',
          'title': 'Starting December 2026, compute COLA using CPI-E, estimated to increase COLA by -0.2 percentage point',
          'description': 'Starting December 2026, compute COLA using CPI-E, estimated to increase COLA by -0.2 percentage point.',
          'impacts': [
            'Better reflects spending patterns of seniors',
            'Typically results in higher COLAs',
            'Long-range effect: -0.42% of payroll',
            '75th year effect: -0.57% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run099.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run099.html'
          }
        },
        {
          'id': 'A7',
          'title': 'Starting December 2025, reduce COLA by 1 point, not below zero; no carryover of unused reduction',
          'description': 'Starting December 2025, reduce COLA by 1 point, not below zero; no carryover of unused reduction.',
          'impacts': [
            'Limits benefit reductions in low-inflation years',
            'Still provides substantial long-term savings',
            'Long-range effect: 1.83% of payroll',
            '75th year effect: 2.39% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run100.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run100.html'
          }
        },
        {
          'id': 'A8',
          'title': 'COLA based on chain-weighted CPI-U for OASI only, starting December 2025',
          'description': 'COLA based on chain-weighted CPI-U for OASI only, starting December 2025.',
          'impacts': [
            'Targets retirement benefits only',
            'Preserves disability benefits',
            'Long-range effect: 0.55% of payroll',
            '75th year effect: 0.71% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run101.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run101.html'
          }
        },
        {
          'id': 'A9',
          'title': 'For MAGI above a certain threshold, use chain-weighted CPI for COLA above threshold, starting December 2025',
          'description': 'For MAGI above a certain threshold, use chain-weighted CPI for COLA above threshold, starting December 2025.',
          'impacts': [
            'Progressive approach targeting higher-income beneficiaries',
            'Protects lower-income recipients',
            'Long-range effect: 1.3% of payroll',
            '75th year effect: 2.27% of payroll'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run102.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run102.html'
          }
        }
      ]
    },
    {
      'id': 'benefit_level',
      'name': 'Level of Monthly Benefits (PIA)',
      'provisions': [
        {
          'id': 'B1.1',
          'title': 'Progressive price indexing (40th percentile) of PIA factors',
          'description': 'Progressive price indexing (40th percentile) of PIA factors beginning with individuals newly eligible for OASDI in 2031.',
          'impacts': [
            'Progressive reduction in benefits',
            'Affects future beneficiaries only',
            'Long-range effect: 2.96% of payroll',
            '75th year effect: 7.79% of payroll',
            'Long-range shortfall eliminated: 85%',
            '75th year shortfall eliminated: 168%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run103.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run103.html'
          }
        },
        {
          'id': 'B2.1',
          'title': 'PIA formula factors decrease due to increased longevity',
          'description': 'PIA formula factors decrease due to increased longevity for those newly eligible in 2034.',
          'impacts': [
            'Adjusts benefits based on demographic changes',
            'Affects only future beneficiaries',
            'Long-range effect: 0.56% of payroll',
            '75th year effect: 1.72% of payroll',
            'Long-range shortfall eliminated: 16%',
            '75th year shortfall eliminated: 37%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run110.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run110.html'
          }
        }
      ]
    },
    {
      'id': 'retirement_age',
      'name': 'Retirement Age',
      'provisions': [
        {
          'id': 'C1.4',
          'title': 'Increase NRA 3 months/year from 2025 to 2032, up to age 69',
          'description': 'Increase NRA 3 months/year from 2025 to 2032, up to age 69.',
          'impacts': [
            'Reduces benefits for future retirees',
            'Longer working careers',
            'Long-range effect: 1.32% of payroll',
            '75th year effect: 2.56% of payroll',
            'Long-range shortfall eliminated: 38%',
            '75th year shortfall eliminated: 55%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run147.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run147.html'
          }
        }
      ]
    },
    {
      'id': 'payroll_tax',
      'name': 'Payroll Tax',
      'provisions': [
        {
          'id': 'E1.1',
          'title': 'Increase payroll tax rate to 16.0 percent in 2025 and later',
          'description': 'Increase payroll tax rate to 16.0 percent in 2025 and later.',
          'impacts': [
            'Increased revenue',
            'Higher tax burden on workers and employers',
            'Long-range effect: 3.51% of payroll',
            '75th year effect: 3.62% of payroll',
            'Long-range shortfall eliminated: 100%',
            '75th year shortfall eliminated: 78%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run184.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run184.html'
          }
        },
        {
          'id': 'E2',
          'title': 'Eliminate the taxable maximum',
          'description': 'Eliminate the taxable maximum (currently \$168,600 in 2024) and apply the payroll tax rate to all earnings.',
          'impacts': [
            'Increased revenue from high earners',
            'Affects approximately 6% of covered workers'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run185.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run185.html'
          }
        }
      ]
    },
    {
      'id': 'family_benefits',
      'name': 'Benefits for Family Members',
      'provisions': [
        {
          'id': 'D4',
          'title': 'Alternative survivor benefit equal to 75% of combined benefits',
          'description': 'Alternative survivor benefit equal to 75% of combined survivor and deceased benefits, capped at average wage-indexed PIA.',
          'impacts': [
            'Improves benefits for many survivors',
            'Targets support to vulnerable populations',
            'Long-range effect: -0.1% of payroll',
            '75th year effect: -0.11% of payroll',
            'Long-range shortfall eliminated: -3%',
            '75th year shortfall eliminated: -2%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run130.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run130.html'
          }
        }
      ]
    },
    {
      'id': 'coverage',
      'name': 'Coverage of Employment',
      'provisions': [
        {
          'id': 'F1.1',
          'title': 'Extend OASDI coverage to newly hired State and local government employees',
          'description': 'Extend OASDI coverage to newly hired State and local government employees beginning in 2026.',
          'impacts': [
            'Broadens the contribution base',
            'Provides consistent coverage across public sector',
            'Long-range effect: 0.22% of payroll',
            '75th year effect: 0.28% of payroll',
            'Long-range shortfall eliminated: 6%',
            '75th year shortfall eliminated: 6%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run165.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run165.html'
          }
        }
      ]
    },
    {
      'id': 'investments',
      'name': 'Investment in Marketable Securities',
      'provisions': [
        {
          'id': 'G1.1',
          'title': 'Invest 40% of Trust Fund assets in equities',
          'description': 'Invest 40% of OASDI Trust Fund assets in equities starting in 2026, phased in over 15 years.',
          'impacts': [
            'Potentially higher returns on Trust Fund assets',
            'Introduces market risk to Trust Fund',
            'Long-range effect: 0.33% of payroll',
            '75th year effect: 0.33% of payroll',
            'Long-range shortfall eliminated: 9%',
            '75th year shortfall eliminated: 7%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run175.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run175.html'
          }
        }
      ]
    },
    {
      'id': 'taxation',
      'name': 'Taxation of Benefits',
      'provisions': [
        {
          'id': 'H1.1',
          'title': 'Tax up to 100% of Social Security benefits above certain income thresholds',
          'description': 'Tax up to 100% of Social Security benefits above certain income thresholds starting in 2025.',
          'impacts': [
            'Increases revenue from higher-income beneficiaries',
            'Progressive approach to funding',
            'Long-range effect: 0.52% of payroll',
            '75th year effect: 0.59% of payroll',
            'Long-range shortfall eliminated: 15%',
            '75th year shortfall eliminated: 13%'
          ],
          'relatedLinks': {
            'graph': 'https://www.ssa.gov/oact/solvency/provisions/charts/chart_run194.html',
            'table': 'https://www.ssa.gov/oact/solvency/provisions/tables/table_run194.html'
          }
        }
      ]
    }
  ]
};
