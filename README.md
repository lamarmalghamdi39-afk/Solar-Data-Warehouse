# Solar-Data-Warehouse# ☀️ Solar Power Generation Analytics & Data Warehouse

## 📌 Project Overview
An end-to-end Data Engineering project that integrates heterogeneous solar power datasets (generation, weather sensors, and external meteorological data) into a centralized Data Warehouse. The goal is to provide actionable insights for operational planning and performance monitoring.

## 🛠️ Tech Stack
- **Language:** Python (Pandas, NumPy)
- **Environment:** Google Colab
- **Database:** MySQL
- **Architecture:** Star Schema (Fact & Dimension tables)

## ⚙️ ETL Pipeline Steps
1. **Extract:** Loaded 3 CSV datasets (Generation, Weather Sensor, External 2019).
2. **Transform:** Handled datetime formatting, created surrogate keys, removed duplicates, and built the dimension tables.
3. **Load:** Modeled a Star Schema and loaded it into MySQL.
   - `DIM_DATE`, `DIM_PLANT`, `DIM_SOURCE`
   - `FACT_POWER_GENERATION` (with Foreign Keys)

## 📊 Key Insights (OLAP Analysis)
- Peak power generation occurs during **midday hours**.
- Inverter performance varies, highlighting opportunities for targeted maintenance.
- Higher irradiation levels directly correlate with increased AC power generation.

## 📂 Repository Contents
- `solardw R.ipynb`: The Python ETL script.
- `SolarDW.sql`: Database schema creation and OLAP analytical queries.
- `Solar Panel Fault Detection.pdf`: Full project presentation and insights report.
