# Introduction
Dive into the data job market! Focusing on data analyst roles, this project exploores top paying jobs, in demand skills and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

## The questions i wanted to answer through my sql queries were:
1.  What are the top-paying data analyst jobs?
2.  What skills are required for these top-paying jobs?
3.  What skills are most in demand for data analyst?
4.  Which skills are associated with higher salaries?
5.  What tools are the most optimal skills to learn?

# Tools I Used

## 📌 SQL

Purpose: Structured Query Language (SQL) is the foundation for working with relational databases.

#### Usage in Project:

1.  Querying datasets

2.  Performing aggregations and joins

3.  Cleaning and transforming data

#### Why Important: SQL is essential for extracting insights from structured data efficiently.

# 🐘 PostgreSQL
Purpose: PostgreSQL is an advanced, open-source relational database system.

Usage in Project:

1.  Hosting and managing the job dataset

2.  Running complex queries and transactions

3.  Ensuring data integrity and scalability

#### Why Important: PostgreSQL provides robustness, flexibility, and support for advanced features like window functions and JSON data.

# 💻 Visual Studio Code (VS Code)
Purpose: A lightweight yet powerful code editor.

#### Usage in Project:

1.  Writing and testing SQL queries

2.  Managing scripts and documentation

3.  Integrating extensions for PostgreSQL and GitHub

#### Why Important: VS Code enhances productivity with debugging, syntax highlighting, and seamless integration with version control.

# 🌐 GitHub
Purpose: A platform for version control and collaboration.

#### Usage in Project:

1.  Hosting project files and documentation

2.  Tracking changes with Git

3.  Collaborating via pull requests and issues

#### Why Important: GitHub ensures transparency, teamwork, and easy sharing of code with the community.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here is how i approach each questions:

### 1. Top paying Data analyst Jobs

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact 
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### 2.  Skills are required for top-paying jobs

```sql
WITH top_paying_jobs AS (
    
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact 
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;
```


### 3.  Skills in demand for data analyst jobs.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = true
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

### 4.  Skills associated with higher salaries jobs.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = true
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```

### 5.  Optimal skills to learn to land a high paying jobs.

```sql
WITH skills_demand AS (
    SELECT 
        skills_job_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = true
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
),average_salaries AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = true
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salaries ON skills_demand.skill_id = average_salaries.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;
```

# Conclusions

This project demonstrates how combining SQL, PostgreSQL, VS Code, and GitHub creates a powerful workflow for managing and analyzing job datasets. By leveraging SQL queries to extract insights, PostgreSQL to store and process structured data, VS Code as a flexible development environment, and GitHub for collaboration and version control, we establish a complete ecosystem for data-driven projects.

Through this work, we not only practice technical skills but also gain valuable understanding of real-world job market trends. The project serves as both a learning resource and a foundation for future enhancements, such as advanced analytics, visualization dashboards, or predictive modeling.