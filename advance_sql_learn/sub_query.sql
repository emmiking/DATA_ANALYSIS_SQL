SELECT *
FROM (--SubQuery starts here
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
    ) AS january_jobs;
--SubQuery ends here

WITH january_jobs AS (-- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
) --CTE definition ends here

SELECT *
FROM january_jobs;