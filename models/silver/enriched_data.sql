WITH bronze_data AS (
    SELECT * FROM {{ ref('transform_data') }}
)
SELECT
    id,
    cleaned_name,
    age,
    CASE 
        WHEN age < 30 THEN 'young'
        WHEN age BETWEEN 30 AND 40 THEN 'adult'
        ELSE 'senior'
    END AS age_group,
    COUNT(id) OVER (PARTITION BY 
        CASE 
            WHEN age < 30 THEN 'young'
            WHEN age BETWEEN 30 AND 40 THEN 'adult'
            ELSE 'senior'
        END
    ) AS age_count
FROM bronze_data
