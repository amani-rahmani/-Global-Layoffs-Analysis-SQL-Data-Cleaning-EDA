
-- data cleaning
-- removing duplicate 
-- standardizing the data
--  removing null values
-- remove uncessary data
SELECT * FROM layoffs;
CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT layoffs_copy 
SELECT * FROM layoffs;
-- creating a se
SELECT company, industry, total_laid_off,`date`,stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`,stage, country, funds_raised_millions) AS row_num
	FROM 
		layoffs_copy WHERE 
	row_num > 1;
--
CREATE TABLE `layoffs_noduplicate` (
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
  
--

SELECT*
FROM layoffs_noduplicate;
--
INSERT INTO layoffs_noduplicate
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_copy;
--
SELECT * FROM layoffs_noduplicate
WHERE row_num > 1;
--
DELETE  
FROM layoffs_noduplicate
WHERE row_num > 1;
-- Standarizing data

SELECT company,TRIM(company) FROM layoffs_noduplicate;

UPDATE layoffs_noduplicate
SET company = TRIM(company);

SELECT DISTINCT industry FROM layoffs_noduplicate
ORDER BY 1;

SELECT * FROM layoffs_noduplicate
WHERE industry LIKE'crypto%';

UPDATE layoffs_noduplicate
SET industry ='crypto'
WHERE industry Like 'crypto%';

UPDATE layoffs_noduplicate SET country=TRIM(TRAILING '.' FROM country)
WHERE country Like 'United States%';
SELECT STR_TO_DATE(`date`, '%Y/%m/%d')
FROM layoffs_noduplicate;


UPDATE layoffs_noduplicate
SET `date` =STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_noduplicate
MODIFY COLUMN `date` DATE;
-- null values
SELECT *
FROM layoffs_noduplicate
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT industry
FROM layoffs_noduplicate
WHERE industry IS NULL
OR industry ='';

SELECT ly1.industry,ly2.industry
FROM layoffs_noduplicate ly1
JOIN layoffs_noduplicate ly2
    ON ly1.company = ly2.company
WHERE (ly1.industry IS NULL OR ly1.industry='')
AND ly2.industry IS NOT NULL;

UPDATE layoffs_noduplicate ly1
JOIN layoffs_noduplicate ly2
    ON ly1.company = ly2.company
SET	ly1.industry= ly2.industry
WHERE (ly1.industry IS NULL OR ly1.industry='')
AND ly2.industry IS NOT NULL;

DELETE
FROM layoffs_noduplicate
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
ALTER TABLE layoffs_noduplicate
DROP COLUMN row_num;

DELETE
FROM layoffs_noduplicate
WHERE total_laid_off IS NULL;

DELETE
FROM layoffs_noduplicate
WHERE percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_noduplicate ;
-- EDA 
SELECT * 
FROM layoffs_noduplicate ;
-- what the biggest number of people laid off in one day 1200

SELECT MAX(total_laid_off)
FROM layoffs_noduplicate ;
-- which companies completly went under
SELECT *
FROM layoffs_noduplicate
WHERE  percentage_laid_off = 1;
-- which companies were making alot of money and still completly went under Britishvolt with 2.4B

SELECT *
FROM layoffs_noduplicate
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- layoffs_noduplicate
-- Companies with the biggest single Layoff ofc its FANG companies
SELECT company, total_laid_off
FROM layoffs_noduplicate
ORDER BY 2 DESC
LIMIT 5;
-- when did the layoff start
SELECT MIN('date'),MAX('date')
FROM layoffs_noduplicate;
-- what industry laid off the most people Consumer, 15580
SELECT industry,SUM(total_laid_off)
FROM layoffs_noduplicate
GROUP BY industry 
ORDER BY 2 DESC;
-- what country laid off the most people United States,85213

SELECT country,SUM(total_laid_off)
FROM layoffs_noduplicate
GROUP BY country 
ORDER BY 2 DESC;

-- what year were people laid off the most 2023 112277
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_noduplicate
GROUP BY YEAR(date)
ORDER BY 1 ASC;
--  rolling sum of layoffs by month
WITH Rolling_total AS
(
SELECT substring(`date`,1,7) as 'MONTH', SUM(total_laid_off) AS total_off
FROM layoffs_noduplicate
GROUP BY 'MONTH'
ORDER BY 1 ASC
)
SELECT 'MONTH', SUM(total_off)
 OVER(ORDER BY 'MONTH') AS rolling_total
FROM Rolling_total;
--  rolling sum of layoffs by country


SELECT country,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_noduplicate
GROUP BY country,YEAR(`date`)
ORDER BY country ASC;

--  rolling sum of layoffs by company
SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_noduplicate
GROUP BY company,YEAR(`date`)
ORDER BY company ASC;


WITH company_year AS
(
SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM layoffs_noduplicate
GROUP BY company,YEAR(`date`)
ORDER BY company ASC
)
SELECT *
FROM company_year;



