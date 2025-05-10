# 🧹 SQL Data Cleaning & EDA on Layoffs Dataset

This project involves **data cleaning** and **exploratory data analysis (EDA)** on a real-world dataset containing information about company layoffs globally. The dataset includes details such as company names, industry, location, date of layoffs, and the number and percentage of employees laid off.

## 📁 Dataset Information

* **Source:** world_layoffs.layoffs.csv
* **Fields:**

  * `company`
  * `location`
  * `industry`
  * `total_laid_off`
  * `percentage_laid_off`
  * `date`
  * `stage`
  * `country`
  * `funds_raised_millions`

## 🧼 Steps Performed

### 1. Data Loading

* Loaded the CSV data into a MySQL database (`world_layoffs`).

### 2. Backup Original Data

* Created `layoffs_staging` and `layoffs_staging2` to preserve and manipulate data safely.

### 3. Data Cleaning

* ✅ Removed duplicate rows using `ROW_NUMBER()`.
* ✅ Trimmed whitespace from company and country names.
* ✅ Standardized inconsistent entries (e.g., "Crypto/Web3" → "Crypto").
* ✅ Converted `date` from text to proper `DATE` format.
* ✅ Handled `NULL` and blank values in columns like `industry`.
* ✅ Deleted irrelevant rows where `total_laid_off` and `percentage_laid_off` were both `NULL`.

### 4. Exploratory Data Analysis (EDA)

Used SQL queries to explore:

* Total layoffs by country, company, industry, and year.
* Companies with 100% layoffs.
* Time-based trends (monthly and rolling totals).
* Top 5 companies with the highest layoffs per year.

## 🔍 Key Insights

* Identified peak periods and countries most affected.
* Discovered top companies with the highest layoff percentages.
* Analyzed layoff trends across years and funding stages.

## 💻 Technologies Used

* MySQL (SQL queries for cleaning and EDA)
* CSV File (Input data)

## 🚀 How to Use

1. Clone this repository:

   ```
   git clone https://github.com/your-username/world_layoffs.git
   ```
2. Open MySQL Workbench or your preferred SQL IDE.
3. Run the script inside `scripts/data_cleaning_and_eda.sql` step-by-step.


