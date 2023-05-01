									/* [ SQL Analysis Project ] */

/* Create Database */

CREATE DATABASE Company;

/* Use that Database */

use Company;

/* Create Job Table */

CREATE TABLE jobs(
	id INTEGER,
	work_year INTEGER,
	experience_level VARCHAR(20),
	employment_type VARCHAR(20),
	job_title VARCHAR(20),
	salary INTEGER,
	salary_currency VARCHAR(20),
	salary_in_usd INTEGER,
	employee_residence VARCHAR(20),
	remote_ratio INTEGER,
	company_location VARCHAR(20),
	company_size VARCHAR(20)
);

/* Create Companies Table */

CREATE TABLE companies(
id INTEGER,
company_name VARCHAR(20)
);

SELECT * FROM jobs;

SELECT * FROM companies;

								/* Task 1:- Basic Analysis (Queries) */

/* 1) What is the average salary for all the jobs in the dataset? */

SELECT AVG(salary) AS avg_salary FROM jobs;

/* 2) What is the highest salary in the dataset and Which job role does it correspond to? */

SELECT MAX(salary) AS highest_salary, job_title FROM jobs; 

/* 3) What is the average salary for Data Scientist in US? */

SELECT AVG(salary) AS avg_salary FROM jobs
WHERE job_title = "Data Scientist" AND company_location = "US";

/* 4) What is the number of jobs available for each job title? */

SELECT job_title, COUNT(*) AS num_jobs FROM jobs GROUP BY job_title;

/* 5) What is the total salary paid for all Data Analyst jobs in DE(Location)? */

SELECT SUM(salary) AS total_salary_paid FROM jobs 
WHERE job_title = "Data Analyst" AND company_location = "DE";

/* 6) What are the TOP 5 highest paying job titles and their corresponding average salaries? */

SELECT job_title, AVG(salary) AS avg_salary FROM jobs
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 5; 

/* 7) What is the Number of jobs available in each location? */

SELECT company_location, COUNT(*) as no_of_jobs FROM jobs
GROUP BY company_location;

/* 8) What are the TOP 3 job titles that have the most jobs available in dataset? */

SELECT job_title, COUNT(*) as no_of_jobs FROM jobs
GROUP BY job_title
ORDER BY no_of_jobs DESC
LIMIT 3; 

/* 9) What is the average salary for Data Engineers in US? */

SELECT AVG(salary) AS avg_salary, job_title FROM jobs
WHERE job_title = "Data Engineer" AND company_location = "US";

/* 10) What are the TOP 5 cities with the highest average salaries? */

SELECT company_location, AVG(salary) AS avg_salary FROM jobs
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 5;

								/* Task 2:- Moderate Analysis (Queries) */

/* 1) What is the average salary for each job title, and 
What is the total number of jobs available for each job title? */

SELECT job_title, AVG(salary) AS avg_salary, COUNT(*) AS no_of_jobs FROM jobs
GROUP BY job_title;  

/* 2) What are the TOP 5 job titles with the highest total salaries, and 
What is the total number of jobs available for each job title? */

SELECT job_title, SUM(salary) AS total_salary, COUNT(*) AS no_of_jobs FROM jobs
GROUP BY job_title
ORDER BY total_salary DESC
LIMIT 5;

/* 3) What are the TOP 5 locations with the highest total salaries, and 
What is the total number of jobs available for each location? */

SELECT company_location, SUM(salary) AS total_salary, 
COUNT(*) AS no_of_jobs FROM jobs
GROUP BY company_location
ORDER BY total_salary DESC
LIMIT 5;

/* 4) What is the average salary for each job title in each location, and 
What is the total number of jobs available for each job title in each location? */

SELECT job_title, company_location, AVG(salary) AS avg_salary,
COUNT(*) AS no_of_jobs FROM jobs
GROUP BY job_title, company_location;

/* 5) What is the average salary for each job title in each location, and 
What is the percentage of jobs available for each job title in each location? */

SELECT job_title, company_location, AVG(salary) AS average_salary, 
(COUNT(*) * 100 / (SELECT COUNT(*) FROM jobs WHERE company_location = j.company_location)) AS job_percentage 
FROM jobs j 
GROUP BY job_title, company_location;

/* 6) What are the TOP 5 job titles with the highest average salaries, and 
What is the total number of jobs available for each job title? */

SELECT job_title, AVG(salary) as avg_salary,
COUNT(*) AS no_of_jobs FROM jobs
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 5;

/* 7) What is the average salary for each job title, and 
What is the percentage of jobs available for each job title in the dataset? */

SELECT job_title, AVG(salary) as avg_salary,
(COUNT(*) *100 / (SELECT COUNT(*) FROM jobs)) AS job_percentage FROM jobs
GROUP BY job_title;

/* 8) What is the total number of jobs available for each year of experience, and 
What is the average salary for each year of experience? */

SELECT experience_level, COUNT(*) as no_of_jobs,
AVG(salary) AS avg_salary FROM jobs
GROUP BY experience_level;

/* 9) What are the job titles with the highest average salaries in each location? */

SELECT job_title, company_location, AVG(salary) as avg_salary 
FROM jobs WHERE job_title IN 
(SELECT job_title FROM jobs GROUP BY job_title 
ORDER BY AVG(salary) DESC)
GROUP BY job_title, company_location;


								/* Task 3:- Advance Analysis (Queries) */

/* 1) What are the TOP 5 job titles with the highest salaries, and 
What is the name of the company that offers the highest salary for each job title? */

SELECT job_title, MAX(salary) as highest_salary, company_name 
FROM jobs
INNER JOIN companies
ON jobs.id = companies.id
GROUP BY job_title
ORDER BY highest_salary DESC
LIMIT 5; 

/* 2) What is the total number of jobs available for each job title, and 
What is the name of the company that offers the highest salary for each job title? */

SELECT job_title, COUNT(*) as no_of_jobs , company_name
FROM jobs
INNER JOIN companies
ON jobs.id = companies.id
WHERE salary = (SELECT MAX(salary) FROM jobs)
GROUP BY job_title, company_name;
;

/* 3) What are the TOP 5 cities with the highest average salaries, and 
What is the name of the company that offers the highest salary for each city? */

SELECT company_location, AVG(salary) AS avg_salary, company_name
FROM jobs
INNER JOIN companies
ON jobs.id = companies.id
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 5;

/* 4) What is the average salary for each job title in each company, and 
What is the rank of the each job title within each company based on the average salary? */

SELECT job_title, AVG(salary) AS avg_salary, company_name,
RANK() OVER (PARTITION BY company_name ORDER BY AVG(salary) DESC) AS salary_rank
FROM jobs
INNER JOIN companies
ON jobs.id = companies.id
GROUP BY job_title, company_name; 

/* 5) What is the total number of jobs available for each job title in each location,and 
What is the rank of each job title within each location based on the total number of jobs? */

SELECT job_title, company_location, COUNT(*) AS no_of_jobs,
RANK() OVER (PARTITION BY company_location ORDER BY COUNT(*) DESC) AS job_rank
FROM jobs
GROUP BY job_title, company_location;

/* 6) What are the TOP 5 companies with highest average salaries for Data Scientist positions, and 
What is the rank of each company based on the average salary? */

SELECT company_name, AVG(salary) AS avg_salary,
RANK() OVER (ORDER BY AVG(salary) DESC) AS salary_rank 
FROM jobs
INNER JOIN companies 
ON jobs.id = companies.id
WHERE job_title = 'Data Scientist'
GROUP BY company_name
ORDER BY avg_salary DESC
LIMIT 5;

/* 7) What is the total number of jobs available for each year of experience in each location, and 
What is the rank of each year of experience within each location based on the total number of jobs? */

SELECT experience_level, company_location, COUNT(*) as no_of_jobs,
RANK() OVER (PARTITION BY company_location ORDER BY COUNT(*) DESC) AS experience_rank
FROM jobs
GROUP BY experience_level, company_location;


										/* [ THANK YOU ] */