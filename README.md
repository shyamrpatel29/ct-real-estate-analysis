# Connecticut Real Estate Market Analysis (2001–2021)

An exploratory analysis of ~500K real estate transactions across all 169 Connecticut towns. The project uses PostgreSQL for data aggregation, Python for data reshaping, and a Jupyter notebook for visualization and final analysis. Tableau workbooks are included for interactive exploration.

## What This Project Does

The dataset covers every recorded real estate sale in Connecticut from 2001 to 2021. The analysis focuses on a few core questions:

1. **Which towns have the most transaction activity?** — Raw volume rankings over the past 5 years
2. **Which markets are growing fastest?** — 5-year growth rate relative to all-time history
3. **Where do properties sell quickest?** — Average days on market across high-volume towns
4. **How did COVID affect the market?** — Year-over-year transaction swings from 2018–2022
5. **What do sale prices look like?** — Distributions by town and property type

## Key Findings

| Finding | Detail |
|---------|--------|
| Fastest-growing market | Greenwich — 47.6% of all-time transactions in last 5 years |
| COVID impact | Nearly every town dipped in 2020, then spiked in 2021 |
| Biggest YoY swing | Bridgeport: +943 transactions in 2022 |
| Fastest-selling market | Bridgeport: ~437 avg days on market |
| 2022 trend | Broad cooldown across most markets (rising rates) |

## Repository Structure

```
ct-real-estate-analysis/
├── sql/
│   ├── 01_transaction_volume.sql    # Transaction counts and 5-year trends
│   ├── 02_growth_rate.sql           # Market growth rate calculation
│   ├── 03_days_on_market.sql        # Average days on market per town
│   └── 04_sale_price.sql            # Sale price queries with data cleaning
├── scripts/
│   ├── change_formatter.py          # Reshapes YoY change data for Tableau
│   └── total_formatter.py           # Reshapes transaction totals for Tableau
├── data/
│   └── processed/                   # SQL query outputs (CSVs)
├── notebooks/
│   └── ct_real_estate_analysis.ipynb # Main analysis notebook w/ visualizations
├── tableau/
│   ├── ct_analysis.twb              # Market analysis dashboard
│   ├── Avg_Days_on_Market.twb       # Days on market visualization
│   └── Book1.twb                    # Exploratory workbook
├── images/                          # Generated charts (from notebook)
├── requirements.txt
└── README.md
```

## Data

The raw dataset (`Real_Estate_Sales_2001-2021_GL.csv`, ~100MB) is from the [Connecticut Open Data Portal](https://data.ct.gov/Housing-and-Development/Real-Estate-Sales-2001-2020-GL/5mzw-sjtu). It contains 500K+ rows with fields like town, sale amount, property type, list year, date recorded, and sales ratio.

The dataset is not included in this repo due to size. Download it from the link above and place it in the project root if you want to rerun the SQL queries.

The `data/processed/` folder contains the pre-computed CSV outputs from the SQL queries, so the notebook runs without needing the database.

## How to Run

### Analysis Notebook (no database needed)

```bash
git clone https://github.com/YOUR_USERNAME/ct-real-estate-analysis.git
cd ct-real-estate-analysis
pip install -r requirements.txt
jupyter notebook notebooks/ct_real_estate_analysis.ipynb
```

### SQL Queries (requires PostgreSQL)

1. Download the dataset from the CT Open Data Portal
2. Load it into a PostgreSQL table called `public.ct_real_estate_2001_2021`
3. Run the SQL files in the `sql/` folder in order

### Tableau

Open the `.twb` files in `tableau/` with Tableau Desktop or Tableau Public.

## Tech Stack

- **PostgreSQL** — data storage and aggregation (CTEs, window functions, LAG)
- **Python** — data reshaping (pandas)
- **Jupyter** — analysis notebook with matplotlib visualizations
- **Tableau** — interactive dashboards
