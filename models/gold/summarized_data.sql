WITH silver_data AS (
    SELECT * FROM {{ ref('enriched_data') }}
)
SELECT
    age_group,
    SUM(age_count) AS total_count
FROM silver_data
GROUP BY age_group
