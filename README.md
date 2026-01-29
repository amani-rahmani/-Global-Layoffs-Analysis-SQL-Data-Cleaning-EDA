# Global-Layoffs-Analysis-SQL-Data-Cleaning-EDA
This project focuses on cleaning and analyzing a global layoffs dataset using MySQL. The goal was to transform raw, inconsistent data into a reliable dataset and perform exploratory data analysis (EDA) to uncover trends in layoffs across companies, industries, countries, and time.

## Data Cleaning Steps

The following data cleaning tasks were performed using SQL:

* Removed duplicate records using ROW_NUMBER() and window functions

* Standardized text fields (company names, industries, countries)

* Converted date fields to proper DATE format

* Handled missing and null values

* Filled missing industry values using self-joins

* Removed records with insufficient layoff information

* Dropped unnecessary helper columns after cleaning

## Exploratory Data Analysis (EDA)

Key analysis questions explored include:

* Largest single-day layoff events

* Companies that laid off 100% of employees

* Industries and countries with the highest total layoffs

* Layoffs trends over time (yearly and monthly)

* Rolling totals of layoffs by month

* Layoffs by company, country, and year
## Some Key Insights
 * The United States experienced the highest number of layoffs overall

* Consumer and Retail industries were the most impacted

* Major tech companies accounted for the largest single layoff events

## 📊 Tableau Dashboard

The interactive Tableau dashboard was created to visualize key findings from the SQL analysis, including layoff trends over time, top affected industries, and country-level impacts.

🔗 **View the interactive dashboard on Tableau Public:**  
[Click here to view the dashboard]([(https://public.tableau.com/app/profile/amani.rahmani/viz/GlobalLayOffProject/Dashboard1)])
