create database payoff;
use payoff;

select * from layoffs;


-- Total Layoffs per Company: Calculate the total number of employees laid off across all companies
select company, sum(total_laid_off) as Total_laid_off
from layoffs
where total_laid_off is not null
group by company
order by sum(total_laid_off) desc;
-- Total Layoffs per Industry: Find out which industry is most affected by layoffs.
select industry, sum(total_laid_off)
from layoffs
where total_laid_off is not null
group by industry
order by sum(total_laid_off) desc;
-- Total Layoffs by Country: Understand which countries are most affected by layoffs
select country, sum(total_laid_off)as Total_layoff
from layoffs
group by country
order by sum(total_laid_off) desc;
-- Average Layoff Percentage by Industry: See which industries tend to have the highest percentage of layoffs.
select industry, round(avg(percentage_laid_off),2) as percentage
from layoffs
where percentage_laid_off is not null
group by industry
order by round(avg(percentage_laid_off),2) desc;
-- Companies with the Highest Layoff Percentage: Identify companies with the highest workforce reduction.
select company, round(avg(percentage_laid_off),2)as percentage
from layoffs
where percentage_laid_off is not null
group by company
order by round(avg(percentage_laid_off),2) desc;
/* Layoffs by Company Stage (Post-IPO, Series, Acquired, etc.):
Analyze layoffs based on the company’s stage of funding or growth
*/ 
select stage, sum(total_laid_off) as Total_Laidoff
from layoffs
where total_laid_off and stage is not null
group by stage
order by sum(total_laid_off) desc;
-- Average Funding by Stage: Compare how much funding companies at different stages have raised on average.
select stage, round(avg(funds_raised_millions),2) as Avg_Funds
from layoffs
group by stage
order by round(avg(funds_raised_millions),2) desc;
-- Layoffs over Time: Track how layoffs have varied over time (by year).
SELECT year, sum(total_laid_off) as total_laidoff
from layoffs
group by year
order by year;

-- Disable Safe Mode Temporarily that we can delete unwanted rows
set sql_safe_updates = 0;

-- delete null values from date column
DELETE FROM layoffs
WHERE date IS NULL OR date = '';

-- create month and year columns
ALTER TABLE layoffs
ADD COLUMN month INT,
ADD COLUMN year INT;

-- add data in year and month column from date column
update layoffs
set month = month(date),
year = year(date);
 
 -- add month name column
 alter table layoffs
 add column Month_Name varchar(50);
 
 -- fetch month name from date column
 update layoffs
 SET Month_Name = MONTHNAME(DATE);


-- Layoffs by Month
select month_name, sum(total_laid_off) as total_laidoff
from layoffs
group by month_name
order by sum(total_laid_off) desc ;
-- Top Funded Companies: Identify companies that have raised the most funding.
select company, sum(funds_raised_millions)as total_funds_raised
from layoffs
group by company
order by sum(funds_raised_millions) desc;

/* Correlation Between Funding and Layoffs: See if there's a correlation between
how much funding a company has raised and the number of employees they laid off.
*/
select company,sum(total_laid_off) as total_laidoff, sum(funds_raised_millions) as tota_funds_raised
from layoffs
where total_laid_off is not null
group by company
order by sum(funds_raised_millions) desc;
-- Most Impacted Industry: Identify which industry has experienced the most layoffs.
select industry, sum(total_laid_off) as total_laidoff
from layoffs
where total_laid_off is not null
group by industry
order by sum(total_laid_off) desc
limit 5;
-- Companies in Specific Industries: Filter companies within a specific industry (e.g., "Media") to explore layoffs.
select *from layoffs
where industry = "media";
-- Layoffs by City: Analyze which cities have the highest number of layoffs.
select location, sum(total_laid_off) as total_laid_off
from layoffs
where total_laid_off is not null
group by location
order by sum(total_laid_off) desc;
-- Layoffs by Country: Explore layoffs at a country level.
select country, sum(total_laid_off) as total_laid_off
from layoffs
where total_laid_off is not null
group by country
order by sum(total_laid_off) desc;
-- Count Records with Missing Layoff or Percentage Data: Find how many records have missing data in the total_laid_off or percentage_laid_off fields.
select count(*) as missing_values
from layoffs
where total_laid_off is null or percentage_laid_off is null;
-- analyze trends over time for layoffs and funding:
select year,month_name, sum(total_laid_off) as total_Liad_Off, sum(funds_raised_millions) as total_Funds
from layoffs
group by year,month_name, month
order by year, month;
-- Correlation Analysis
SELECT AVG(total_laid_off) AS avg_laid_off,
AVG(funds_raised_millions) AS avg_funds_raised,
round(AVG(percentage_laid_off),2) AS avg_percentage_laid_off
FROM layoffs;
-- compare average layoffs and funds raised across different industries:
select industry, avg(total_laid_off) as avg_laid_off,
avg(funds_raised_millions) as avg_fund_raised
from layoffs
where industry is not null
group by industry
order by avg(total_laid_off) desc;
-- Analyzing layoffs and funding amounts based on the company stage:
select stage, avg(total_laid_off) as avg_laid_off,
avg(funds_raised_millions) as avg_fund_raised
from layoffs
where stage is not null
group by stage
order by avg(total_laid_off) desc;
-- To analyze layoffs and funding based on country or location:
select country, avg(total_laid_off) as avg_laid_off,
avg(funds_raised_millions) as avg_fund_raised
from layoffs
group by country
order by avg(total_laid_off) desc;
-- Missing Values Analysis
SELECT 
COUNT(*) AS total_rows,
COUNT(total_laid_off) AS non_null_laid_off,
COUNT(percentage_laid_off) AS non_null_percentage_laid_off,
COUNT(funds_raised_millions) AS non_null_funds_raised
FROM layoffs;
