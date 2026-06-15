USE ChurnProject;

-- Whole Table

SELECT*
FROM bank_churn;

-- Overall Churn Rate
SELECT AVG(churn*1.0)*100 AS overall_rate_pct
FROM bank_churn;

-- Churn Rate by Country
SELECT country, COUNT(*) AS customers, SUM(churn) AS churned, AVG(churn*1.0)*100 AS churn_rate_pct_c
FROM bank_churn
GROUP BY country
ORDER BY churn_rate_pct_c DESC;

-- Churn Rate by Gender
SELECT gender, COUNT(*) AS customers, SUM(churn) AS churned, AVG(churn*1.0)*100 AS churn_rate_pct_g
FROM bank_churn
GROUP BY gender
ORDER BY churn_rate_pct_g DESC;

-- Churn Rate by Age Group

WITH grouped AS (
	SELECT *,
		CASE
			WHEN age < 30 then '18-29'
			WHEN age < 40 then '30-39'
			WHEN age < 50 then '40-49'
			WHEN age < 60 then '50-59'
			ELSE '60+'
		END AS age_group
	FROM bank_churn
)

SELECT age_group, COUNT(*) AS customers, SUM(churn) AS churned, AVG(churn * 1.0) * 100 AS churn_rate_pct
FROM grouped
GROUP BY age_group
ORDER BY age_group;

-- Churn Rate by Product Number
SELECT products_number, COUNT(*) AS customers, SUM(churn) AS churned, AVG(churn * 1.0) * 100 AS churn_rate_pct
FROM bank_churn
GROUP BY products_number
ORDER BY products_number;
-- 3-4 products have a lot of churn, look into causes. Maybe more products are offered as people try to leave, investigate more

-- Churn Rate by Active/Non-Active Members
SELECT active_member, COUNT(*) AS customers, SUM(churn) AS churned, AVG(churn * 1.0) * 100 AS churn_rate_pct
FROM bank_churn
GROUP BY active_member;
-- Almost double the number of churners are inactive

-- Churn Rate by Credit Score Decile
WITH scored AS (
    SELECT churn,
           credit_score,
           NTILE(10) OVER (ORDER BY credit_score) AS score_decile
    FROM bank_churn
)
SELECT score_decile, MIN(credit_score) AS min_score, MAX(credit_score) AS max_score, COUNT(*) AS customers, AVG(churn * 1.0) * 100 AS churn_rate_pct
FROM scored
GROUP BY score_decile
ORDER BY score_decile;

-- Churn Rate by Gender and Country
SELECT country, gender, COUNT(*) AS customers, SUM(churn) AS churned, AVG(churn * 1.0) * 100 AS churn_rate_pct
FROM bank_churn
GROUP BY country, gender
ORDER BY country, gender;