# 🏥 Hospital Admissions Analysis (SQL + Excel)

## 📌 Project Overview

This project analyzes a healthcare dataset using **SQL for data cleaning and analysis** and **Excel for interactive dashboard visualization**.

The goal of the project is to demonstrate practical data analysis skills including **data cleaning, aggregation, pivot tables, and dashboard creation**.

The dataset contains hospital patient admission records including:

- Patient demographics
- Medical conditions
- Admission type
- Insurance provider
- Billing amounts
- Length of hospital stay
- Admission dates

Using SQL and Excel, the data was cleaned, analyzed, and transformed into an interactive dashboard that provides insights into hospital admissions and revenue trends.

---
## Dataset
- Source : [Kaggle - Sample Healthcare Dataset](https://www.kaggle.com/datasets/prasad22/healthcare-dataset)


## 🛠 Tools Used

- **MySQL** – Data cleaning and aggregation
- **Microsoft Excel** – Pivot tables, charts, and dashboard creation
- **GitHub** – Project documentation and version control

---

## Key Analysis Questions❓️❓️

The analysis focuses on answering the following questions:

- What are the **monthly hospital admission trends**?
- Which **insurance providers generate the most revenue**?
- What are the **most common medical conditions**?
- What is the **average hospital stay by admission type**?
- What is the **gender distribution of patients**?

---

## SQL Data Cleaning Steps

The dataset was cleaned using SQL before analysis.

Cleaning tasks included:

- Standardizing doctor names and titles
- Removing extra spaces using `TRIM`
- Fixing inconsistent text formatting
- Handling date formatting
- Creating derived fields for analysis
- Generating aggregated tables for Excel dashboards

---

## Excel Dashboard

An interactive Excel dashboard was built using:

- Pivot Tables
- Pivot Charts
- KPI Cards
- Slicers for filtering
  
  ## Dashboard Metrics
  
- Total Patients
- Total Revenue
- Average Stay Length

 ## 📊📉 Visualizations

- Monthly Admissions Trend
- Revenue by Insurance Provider
- Top Medical Conditions
- Gender Breakdown
- Average Stay by Admission Type

Slicers allow users to filter the dashboard by:

- Gender
- Insurance Provider
- Admission Type
- Medical Condition
- Dashboard Preview

## Dashboard Preview
![Healthcare Dashboard](dashboard.png)

## Key Skills Demonstrated

- SQL data cleaning
- SQL aggregation and grouping
- Data analysis
- Excel pivot tables
- Excel dashboards
- Data visualization
- Analytical thinking

  ## 🚀 Future Improvements

- Possible improvements for this project include:
- Building the dashboard in Power BI
- Adding advanced SQL window functions
- Automating data updates using Power Query

  ## 📁 Repository Structure
  
Hospital Admissions Analysis (SQL + Excel)
│
├── data
│   ├── healthcare_raw.csv
│   └── healthcare_cleaned.csv
│
├── sql
│   └── data_cleaning_and_analysis.sql
│
├── excel
│   └── healthcare_dashboard.xlsx
│
├── images
│   └── dashboard.png
│
└── README.md
