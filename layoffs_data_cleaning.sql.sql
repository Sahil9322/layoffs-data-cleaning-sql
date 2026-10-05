-- DATA CLEANING

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values and blank values
-- 4. Remove any columns


CREATE TABLE layoffs_staging
LIKE layoffs;



SELECT *
FROM layoffs_staging;

insert layoffs_staging
SELECT *
FROM layoffs;




SELECT *,
row_number()over(partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
FROM layoffs_staging;


with duplicate_cte as 
(
SELECT *,
row_number()over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
where row_num >1;



SELECT *
FROM layoffs_staging
where company ='casper';

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




SELECT *
FROM layoffs_staging3;



insert into layoffs_staging3
SELECT *,
row_number()over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;



SELECT *
FROM layoffs_staging3
where row_num>1;



DELETE
FROM layoffs_staging3
where row_num >1;

SELECT *
FROM layoffs_staging3;



-- standardizing data


SELECT company,TRIM(company)
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET company=TRIM(company);

SELECT distinct industry
FROM layoffs_staging3
order by 1;

SELECT *
FROM layoffs_staging3
where industry like 'crypto%';

update layoffs_staging3
SET industry ='crypto'
where industry like 'crypto%';

SELECT DISTINCt industry
FROM layoffs_staging3;


SELECT distinct country ,trim(TRAILING '.' FROM country)
FROM layoffs_staging3
order by 1;

UPDATE layoffs_staging3
SET country =trim(TRAILING '.' FROM country)
where country like 'United States%';


SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET  `date`= STR_TO_DATE(`date`,'%m/%d/%Y')
;

SELECT `date`
FROM layoffs_staging3;

ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging3
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;

SELECT *
FROM  layoffs_staging3
where industry is NULL
or industry='';

SELECT *
FROM  layoffs_staging3
where company ='Airbnb';


SELECT t1.industry,t2.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
      ON t1.company=t2.company
   where (t1.industry is null or t1.industry ='')
   and t2.industry is not  null;
   
   update layoffs_staging3 t1
   JOIN layoffs_staging3 t2
      ON t1.company=t2.company
	set t1.industry =t2.industry
   where t1.industry is null 
   and t2.industry is not  null ;

UPDATE layoffs_staging3
SET industry =NULL
where industry ='';

SELECT *
FROM layoffs_staging3
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;


DELETE
FROM layoffs_staging3
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;


ALTER TABLE layoffs_staging3
DROP column row_num;


















