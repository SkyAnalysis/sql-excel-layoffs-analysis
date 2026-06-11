-- Data cleaning practice
-- USE database;

-- 1. Remove duplicate
-- 2. Standadize the data
-- 3. Remove null values or blank values
-- 4. Remove any columns

SELECT *
FROM layoffs;

-- Create a new table
CREATE TABLE layoff_stage
SELECT *
FROM layoffs;

-- Removing dublicates
SELECT *
FROM layoff_stage;

SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) as row_num
FROM layoff_stage;

WITH dublicates_row AS (
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) as row_num
FROM layoff_stage
)

SELECT * 
FROM dublicates_row
WHERE row_num > 1;




CREATE TABLE `layoff_stage2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoff_stage2
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) as row_num
FROM layoff_stage;

SELECT * 
FROM layoff_stage2
WHERE row_num > 1;

SELECT * 
FROM layoff_stage2
WHERE company = "casper";

DELETE
FROM layoff_stage2
WHERE row_num > 1;

SELECT *
FROM layoff_stage2;

-- Standadize the data
SELECT *
FROM layoff_stage2;

SELECT DISTINCT(country)
FROM layoff_stage2
ORDER BY 1;

SELECT company, TRIM(company)
FROM layoff_stage2;

UPDATE layoff_stage2
SET company = TRIM(company);


SELECT *
FROM layoff_stage2
WHERE country LIKE "United States%";

UPDATE layoff_stage2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";


UPDATE layoff_stage2
SET country = "United States"
WHERE country LIKE "United States%";


-- Removing nulls and blanks
SELECT *
FROM layoff_stage2;

SELECT *
FROM layoff_stage2
WHERE industry IS NULL OR industry = "";

SELECT *
FROM layoff_stage2
WHERE company = "airbnb";

UPDATE layoff_stage2
SET industry = NULL
WHERE industry = "";


SELECT *
FROM layoff_stage2 as t1
JOIN layoff_stage2 as t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = "")
	AND t2.industry IS NOT NULL;
    


UPDATE layoff_stage2 as t1
JOIN layoff_stage2 as t2
ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
    
    
    
SELECT *
FROM layoff_stage2
WHERE total_laid_off IS NULL;

DELETE
FROM layoff_stage2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- DATE

SELECT `date`, STR_TO_DATE(`date`, "%m/%d/%Y")
FROM layoff_stage2;

UPDATE layoff_stage2
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y");

ALTER TABLE layoff_stage2
MODIFY COLUMN `date` DATE;

ALTER TABLE layoff_stage2
DROP COLUMN row_num;
