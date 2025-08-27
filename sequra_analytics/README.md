# Sequra Analytics Engineering Challenge - dbt Project

## Overview

This dbt project implements the analytics engineering challenge for Sequra, focusing on calculating customer loyalty metrics and default risk analysis. The project demonstrates modern data engineering best practices using dbt (data build tool) with Snowflake as the data warehouse.

## Business Objectives

### 1. Shopper Recurrence Rate
Calculate the percentage of customers who have made repeat purchases with merchants, providing insights into:
- Customer loyalty patterns
- Merchant performance in retaining customers
- Effectiveness of customer engagement strategies

### 2. Default Ratio Analysis
Monitor the evolution of payment defaults over time to:
- Assess financial risk exposure
- Track debt recovery performance
- Support data-driven credit risk decisions

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Sources   │────▶│   Staging   │────▶│Intermediate │────▶│    Marts    │
│    (CSV)    │     │   (Clean)   │     │  (Logic)    │     │  (Reports)  │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

### Data Flow
1. **Seeds**: Raw CSV data loaded into Snowflake
2. **Staging**: Data cleaning and standardization
3. **Intermediate**: Business logic and calculations
4. **Marts**: Final analytical tables for reporting

## Project Structure

```
sequra_analytics/
├── README.md                           # This file
├── dbt_project.yml                     # Project configuration
├── profiles.yml                        # Connection configuration
├── models/
│   ├── staging/                        # Data cleaning layer
│   │   ├── schema.yml                # Documentation & tests
│   │   ├── stg_orders.sql             # Orders staging
│   │   └── stg_merchants.sql          # Merchants staging
│   ├── intermediate/                   # Business logic layer
│   │   ├── schema.yml          # Documentation
│   │   ├── int_monthly_shoppers.sql   # Monthly aggregations
│   │   ├── int_recurrent_shoppers.sql # Recurrence logic
│   │   └── int_orders_with_defaults.sql # Default analysis prep
│   └── marts/                          # Final reporting layer
│       ├── schema.yml                 # Documentation & tests
│       ├── shopper_recurrence_rate.sql # Main output table
│       └── default_ratio_analysis.sql  # Risk analysis table
├── seeds/
│   ├── orders_merchant.csv            # Source order data
│   └── merchants.csv                  # Merchant reference data
├── tests/
│   └── generic/
│       └── test_recurrence_rate_bounds.sql # Custom tests
└── macros/
    ├── get_month_year.sql             # Date formatting
    └── calculate_delayed_period.sql   # Risk period calculation
```

## Quick Start

### Prerequisites
- Python 3.7+
- dbt-core and dbt-snowflake
- Access to Snowflake account
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/vermeil11/SeQura-Test-Analytics-Engineer.git
cd sequra_analytics
```

2. **Install dbt**
```bash
pip install dbt-core dbt-snowflake
```

3. **Configure Snowflake connection**
Link to the Snowflake database: https://lqgtqud-rv87386.snowflakecomputing.com
Update `profiles.yml` with your credentials:
```yaml
sequra_analytics:
  outputs:
    dev:
      type: snowflake
      account: your-account
      user: your-username
      password: your-password
      role: your-role
      database: SEQURA_DEV
      warehouse: COMPUTE_WH
      schema: dbt_dev
```

4. **Test connection**
```bash
dbt debug
```

5. **Load seed data**
```bash
dbt seed
```

6. **Run all models**
```bash
dbt run
```

7. **Run tests**
```bash
dbt test
```

8. **Generate documentation**
```bash
dbt docs generate
dbt docs serve
```

## Development

### Running Specific Models

```bash
# Run staging models only
dbt run --select staging.*

# Run with upstream dependencies
dbt run --select +shopper_recurrence_rate

# Run with downstream dependencies
dbt run --select stg_orders+

# Run by tag
dbt run --select tag:daily
```

### Testing Strategies

```bash
# Run all tests
dbt test

# Test specific model
dbt test --select shopper_recurrence_rate

# Run schema tests only
dbt test --select test_type:schema

# Run data tests only
dbt test --select test_type:data
```

## Performance Optimization

### Materialization Strategy
- **Views**: Staging and intermediate models (low storage, always fresh)
- **Tables**: Mart models (optimized for BI tools)
- **Incremental**: Can be implemented for large datasets

### Best Practices Implemented
- Modular SQL with CTEs
- Clear naming conventions
- Comprehensive testing
- Documentation for all models
- Version control friendly
- DRY principle with macros
- Idempotent transformations

## Data Quality

### Automated Tests
- **Uniqueness**: Order IDs, merchant IDs
- **Not Null**: Required fields
- **Referential Integrity**: Foreign key relationships
- **Business Logic**: Recurrence rate bounds (0-100%)

## Assumptions & Decisions

### Data Assumptions
1. **Date Format**: Dates in source are D/M/YY or DD/MM/YY format
2. **Recurrence Definition**: Customer must purchase in at least 2 different months within 12-month window
3. **Null Handling**: Null dates are excluded from analysis
4. **Merchant Names**: Provided via seed file (would typically come from source system)

### Technical Decisions
1. **Snowflake Specific**: Uses Snowflake SQL syntax (can be adapted for other warehouses)
2. **Incremental Logic**: Not implemented in v1 but structure supports it
3. **Partitioning**: Not implemented but recommended for production
4. **Error Handling**: Relies on dbt's built-in error handling
# Trigger CI
# Trigger CI
