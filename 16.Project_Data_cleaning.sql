-- DATA CLEANING PROJECT 
CREATE DATABASE world_layoffs;
USE world_layoffs;

CREATE TABLE layoffs (
company	text,
location text,
industry text,
total_laid_off int,
percentage_laid_off float,
date text,
stage text,
country text,
funds_raised_millions int
);

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE '/Users/mansi/Downloads/layoffs.csv' INTO TABLE layoffs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES; 

SELECT * 
FROM layoffs;
SELECT COUNT(*) AS row_count FROM layoffs;

-- copy of the original data so that the original data doesn't gets hamper
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_staging;

 -- steps to clean the data
 -- 1.Remove Duplicates
 -- 2.Standardize the data
 -- 3.NULL values or Blank Values
 -- 4.Remove any columns
 
-- step 1) Removing the duplicates
WITH duplicate_cte AS
(
SELECT * , ROW_NUMBER() OVER(
PARTITION BY company , location , industry , total_laid_off , percentage_laid_off , `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging 
WHERE company = 'casper';

-- making another table to put the columns and the data that are present in the layoffs_staging
CREATE TABLE layoffs_staging2
LIKE layoffs_staging;

ALTER TABLE layoffs_staging2
ADD COLUMN row_num int ;

INSERT INTO layoffs_staging2
SELECT * , ROW_NUMBER() OVER(PARTITION BY company,location , industry , total_laid_off , percentage_laid_off , `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- standardizing data (finding issues and fixing it)
SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT  *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- NUll values or blank values

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Updated the blank spaces to null 
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = "Bally's Interactive";

-- after updating the blank spaces to null we actually write the code to copy industry
SELECT * 
FROM layoffs_staging2 AS t1
JOIN  layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- this is the update statement through which we are updating and Filling the null spaces in the industry
UPDATE layoffs_staging2 t1
JOIN  layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL
;

-- DELETING ROWS
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

 
 
