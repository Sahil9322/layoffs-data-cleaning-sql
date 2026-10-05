# 📊 Layoffs Data Cleaning Using SQL

## 📌 Project Overview

This project focuses on **cleaning and preparing a layoffs dataset using MySQL**.

The main objective of this project is to take raw and potentially inconsistent layoffs data and transform it into a cleaner, more reliable dataset that can be used for further **data analysis and visualization**.

The project demonstrates practical SQL data-cleaning techniques such as:

* Removing duplicate records
* Standardizing inconsistent data
* Handling NULL and blank values
* Correcting data formats and data types
* Updating missing information using existing records
* Removing unnecessary columns
* Creating staging tables to protect the original dataset

This project was created as part of my **Data Analytics learning journey** to strengthen my practical SQL and data-cleaning skills.

---

## 🎯 Project Objective

The primary goal of this project is to clean the layoffs dataset before performing any further analysis.

Raw datasets often contain problems such as:

* Duplicate records
* Extra spaces
* Inconsistent industry names
* Incorrect country formatting
* Dates stored as text
* Missing values
* Blank values
* Unnecessary helper columns

The purpose of this project is to identify and fix these issues using SQL.

---

## 🗂️ Dataset

The dataset used in this project is a **company layoffs dataset** containing information related to layoffs.

The data includes fields such as:

| Column                  | Description                             |
| ----------------------- | --------------------------------------- |
| `company`               | Name of the company                     |
| `location`              | Location of the company                 |
| `industry`              | Industry/category of the company        |
| `total_laid_off`        | Total number of employees laid off      |
| `percentage_laid_off`   | Percentage of employees laid off        |
| `date`                  | Date of the layoff                      |
| `stage`                 | Company funding/business stage          |
| `country`               | Country where the company is located    |
| `funds_raised_millions` | Funds raised by the company in millions |

---

# 🧹 Data Cleaning Process

## 1. Creating a Staging Table

Instead of directly modifying the original `layoffs` table, I created a staging table.

```sql
CREATE TABLE layoffs_staging
LIKE layoffs;
```

The data was then copied from the original table into the staging table.

This approach helps preserve the original dataset while performing cleaning operations on a separate copy.

---

## 2. Identifying Duplicate Records

Duplicate records can affect the accuracy of analysis.

I used the `ROW_NUMBER()` window function along with `PARTITION BY` to identify duplicate records.

```sql
ROW_NUMBER() OVER(
    PARTITION BY company,
                 location,
                 industry,
                 total_laid_off,
                 percentage_laid_off,
                 date,
                 stage,
                 country,
                 funds_raised_millions
) AS row_num
```

Records where `row_num > 1` were treated as duplicates.

---

## 3. Removing Duplicate Records

To safely remove duplicates, I created another staging table containing the generated row number.

After identifying duplicate records, I deleted rows where:

```sql
row_num > 1
```

This ensured that only the required unique records remained in the cleaned dataset.

---

## 4. Standardizing Company Names

Company names can sometimes contain unnecessary spaces.

I used the `TRIM()` function to remove leading and trailing spaces.

```sql
UPDATE layoffs_staging3
SET company = TRIM(company);
```

This improves consistency and makes future analysis more reliable.

---

## 5. Standardizing Industry Names

I checked the unique industry values and found variations beginning with `crypto`.

For example, different values related to crypto were standardized into:

```text
crypto
```

This was done using:

```sql
UPDATE layoffs_staging3
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';
```

Standardizing categories prevents the same industry from being treated as multiple separate categories during analysis.

---

## 6. Cleaning Country Names

I checked country values for formatting inconsistencies.

Some United States values contained an unnecessary trailing period.

I used:

```sql
TRIM(TRAILING '.' FROM country)
```

to remove the extra character.

This helped standardize country names.

---

## 7. Converting Date Values

The `date` column was initially stored as text.

I converted the text into a proper MySQL date format using:

```sql
STR_TO_DATE(date, '%m/%d/%Y')
```

Then I changed the column's data type to:

```sql
DATE
```

This makes the date column suitable for sorting, filtering, grouping, and time-based analysis.

---

## 8. Identifying NULL and Blank Values

I checked the dataset for missing values in important columns.

For example:

```sql
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

I also checked for missing or blank industry values.

This helped identify records that required additional cleaning.

---

## 9. Filling Missing Industry Values

Some records had a missing industry value even though another record belonging to the same company contained the industry information.

I used a self-join to compare records from the same company.

```sql
JOIN layoffs_staging3 t2
ON t1.company = t2.company
```

Then I used the available industry value to update the missing value.

This allowed existing information within the dataset to be used instead of unnecessarily leaving the field blank.

---

## 10. Converting Blank Values to NULL

Blank industry values were converted to actual `NULL` values.

```sql
UPDATE layoffs_staging3
SET industry = NULL
WHERE industry = '';
```

This creates consistent handling of missing data.

---

## 11. Removing Records Without Useful Layoff Information

After checking the dataset, records where both:

```text
total_laid_off = NULL
percentage_laid_off = NULL
```

were removed.

These records did not contain useful information about the scale of layoffs.

```sql
DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

---

## 12. Removing the Helper Column

The `row_num` column was only required during the duplicate-removal process.

After completing the cleaning process, it was removed:

```sql
ALTER TABLE layoffs_staging3
DROP COLUMN row_num;
```

This leaves the final table with only the required dataset columns.

---

# 🛠️ SQL Concepts Used

This project helped me practice several important SQL concepts:

* `SELECT`
* `INSERT`
* `UPDATE`
* `DELETE`
* `CREATE TABLE`
* `ALTER TABLE`
* `DROP COLUMN`
* `TRIM()`
* `LIKE`
* `DISTINCT`
* `IS NULL`
* `STR_TO_DATE()`
* `ROW_NUMBER()`
* `PARTITION BY`
* `JOIN`
* Common Table Expressions (CTEs)
* Window Functions
* Data Type Conversion
* Data Cleaning Techniques
* Staging Tables

---

# 🔄 Data Cleaning Workflow

```text
Raw Layoffs Dataset
        ↓
Create Staging Table
        ↓
Copy Raw Data
        ↓
Identify Duplicates
        ↓
Remove Duplicates
        ↓
Standardize Company Names
        ↓
Standardize Industry Values
        ↓
Clean Country Names
        ↓
Convert Date Format
        ↓
Identify NULL / Blank Values
        ↓
Fill Missing Industry Values
        ↓
Remove Records Without Layoff Information
        ↓
Remove Helper Column
        ↓
Clean Dataset
```

---

# 📈 Final Outcome

After completing the cleaning process, the dataset is better prepared for further analysis.

The cleaning process addressed:

✅ Duplicate records
✅ Inconsistent company names
✅ Inconsistent industry categories
✅ Country formatting issues
✅ Incorrect date format
✅ Missing industry values
✅ Blank values
✅ Records without useful layoff information
✅ Temporary/helper columns

The resulting dataset can be used for further exploratory data analysis and visualization.

---

# 💡 Key Learnings

Through this project, I learned how important data cleaning is before performing analysis.

Some of my key learnings include:

1. **Raw data is rarely analysis-ready.**
2. Duplicate records can produce incorrect analytical results.
3. Standardizing categorical data is important for accurate grouping.
4. Missing values need to be examined before deciding how to handle them.
5. SQL window functions such as `ROW_NUMBER()` are extremely useful for identifying duplicates.
6. `JOIN` operations can help recover missing information from related records.
7. Correct data types are important for analysis.
8. Staging tables provide a safer way to perform data-cleaning operations.
9. Cleaning data carefully improves the reliability of future analysis.

---

# 🚀 Future Improvements

This project currently focuses mainly on **data cleaning**.

Possible future improvements include:

* Performing Exploratory Data Analysis (EDA)
* Finding companies with the highest layoffs
* Analyzing layoffs by industry
* Analyzing layoffs by country
* Analyzing layoffs over time
* Finding companies with the highest percentage of layoffs
* Studying layoffs by company stage
* Creating dashboards using Power BI or Tableau
* Creating visualizations from the cleaned dataset

---

# 📁 Project Structure

```text
Layoffs-Data-Cleaning-SQL/
│
├── data cleaning.sql
│
└── README.md
```

---

# 🧑‍💻 Tools & Technologies

**Database:** MySQL
**Language:** SQL
**Tool:** MySQL Workbench
**Project Type:** Data Cleaning / Data Analytics

---

# 👨‍💻 About the Project

This project is part of my journey toward becoming a **Data Analyst**.

It demonstrates my ability to work with raw datasets, identify data-quality issues, and use SQL to transform data into a cleaner and more analysis-ready format.

I focused on writing SQL queries that demonstrate practical data-cleaning techniques rather than simply querying the dataset.

---

## ⭐ Skills Demonstrated

`SQL` `MySQL` `Data Cleaning` `Data Preparation` `Data Quality` `Window Functions` `CTE` `JOINs` `NULL Handling` `Data Transformation` `Database Management`

## Dashbord 
<img width="1917" height="1025" alt="Screenshot 2026-10-05 205323" src="https://github.com/user-attachments/assets/f7f5d36c-974c-40f2-b4d6-a54aa912603f" />

<img width="1917" height="1018" alt="Screenshot 2026-10-05 205347" src="https://github.com/user-attachments/assets/aefe3fa3-9526-4dc7-b575-7c2eeebd3635" />

<img width="1917" height="1017" alt="Screenshot 2026-10-05 205419" src="https://github.com/user-attachments/assets/b04c943e-d5c6-4b03-b501-80f08fa0c586" />

<img width="1917" height="1020" alt="Screenshot 2026-10-05 205557" src="https://github.com/user-attachments/assets/8465234d-c1a8-4a9b-9aea-fdf3e03785a7" />


